import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogIn = true;

  String? _userName;
  String? _userMail;
  String? _password;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
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
              ElevatedButton(
                onPressed: _trySubmit,
                child: Text(_isLogIn ? 'Login' : 'Sign Up'),
              ),
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
