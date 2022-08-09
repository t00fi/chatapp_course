import 'package:chatapp_course/widgets/messages.dart';
import 'package:chatapp_course/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  //get the chat collection stream from firebase
  final streamDataMessages = FirebaseFirestore.instance
      .collection('chats/XkoHMRi0QqHVQL10Kt8P/messages')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: TextButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: const [
            //wrap message() widget in expanded because it uses listView.builder().
            //which will be error using in column widget.
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     //adding docs
      //     await FirebaseFirestore.instance
      //         .collection('chats/XkoHMRi0QqHVQL10Kt8P/messages')
      //         .add(
      //       {
      //         'text': 'ba button ziad kraya',
      //       },
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
