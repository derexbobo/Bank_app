import 'package:banking3/welcome/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Import the welcome screen
import 'pages/activity.dart';
import 'pages/home.dart';
import 'pages/my_card.dart';
import 'pages/profile.dart';
import 'pages/scan.dart';
import 'widgets/action_button.dart';
import 'widgets/transaction_list.dart';
import 'widgets/credit_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintech App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 16, 80, 98),
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Set WelcomeScreen as the home
    );
  }
}
