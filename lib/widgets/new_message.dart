import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  //controller for  message field
  var _messageController = TextEditingController();
  //store entered meesage in var
  var _enteredMessage;
  //method to send a message
  void _sendMessage() {
    //adding firebase auth to send our user id.
    //get current user logged in.
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('chats').add(
      {
        'text': _enteredMessage,
        //timeStamp class is in cloud_firestore pacckage because it supprot timeStamp better than DateTime in Dart package.
        'sentDate': Timestamp.now(),
        'userId': currentUser!.uid,
      },
    );
    //clear the message controller after sending message.
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Send a Message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed:
                //if meesage is empty do nothing.
                _enteredMessage.toString().trim().isEmpty
                    ? () {}
                    : _sendMessage,
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
