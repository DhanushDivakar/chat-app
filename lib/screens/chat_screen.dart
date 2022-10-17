import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) =>
            Container(
              padding: EdgeInsets.all(8),
              child: Text("This"),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Firestore.instance.collection('chats/9puGk0rXF8PrXFifNlBI/messages')
              .snapshots()
              .listen((data) {
            print(data.documents[0]);
          }); //snapshots return a stream

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
