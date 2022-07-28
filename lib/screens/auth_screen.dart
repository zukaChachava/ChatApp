import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuras_chat/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _submitAuthForm(String email, String password, String? username,
      File? image, bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        final result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        return;
      }

      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final path = await FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${authResult.user!.uid}.jpg');

      await path.putFile(image!);

      final url = await path.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'username': username,
        'email': email,
        'image_url': url,
      });

    } on PlatformException catch (err) {
      var message = 'An error occured';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(err.toString())));

      setState(() {
        _isLoading = false;
      });
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(submit: _submitAuthForm, isLoading: _isLoading),
    );
  }
}
