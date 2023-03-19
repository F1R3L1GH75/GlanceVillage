import 'package:flutter/material.dart';
import 'package:glancefrontend/components/background.dart';
import 'package:glancefrontend/services/api/login_service.dart';
import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/screens/home_screen.dart';
import 'package:glancefrontend/services/local_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'Admin';

  _submitForm() {
    String userName = usernameController.value.text;
    String password = passwordController.value.text;
    LoginService.loginAsync(
        TokenRequest(userName: userName, password: password, role: selectedRole))
        .then((result) => {
          if (result.succeeded) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const HomeScreen()))
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.messages.first)))
            }
        }
    );
  }

  @override
  void initState() {
    super.initState();
    LocalStorage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Glance | LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 28
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      labelText: "Username"
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: "Password"
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: DropdownButton(
                  isExpanded: true,
                  hint: const Text("Select Role"),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value.toString();
                    });
                  },
                  value: selectedRole,
                  items: const [
                    DropdownMenuItem(
                      value: "Admin",
                      child: Text("Admin"),
                    ),
                    DropdownMenuItem(
                      value: "Officer",
                      child: Text("Officer"),
                    ),
                    DropdownMenuItem(
                      value: "Supervisor",
                      child: Text("Supervisor"),
                    ),
                    DropdownMenuItem(
                      value: "DataEntry",
                      child: Text("DataEntry"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: _submitForm,

                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: const Color(0xFF2661FA),
                  ),
                  child: const Text("LOGIN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}