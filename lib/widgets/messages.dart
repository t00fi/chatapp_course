import 'package:chatapp_course/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('sentDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //create variable for snapshot and use it instead of snapshot
        final chatDoc = snapshot.data!.docs;
        return ListView.builder(
          //reverse scroling to up
          reverse: true,
          itemCount: chatDoc.length,
          itemBuilder: (ctx, index) => MessageBubble(
            sentMessage: chatDoc[index]['text'],
            isMe: chatDoc[index]['userId'] ==
                FirebaseAuth.instance.currentUser!.uid,
            //adding key because we know in the lists adding key is better for effevient.

            key: ValueKey(chatDoc[index].id),
          ),
        );
      },
    );
  }
}
