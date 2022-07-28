import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zuras_chat/widgets/picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function(String email, String password, String? username,
      File? image, bool isLogin, BuildContext ctx) submit;
  final isLoading;

  const AuthForm({required this.submit, required this.isLoading, Key? key})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogIn = true;

  String? _userName;
  String? _userMail;
  String? _password;
  File? _userImage;

  Future<void> _pickedImage(File image) async {
    _userImage = image;
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImage == null && !_isLogIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pick an image'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      await widget.submit(_userMail!.trim(), _password!.trim(),
          _userName?.trim(), _userImage, _isLogIn, context);
    }
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (!_isLogIn) UserImagePicker(imagePickFunction: _pickedImage),
              TextFormField(
                key: const ValueKey('Email'),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email address'),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Fill Email Field';
                  }

                  if (!value.contains('@')) {
                    return 'Invalid Email';
                  }
                  return null;
                }),
                onSaved: (value) {
                  _userMail = value;
                },
              ),
              if (!_isLogIn)
                TextFormField(
                  key: const ValueKey('Username'),
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill Username Field';
                    }
                    return null;
                  }),
                  onSaved: (value) {
                    _userName = value;
                  },
                ),
              TextFormField(
                key: const ValueKey('Password'),
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Fill Password Field';
                  }
                  if (value.length <= 4) {
                    return 'Field must contain at leat 4 characters';
                  }
                  return null;
                }),
                onSaved: (value) {
                  _password = value;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              if (widget.isLoading) const CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                  onPressed: _trySubmit,
                  child: Text(_isLogIn ? 'Login' : 'Sign Up'),
                ),
              if (!widget.isLoading)
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogIn = !_isLogIn;
                      });
                    },
                    child: Text(_isLogIn ? 'Create new account' : 'Log In'))
            ]),
          ),
        ),
      ),
    ));
  }
}
