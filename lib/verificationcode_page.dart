// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:GameOn/login_page.dart';

class VerificationCodePage extends StatefulWidget {
  final String? loggedInEmail;

  const VerificationCodePage({super.key, required this.loggedInEmail});

  @override
  // ignore: library_private_types_in_public_api
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final TextEditingController _verificationCodeController = TextEditingController();
  late final String? email;
  String _err = "";
  Color msgColor = Colors.red;

  @override
  void initState() {
    super.initState();
    email = widget.loggedInEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerificationCodePage(loggedInEmail: email,),
                      ),
                    );
                  },
                  child: const Text(
                    "Please enter the 6 digit verification code sent to your email.",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            Center(
            child: SizedBox(
              height: 20,
              child: Text(
                _err,
                style: TextStyle(color: msgColor),
              ),
            ),
          ),

            SizedBox (
              width: 100,
              child: TextField(
                controller: _verificationCodeController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Enter Verification Code',
                ),
              ),
            ),
            const SizedBox(height: 16.0, width: 200,),
            ElevatedButton(
              onPressed: () async {
                // Handle verification code submission
                String verificationCode = _verificationCodeController.text;
                if (verificationCode.isNotEmpty) {
                  // Process the verification code
                  int code = int.parse(verificationCode);
                  final url = Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/verify');
                  final response = await http.post(
                    url,
                    body: jsonEncode({
                      'email': email,
                      'code': code,
                    }),
                    headers: {'Content-Type': 'application/json'} 
                  );
                  final data = jsonDecode(response.body);
                  final results = data['error'];
                  if (results == "")
                  {
                    print("ACCOUNT VERIFIED!");
                    setState(() {
                      _err = "Account Verified!";
                      msgColor = Colors.green;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
                  else
                  {
                    setState(() {
                      _err = "Incorrect Code";
                      msgColor = Colors.red;
                    });
                  }
                } else {
                  // Show error message if verification code is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a verification code')),
                  );
                }
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
