import 'dart:convert';
import 'package:banking3/welcome/regScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../pages/activity.dart';
import '../pages/home.dart';
import 'forgetpassword.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffb81736), Color(0xff105062)],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign in!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const forgetpassword(),
                          ),
                        );
                      },
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xffB81736), Color(0xff105062)],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          // DIRECT API call inside onTap
                          try {
                            final response = await http.post(
                              Uri.parse(
                                  'http://10.237.198.176:3000/api/users/login'),
                              headers: {"Content-Type": "application/json"},
                              body: jsonEncode({
                                "email": emailController.text.trim(),
                                "password": passwordController.text.trim(),
                              }),
                            );

                            if (response.statusCode == 200) {
                              final data = json.decode(response.body);

                              if (data['message'] == "Login successful") {
                                String userId = data['user_id'];
                                String role = data['role'];
                                String fullName = data['full_name'];

                                print(
                                    'Login Success! User ID: $userId, Role: $role, Name: $fullName');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Home(
                                        fullName: fullName), // pass fullName
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Login Failed: ${data['message']}')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Server Error: ${response.statusCode}')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Exception: $e')),
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 150),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Don't have account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> fetchData() async {
  try {
    final response = await http.get(Uri.parse('http://10.237.198.176:3000/'));
    if (response.statusCode == 200) {
      final message = response.body; // No json.decode here
      print('Response: $message'); // Just print the text
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}

// Future<void> loginUser(BuildContext context) async {
//   try {
//     final response = await http.post(
//       Uri.parse('http://10.237.198.176:3000/login'), // your login API endpoint
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "email": emailController.text.trim(),
//         "password": passwordController.text.trim(),
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//       if (data['message'] == "Login successful") {
//         String userId = data['user_id'];
//         String role = data['role'];
//         String fullName = data['full_name'];
//
//         print('Login Success! User ID: $userId, Role: $role, Name: $fullName');
//
//         // Navigate to Home screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const Home()),
//         );
//       } else {
//         print('Login failed: ${data['message']}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Login Failed: ${data['message']}')),
//         );
//       }
//     } else {
//       print('Error: ${response.statusCode}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Server Error: ${response.statusCode}')),
//       );
//     }
//   } catch (e) {
//     print('Exception: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Exception: $e')),
//     );
//   }
// }
