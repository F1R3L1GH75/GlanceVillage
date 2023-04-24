import 'package:flutter/material.dart';
import 'package:glancefrontend/components/background.dart';
import 'package:glancefrontend/models/wrapper/result.dart';
import 'package:glancefrontend/services/api/login_service.dart';
import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/screens/home_screen.dart';
import 'package:glancefrontend/services/local_storage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
              create: (context) => _LoginState(),
              builder: (context, child) {
                return _LoginBody();
              }),
        ),
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<_LoginState>(context);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: const Text(
          "Glance | LOGIN",
          style: TextStyle(
              color: Color(0xFF2661FA),
              fontSize: 28,
              fontWeight: FontWeight.w300),
          textAlign: TextAlign.left,
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
          controller: provider.usernameController,
          decoration: const InputDecoration(labelText: "Username"),
          cursorColor: const Color(0xFF2661FA),
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
          controller: provider.passwordController,
          decoration: const InputDecoration(
              labelText: "Password",
              focusColor: Color(0xFF2661FA),
              hoverColor: Color(0xFF2661FA)),
          obscureText: true,
          cursorColor: const Color(0xFF2661FA),
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Select Role"),
          onChanged: provider.setRole,
          value: provider.role,
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
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.lock_open_rounded),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2661FA),
            ),
            onPressed: () {
              provider.login(context);
            },
            label: const Text("LOGIN"),
          ))
    ]);
  }
}

class _LoginState extends ChangeNotifier {
  String _role = 'Admin';
  String get role => _role;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void setRole(String? role) {
    _role = role!;
    notifyListeners();
  }

  _LoginState() {
    LocalStorage.deleteAll();
  }

  Future<void> login(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('Logging in...'))
            ],
          ));
        },
        barrierDismissible: false);
    final userName = usernameController.text;
    final password = passwordController.text;
    try {
      final result = await LoginService.loginAsync(
          TokenRequest(userName: userName, password: password, role: _role));
      if (result.succeeded) {
        if (context.mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctx) => const HomeScreen()));
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${result.messages.first}')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
