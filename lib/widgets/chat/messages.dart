import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:zuras_chat/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            userId: snapshot.data!.docs[index]['userId'],
            key: ValueKey(snapshot.data!.docs[index].id),
            imagePath: snapshot.data!.docs[index]['userImage'],
            message: snapshot.data!.docs[index]['text'],
            isMe: FirebaseAuth.instance.currentUser!.uid ==
                snapshot.data!.docs[index]['userId'],
          ),
        );
      },
    );
  }
}
