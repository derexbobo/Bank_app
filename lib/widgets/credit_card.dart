import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreditCard extends StatefulWidget {
  final String userId; // <-- Pass the user ID here

  const CreditCard({super.key, required this.userId});

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  double balance = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    const String baseUrl = 'http://10.237.198.176:3000'; // change if needed
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/accounts/user/${widget.userId}'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('accounts') && data['accounts'].isNotEmpty) {
          double newBalance =
              double.tryParse(data['accounts'][0]['balance'].toString()) ?? 0.0;
          setState(() {
            balance = newBalance;
            isLoading = false;
          });
        }
      } else {
        print('Failed to fetch balance.');
      }
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 350,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: const Color.fromARGB(255, 14, 19, 29),
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Image.asset(
                        "assets/credit-card.png",
                        height: 40,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 70,
                      child: Image.asset(
                        "assets/wifi.png",
                        height: 50,
                        color: Colors.white,
                      ),
                    ),
                    const Positioned(
                      bottom: 16,
                      left: 16,
                      child: Text(
                        "**** **** **** 1990",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 16, 80, 98),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'LKR: ${balance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white.withOpacity(0.8),
                          ),
                          Transform.translate(
                            offset: const Offset(-10, 0),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
