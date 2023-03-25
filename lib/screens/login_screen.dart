import 'package:flutter/material.dart';
import 'package:glancefrontend/components/background.dart';
import 'package:glancefrontend/models/wrapper/result.dart';
import 'package:glancefrontend/services/api/login_service.dart';
import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/screens/home_screen.dart';
import 'package:glancefrontend/services/local_storage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    LocalStorage.deleteAll();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create: (context) => LoginState(),
            builder: (context, child) {
              final provider = Provider.of<LoginState>(context);
              return Column(
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
                          fontSize: 28),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: usernameController,
                      onChanged: provider.setUserName,
                      decoration: const InputDecoration(labelText: "Username"),
                      cursorColor: const Color(0xFF2661FA),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: passwordController,
                      onChanged: provider.setPassword,
                      decoration: const InputDecoration(labelText: "Password", focusColor: Color(0xFF2661FA), hoverColor: Color(0xFF2661FA)),
                      obscureText: true,
                      cursorColor: const Color(0xFF2661FA),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select Role"),
                      onChanged: provider.setRole,
                      value: context.watch<LoginState>().role,
                      focusColor: const Color(0xFF2661FA),
                      items: const [
                        DropdownMenuItem<String>(
                          value: "Admin",
                          child: Text("Admin"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Officer",
                          child: Text("Officer"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Supervisor",
                          child: Text("Supervisor"),
                        ),
                        DropdownMenuItem<String>(
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
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: Row(
                                children: const [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 20),
                                  Text('Logging in...')
                                ],
                              ));
                            },
                            barrierDismissible: false);
                        late Result result;
                        LoginService.loginAsync(TokenRequest(
                                userName: provider.userName,
                                password: provider.password,
                                role: provider.role))
                            .then((value) => result = value)
                            .catchError((error) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $error')));
                          return result;
                        }).whenComplete(() => {
                                  Navigator.pop(context),
                                  if (result.succeeded)
                                    {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const HomeScreen())),
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Error: ${result.messages.first}}')))
                                    }
                                });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        backgroundColor: const Color(0xFF2661FA),
                      ),
                      child: const Text("LOGIN"),
                    ),
                  ),
                ],
              );
            },
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

class LoginState extends ChangeNotifier {
  String _userName = '';
  String _password = '';
  String _role = 'Admin';

  String get userName => _userName;
  String get password => _password;
  String get role => _role;

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setRole(String? role) {
    _role = role!;
    notifyListeners();
  }
}
