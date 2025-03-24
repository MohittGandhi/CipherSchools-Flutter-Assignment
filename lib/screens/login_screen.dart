
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _login() async {
      final user = await AuthService().signInWithGoogle();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in with Google'),
          onPressed: _login,
        ),
      ),
    );
  }
}
