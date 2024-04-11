// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewPasswordPage extends StatefulWidget {
  final String? e;

  const NewPasswordPage({Key? key, required this.e}) : super(key: key);

  @override
  NewPasswordPageState createState() => NewPasswordPageState();
}

class NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _error;
  Color msgColor = Colors.red;
  bool _hasError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;
  String? usernameErrorMessage = '';
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String confirmPasswordErrorMessage = '';
  RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  RegExp emailRegex = RegExp(r'\S+@\S+.(com|net|org)$');

Future<void> _updatePass() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty) {
      setState(() {
        _hasError = true;
        _passwordError = true;
        passwordErrorMessage = 'This field is required.';
      });
    } else if (password.length < 8) {
      setState(() {
        _hasError = true;
        _passwordError = true;
        passwordErrorMessage = 'Password must be at least 8 characters long.';
      });
    } else {
      // Handle case of password being less than 8 characters long and then not meeting requirements
      passwordErrorMessage = '';
      confirmPasswordErrorMessage = '';
      if (!RegExp(r'(?=.\d)').hasMatch(password)) {
        setState(() {
          _hasError = true;
          _passwordError = true;
          passwordErrorMessage +=
              'Password must contain at least one number.\n';
        });
      }

      if (!RegExp(r'[a-z]').hasMatch(password)) {
        setState(() {
          _hasError = true;
          _passwordError = true;
          passwordErrorMessage +=
              'Password must contain at least one lowercase letter.\n';
        });
      }

      if (!RegExp(r'[A-Z]').hasMatch(password)) {
        setState(() {
          _hasError = true;
          _passwordError = true;
          passwordErrorMessage +=
              'Password must contain at least one uppercase letter.\n';
        });
      }

      if (!RegExp(r'(?=.[!@#$%^&*()])').hasMatch(password)) {
        setState(() {
          _hasError = true;
          _passwordError = true;
          passwordErrorMessage +=
              'Password must contain at least one special character.\n';
        });
      }

      setState(() {
        passwordErrorMessage = passwordErrorMessage.trimRight();
      }); // trims a new line from the error message
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        _hasError = true;
        _confirmPasswordError = true;
        confirmPasswordErrorMessage = "This field is required.";
      });
    }

    if (password != confirmPassword) {
      setState(() {
        _error = 'Passwords do not match.';
        _hasError = true;
        _passwordError = true;
        _confirmPasswordError = true;
      });
    }

    if (_hasError) return;

    final url =
        Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/updatepassword');
    final response = await http.post(
      url,
      body: jsonEncode({
        'email': widget.e,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final error = data['error'];

      if (error.isEmpty) {
        print("PASSWORD UPDATED");
        setState(() {
        _error = 'Password Reset!';
        msgColor = Colors.green;
        _hasError = true;
        _passwordError = true;
        _confirmPasswordError = true;
      });
        await Future.delayed(const Duration(seconds: 1));
        _navigateToLogin();
      } else {
        setState(() {
          _error = error;
          _hasError = true;
        });
      }
    } else {
      setState(() {
        _error = 'An error occurred. Please try again later.';
        _hasError = true;
      });
    }
  }


  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: const Color.fromARGB(255, 87, 179, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 40.0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.asset('images/BlueLogoTransparent.png'),
                  ),
                ),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: msgColor),
                ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (_) {
                  setState(() {
                    _passwordError = false;
                    _hasError = false;
                  });
                  passwordErrorMessage = '';
                  confirmPasswordErrorMessage = '';

                  if (_passwordController.text.length < 8) {
                    setState(() {
                      _hasError = true;
                      _passwordError = true;
                      passwordErrorMessage =
                          'Password must be at least 8 characters long.\n';
                    });
                  }

                  if (!RegExp(r'(?=.\d)').hasMatch(_passwordController.text)) {
                    setState(() {
                      _hasError = true;
                      _passwordError = true;
                      passwordErrorMessage +=
                          'Password must contain at least one number.\n';
                    });
                  }

                  if (!RegExp(r'[a-z]').hasMatch(_passwordController.text)) {
                    setState(() {
                      _hasError = true;
                      _passwordError = true;
                      passwordErrorMessage +=
                          'Password must contain at least one lowercase letter.\n';
                    });
                  }

                  if (!RegExp(r'[A-Z]').hasMatch(_passwordController.text)) {
                    setState(() {
                      _hasError = true;
                      _passwordError = true;
                      passwordErrorMessage +=
                          'Password must contain at least one uppercase letter.\n';
                    });
                  }

                  if (!RegExp(r'[!@#$%^&*()]')
                      .hasMatch(_passwordController.text)) {
                    setState(() {
                      _hasError = true;
                      _passwordError = true;
                      passwordErrorMessage +=
                          'Password must contain at least one special character.\n';
                    });
                  }
                  setState(() {
                    passwordErrorMessage = passwordErrorMessage.trimRight();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _passwordError ? Colors.red : Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _passwordError ? Colors.red : Colors.black,
                    ),
                  ),
                  errorText: _passwordError
                      ? (passwordErrorMessage.isNotEmpty
                          ? passwordErrorMessage
                          : null)
                      : null,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _confirmPasswordController,
                onChanged: (_) {
                  setState(() {
                    _confirmPasswordError = false;
                    _hasError = false;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _confirmPasswordError ? Colors.red : Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _confirmPasswordError ? Colors.red : Colors.black,
                    ),
                  ),
                  errorText: _confirmPasswordError
                      ? (confirmPasswordErrorMessage.isNotEmpty
                          ? confirmPasswordErrorMessage
                          : null)
                      : null,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updatePass,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 25),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: const Text('Update'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
