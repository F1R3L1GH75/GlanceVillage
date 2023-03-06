import 'package:flutter/material.dart';
import 'package:glancefrontend/pages/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: const SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: LoginForm()
          ),
        ),
      ),
    );
  }
}
