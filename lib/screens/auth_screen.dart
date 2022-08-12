import 'dart:io';

import 'package:chatapp_course/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //get the instance od authintication
  final _auth = FirebaseAuth.instance;
  //variable when we click on signUp before adding collection.
  //i want to see loading spinner.
  //pass is to authForm() widget because button are there.
  bool _isLoading = false;
  //this method will pass to the AuthForm Widget to get its paramaeters value.
  Future<void> _submitAuthForm(String email, String password, String username,
      File image, bool isLogin) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        //create user
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        ///upload image to storage firebase.
        ///1-we allowed create in storage rules
        ///2 it will auto creat folder with the name : user_images.
        ///3-each image name will be uid.jpg
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        ///then put the file.
        await ref.putFile(image);
        //get the url of image to store in users collection
        final image_url = await ref.getDownloadURL();
        //adding username and email tp collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': username,
            'email': email,
            'image_url': image_url,
          },
        );
      }
    } on PlatformException catch (err) {
      var message = 'An error has been occured, please check your credentials!';
      if (err.message != null) {
        message = err.message.toString();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      //get the index after ] bracket because before it is firebase message we dont need it
      var index = err.toString().indexOf(']', 0) + 1;
      //hide if there is before any snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //show new snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString().substring(index)),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      debugPrint('$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AuthForm(
        submitAuth: _submitAuthForm,
        isloading: _isLoading,
      ),
    );
  }
}
