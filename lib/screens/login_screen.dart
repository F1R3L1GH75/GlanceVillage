import 'package:flutter/material.dart';
import 'package:glancefrontend/api/login_service.dart';
import 'package:glancefrontend/components/shared_widget_configurations.dart';
import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(63, 63, 156, 1),
                    Color.fromRGBO(90, 70, 178, 1)
                  ],
                ),
              ),
              width: double.infinity,
              height: size.height * 0.4,
            ),
            SafeArea(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 30),
                child: const Icon(
                  Icons.person_pin,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.3),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 7,
                              offset: const Offset(0, 4),
                            )
                          ]),
                      child: const LoginForm()
                  ),
                  const SizedBox(height: 30),
                  const MaterialButton(
                    onPressed: null,
                    child: Text('Forgot password?'),
                  ),
                ],
              ),
            )
          ],
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

  _submitForm() {
    String userName = usernameController.value.text;
    String password = passwordController.value.text;
    LoginService.loginAsync(
        TokenRequest(userName: userName, password: password))
        .then((result) => {
          if (result.succeeded) {
            Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => const HomeScreen()))
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.messages.first)))
          }
        });
  }
  @override
  Widget build(BuildContext context) {return Column(
    children: [
      const SizedBox(height: 25),
      Text('Login', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecorations.forTextFormField(
                  hintText: 'Admin',
                  labelText: 'User Name',
                  prefixIcon: Icons.alternate_email_rounded),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecorations.forTextFormField(
                  hintText: 'Admin@123',
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: _submitForm,
              color: Colors.purple,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 15),
                  child: const Text('LOGIN')),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    ],
  );
  }
}