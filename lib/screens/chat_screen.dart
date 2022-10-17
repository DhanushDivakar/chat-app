import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('chats/UqZ0rEVudeXXfZqMv6IM/messages')
              .snapshots()
          //this gives us a stream//this is a dart object which emits a new value whenever some data source changes
          ,
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshot.data.documents;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(8),
                child: Text(documents[index]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Firestore.instance.collection('chats/UqZ0rEVudeXXfZqMv6IM/messages').add({
            'text': 'This was added by clikking the button'
          });
          //     .listen((data) {
          //   data.documents.forEach((document) {
          //     print(document['text']);
          //   });
          //   // print(data.documents[0]['text']);
          // }); //snapshots return a stream
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
