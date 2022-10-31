import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
      String email,
      String password,
      String username,
      File image,
      bool isLogin,
      BuildContext ctx,
      ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}


// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../widgets/auth/auth_form.dart';
//
// class AuthScreen extends StatefulWidget {
//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   final _auth = FirebaseAuth
//       .instance; //this will give instance of the firebase auth object
//   var _isLoading = false;
//
//     void _submitAuthForm(
//     String email,
//     String username,
//     String password,
//     File image,
//     bool isLogin,
//     BuildContext ctx,
//   ) async {
//     AuthResult authResult;
//
//     try {
//       setState((){
//         _isLoading = true;
//       });
//
//       if (isLogin) {
//         authResult = await _auth.signInWithEmailAndPassword(
//             email: email, password: password);
//       } else {
//         authResult = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//        final ref =  FirebaseStorage.instance.ref().child('user_image').child(authResult.user.uid + '.jpg' );//ref will point to root bucket//child will alow us to set up the new path and that allows us to control where we want to store our file or from where we wan to read the file
//         await ref.putFile(image).onComplete;//oncomple gives a future which we can await
//         await Firestore.instance
//             .collection('users')
//             .document(authResult.user.uid)
//             .setData({
//           'username': username,
//           'email': email,
//         }); //add mentod adds new user id but we dont want tht hence  we use doucment to store in the exisiting user
//         //setData s used to store extra data
//       }
//     } on PlatformException catch (err) {
//       var message = "An error occurred, please check your credentials";
//       if (err.message != null) {
//         message = err.message;
//       }
//       Scaffold.of(ctx).showSnackBar(SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(ctx).errorColor,
//       ));
//       setState((){
//         _isLoading = false;
//       });
//     } catch (err) {
//       print(err);
//       setState((){
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: AuthForm(_submitAuthForm, _isLoading),
//     );
//   }
// }
