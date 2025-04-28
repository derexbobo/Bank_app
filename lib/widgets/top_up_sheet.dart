import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TopUpBottomSheet extends StatefulWidget {
  final String selectedProvider;
  final String account;
  final String image;
  final String userId; // <-- ADD THIS

  const TopUpBottomSheet({
    super.key,
    required this.selectedProvider,
    required this.account,
    required this.image,
    required this.userId, // <-- ADD THIS
  });

  @override
  State<TopUpBottomSheet> createState() => _TopUpBottomSheetState();
}

class _TopUpBottomSheetState extends State<TopUpBottomSheet> {
  double amount = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(widget.image),
              backgroundColor: Colors.white,
            ),
            title: Text(widget.selectedProvider),
            subtitle: Text(widget.account),
            trailing: const Icon(
              Icons.keyboard_arrow_down,
              size: 25,
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black12),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Amount",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (amount > 5) amount -= 5;
                  });
                },
                icon: const Icon(Icons.remove),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Text(
                "\$ ${amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    amount += 5;
                  });
                },
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Slider(
            value: amount,
            min: 5,
            max: 500,
            activeColor: const Color.fromARGB(255, 16, 80, 98),
            onChanged: (value) {
              setState(() {
                amount = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [5, 10, 15, 20, 50, 100, 200, 500].map((value) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      amount = value.toDouble();
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: amount == value
                          ? const Color.fromARGB(255, 16, 80, 98)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\$$value',
                      style: TextStyle(
                        color: amount == value ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: () async {
              print('User ID: ${widget.userId}');

              String? accountId = await fetchAccountId(widget.userId);

              if (accountId != null) {
                print('Fetched Account ID: $accountId');

                // Now create the transaction
                await createTransaction(accountId: accountId, amount: amount);

                // Optional: Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Top Up successful!')),
                );

                // Optional: Close the bottom sheet
                Navigator.of(context).pop();
              } else {
                print('Failed to fetch account ID.');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Failed to fetch account. Please try again.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              fixedSize: const Size(double.maxFinite, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Top Up",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> fetchAccountId(String userId) async {
  const String baseUrl = 'http://10.237.198.176:3000'; // <-- change this

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/accounts/user/$userId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('accounts') && data['accounts'].isNotEmpty) {
        // Get the first account's account_id
        String accountId = data['accounts'][0]['account_id'];
        print('Fetched Account ID: $accountId');
        return accountId;
      } else {
        print('No accounts found for this user.');
        return null;
      }
    } else {
      print('Failed to fetch account. Status Code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching account: $e');
    return null;
  }
}

Future<void> createTransaction({
  required String accountId,
  required double amount,
}) async {
  const String baseUrl = 'http://10.237.198.176:3000'; // <-- same as before

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/transactions/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'account_id': accountId,
        'transaction_type': 'Withdrawal', // or 'TopUp' if you want
        'amount': amount.toInt(), // convert double to int if needed
      }),
    );

    if (response.statusCode == 201) {
      print('Transaction successful!');
    } else {
      print(
          'Failed to create transaction. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    print('Error creating transaction: $e');
  }
}
