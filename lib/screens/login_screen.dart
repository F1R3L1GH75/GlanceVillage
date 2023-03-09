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
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(body: Container(
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
                child: const Icon(Icons.person_pin, color: Colors.white, size: 100,),
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
                      ]
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Text('Login', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecorations.forTextFormField(hintText: 'Admin', labelText: 'User Name', prefixIcon: Icons.alternate_email_rounded),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration: InputDecorations.forTextFormField(hintText: 'Admin@123', labelText: 'Password', prefixIcon: Icons.lock_outline),
                                ),
                                const SizedBox(height: 20),
                                MaterialButton(
                                  onPressed: () {
                                    String userName = usernameController.value.text;
                                    String password = passwordController.value.text;
                                    LoginService
                                        .loginAsync(TokenRequest(userName: userName, password: password))
                                        .then((result) => {
                                      if(result.succeeded) {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()))
                                      } else {
                                        ScaffoldMessenger
                                            .of(context)
                                            .showSnackBar(SnackBar(content: Text(result.messages.first)))
                                      }
                                    });
                                  },
                                  color: Colors.purple,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 15),
                                    child: const Text('LOGIN')
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
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

// class LoginForm extends StatefulWidget {
//   const LoginForm({Key? key}) : super(key: key);
//
//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }
//
// class _LoginFormState extends State<LoginForm> {
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final _formKey = GlobalKey<_LoginFormState>();
//
//   void submitForm() {
//     String userName = usernameController.value.text;
//     String password = passwordController.value.text;
//     LoginService
//         .loginAsync(TokenRequest(userName: userName, password: password))
//         .then((result) => {
//       if(result.succeeded) {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()))
//       } else {
//         ScaffoldMessenger
//             .of(context)
//             .showSnackBar(SnackBar(content: Text(result.messages.first)))
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 50),
//           const Text(
//             'Glance Village Hackathon',
//             style: TextStyle(color: Color.fromARGB(255, 9, 9, 9),fontSize: 25),
//           ),
//           const SizedBox(height: 50),
//
//           // logo
//           const Icon(Icons.lock,size: 100),
//
//           const SizedBox(height: 50),
//
//           Text(
//             'Welcome back you\'ve been missed!',
//             style: TextStyle(color: Colors.grey[700],fontSize: 16),
//           ),
//
//           const SizedBox(height: 25),
//
//           MyTextField(controller: usernameController,hintText: 'Username',obscureText: false),
//
//           const SizedBox(height: 10),
//
//           MyTextField(controller: passwordController,hintText: 'Password',obscureText: true),
//
//           const SizedBox(height: 10),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text('Forgot Password?',style: TextStyle(color: Colors.grey[600])),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 25),
//
//           MaterialButton(
//             color: Colors.grey[700],
//             textColor: Colors.white,
//             onPressed: submitForm,
//             child: const Text('LOGIN'),
//           ),
//
//           const SizedBox(height: 50),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Row(
//               children: [
//                 Expanded(child: Divider(thickness: 0.5,color: Colors.grey[400])),
//                 Expanded(child: Divider(thickness: 0.5,color: Colors.grey[400])),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }