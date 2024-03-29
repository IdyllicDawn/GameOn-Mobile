import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;
  bool _hasError = false;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    
    final url =
        Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/users');
    final response = await http.post(
      url,
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    FocusScope.of(context).unfocus();

    print("hello");
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final id = data['id'];
      // final firstName = data['firstName']; data not used yet
      // final lastName = data['lastName']; data not used yet
      print(id);

      if (id != -1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        setState(() {
          _error = 'Invalid username/password combination.';
          _hasError = true;
        });
      }
    } else {
      setState(() {
        _error = 'There was an error logging in. Please try again.';
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameOn!'),
        backgroundColor: const Color.fromARGB(255, 87, 179, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.asset('images/TestLogo.png'),
                  ),
                ),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasError ? Colors.red : Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasError ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasError ? Colors.red : Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasError ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 25),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupPage()),
                      );
                    },
                    child: const Text(
                      "Create Account.",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
