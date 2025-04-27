import 'package:flutter/material.dart';
import '../widgets/action_button.dart';
import '../widgets/credit_card.dart';
import '../widgets/transaction_list.dart';

class Home extends StatelessWidget {
  final String fullName; // 👈 Add this to receive full name

  const Home({super.key, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 80, 98),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back!",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        fullName, // 👈 Use the passed fullName here
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton.outlined(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 167),
                    color: Colors.white,
                    child: const Column(
                      children: [
                        SizedBox(height: 110),
                        ActionButtons(),
                        SizedBox(height: 30),
                        TransactionList(),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: 20,
                    left: 25,
                    right: 25,
                    child: CreditCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
