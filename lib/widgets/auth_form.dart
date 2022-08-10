import 'dart:io';

import 'package:chatapp_course/pickers/user_image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.submitAuth, required this.isloading})
      : super(key: key);
  final Function submitAuth;
  final bool isloading;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //form key
  final _formKey = GlobalKey<FormState>();

  ///variables to get users input
  ///i will not call setstate method when changing these variable values.because we dont sho their value on UI we just need it for backend.
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  File? _userImage;
//to check we are in which mode.
//update button and ui with is.
  bool isLogin = true;

  //method to assign image file in _userImage var
  void _pickedImage(File image) {
    _userImage = image;
  }

  //submit method
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    //take all focus out from all inputs and close keyboard.
    FocusScope.of(context).unfocus();
    //check if no image uploaded return snackbar
    if (_userImage == null && !isLogin) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (!isValid) {
      return;
    }
    //it will cal onSaved() method in text field.
    _formKey.currentState!.save();
    //call the widget method which gives value to the parameters in authScreen() widget.
    //.trim() to avoid spaces at nd or other places.
    widget.submitAuth(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
        _userImage, isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                //take the height as much as needed(its children)
                mainAxisSize: MainAxisSize.min,
                children: [
                  //if we not login then we can pick an image for signup
                  if (!isLogin)
                    //image picker widget
                    UserImagePicker(
                      assignedPicture: _pickedImage,
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email address'),
                    //only allow numbers and letters and {@,dot}
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[0-9a-zA-Z@.]")),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email field is empty!';
                      }
                      if (!EmailValidator.validate(value, true)) {
                        return 'Email is not valid!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  //if we are in signup mode we dont need username field
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(labelText: 'Username'),
                      //only allow numbers and letters
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z]")),
                      ],
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'please enter at least 5 chracters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return 'Password must be at least 8 characters long!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  //some height size
                  const SizedBox(height: 12),
                  //check if is loading
                  if (widget.isloading) const CircularProgressIndicator(),
                  if (!widget.isloading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isloading)
                    TextButton(
                      onPressed: () {
                        //reverse the value
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? 'Create new account'
                            : 'Already have an account?',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
