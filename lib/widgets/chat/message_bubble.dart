import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.userId, this.isMe, {this.key});

  final Key key;

  final String message;
  final String userId;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(8),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(8),
            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            children: [
              FutureBuilder(
                future: Firestore.instance
                    .collection('users')
                    .document(userId)
                    .get(), //this will get the data of username
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Text('Loading..');
                  }
                  return Text(
                    snapshot.data['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
              Text(
                message,
                style: TextStyle(
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.subtitle1.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
