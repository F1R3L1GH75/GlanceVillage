import 'package:flutter/material.dart';
import 'package:glancefrontend/api/login_service.dart';
import 'package:glancefrontend/components/my_button.dart';
import 'package:glancefrontend/components/my_textfield.dart';
import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/screens/home.dart';

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

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<_LoginFormState>();

  void submitForm() {
    String userName = usernameController.value.text;
    String password = passwordController.value.text;
    LoginService
        .loginAsync(TokenRequest(userName: userName, password: password))
        .then((result) => {
      if(result.succeeded) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()))
      } else {
        ScaffoldMessenger
            .of(context)
            .showSnackBar(SnackBar(content: Text(result.messages.first)))
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            'Glance Village Hackathon',
            style: TextStyle(color: Color.fromARGB(255, 9, 9, 9),fontSize: 25),
          ),
          const SizedBox(height: 50),

          // logo
          const Icon(Icons.lock,size: 100),

          const SizedBox(height: 50),

          Text(
            'Welcome back you\'ve been missed!',
            style: TextStyle(color: Colors.grey[700],fontSize: 16),
          ),

          const SizedBox(height: 25),

          MyTextField(controller: usernameController,hintText: 'Username',obscureText: false),

          const SizedBox(height: 10),

          MyTextField(controller: passwordController,hintText: 'Password',obscureText: true),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Forgot Password?',style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),

          const SizedBox(height: 25),

          MyButton(onTap: submitForm),

          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(child: Divider(thickness: 0.5,color: Colors.grey[400])),
                Expanded(child: Divider(thickness: 0.5,color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}