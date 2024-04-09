import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String? _error;
  bool _hasError = false;
  Color _errorColor = Colors.red;
 TextEditingController controlField = TextEditingController();

  Future<void> _checkEmailValidity(String email) async {
    final url = Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/email');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final emailExists = data['error'];

      if (emailExists == "") {
        // send the password reset email
        sendEmail(email);
        setState(() {
          _error = 'Email Sent!';
          _hasError = true;
          _errorColor = Colors.green;
          
        });
        Timer(Duration(seconds: 3), () {
        setState(() {
          _error = '';
        });
        });
      } else {
        // email does not exist in the database
        setState(() {
          _error = 'Email does not exist in the database.';
          _hasError = true;
          _errorColor = Colors.red;
        });
      }
    } else {
      // error response from the API
      setState(() {
        _error = 'Error checking email validity. Please try again.';
        _hasError = true;
        _errorColor = Colors.red;
      });
    }
  }

  void sendEmail(emailR) async {
  const message = '\nPlease click the link below to reset your password:\n';
  const serviceId = 'service_lp2038n';
  const templateId = 'template_sxd4kie';
  const publicKey = 'eUOYcmbkqPktXlIjF';
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  final response = await http.post(url,
  headers: {
    'origin' : 'http://localhost',
    'Content-Type' : 'application/json',
    'Authorization' : 'Bearer $publicKey'
  },
  body: json.encode({
    'service_id' : serviceId,
    'template_id' : templateId,
    'user_id' : publicKey,
    'template_params' : {
      'user_subject' : 'GameOn Password Reset',
      'user_email' : emailR,
      'message' : message
    }
  })
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your email address to reset your password.',
              textAlign: TextAlign.center,
            ),
            if (_error != null && _hasError) 
            SizedBox(
              height: 20, 
              child: Text(
                _error!,
                style: TextStyle(color: _errorColor),
              ),
            ),
            
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controlField,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _checkEmailValidity(controlField.text);
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
