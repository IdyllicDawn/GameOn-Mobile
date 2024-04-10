// ignore_for_file: use_build_context_synchronously, avoid_print
// Above statement is IDE yelling at me for using context in async function eg showDialog(context: context,

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'package:GameOn/verificationcode_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _error;
  bool _hasError = false;
  bool _usernameError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;
  String? usernameErrorMessage = '';
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String confirmPasswordErrorMessage = '';
  RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  RegExp emailRegex = RegExp(r'\S+@\S+.(com|net|org)$');

  Future<void> _signup() async {
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty) {
      setState(() {
        _hasError = true;
        _usernameError = true;
        usernameErrorMessage = 'This field is required.';
      });
    } else if (username.length < 4) {
      setState(() {
        _hasError = true;
        _usernameError = true;
        usernameErrorMessage = 'Username must be at least 4 characters long.';
      });
    } else if (!usernameRegex.hasMatch(username)) {
      setState(() {
        _hasError = true;
        _usernameError = true;
        usernameErrorMessage =
            'Username may only contain letters, numbers, or underscores.';
      });
    }

    if (email.isEmpty) {
      setState(() {
        _hasError = true;
        _emailError = true;
        emailErrorMessage = 'This field is required.';
      });
    } else if (!emailRegex.hasMatch(email)) {
      setState(() {
        _hasError = true;
        _emailError = true;
        emailErrorMessage = 'Invalid email address.';
      });
    }

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
        Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/signup');
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final error = data['error'];

      if (error.isEmpty) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => HomePage(loggedInUsername: username)),
        // );
        sendEmail(_usernameController.text);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerificationCodePage(loggedInEmail: email),
        ));
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

  Future<String> getEmail(String username) async {
  final url = Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/userCheck'); 
  final response = await http.post(
    url,
    body: jsonEncode({'username': username}),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['result'];

    // Check if results array is not empty
    if (results.isNotEmpty) {
      String email = results[0]["Email"];
      return email;
    } else {
      throw Exception('User not found');
    }
  } else {
    throw Exception('Failed to load user data');
  }
}

  void sendEmail(String username) async {
  String em = "";
    try {
    em = await getEmail(username);
  } catch (e) {
    print('An error occurred: $e');
  }

  final url = Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/send-email');
  final response = await http.post(
    url,
    body: jsonEncode({
      'emailR': em,
      'username': username,
    }),
    headers: {'Content-Type': 'application/json'} 
  );

  if (response.statusCode == 200) {
    print('Email sent successfully');
  } else {
    print('Error sending email: ${response.body}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
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
                    child: Image.asset('images/BlackLogo.png'),
                  ),
                ),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _usernameController,
                onChanged: (_) {
                  setState(() {
                    _usernameError = false;
                    _hasError = false;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _usernameError ? Colors.red : Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _usernameError ? Colors.red : Colors.black,
                    ),
                  ),
                  errorText: _usernameError ? usernameErrorMessage : null,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                onChanged: (_) {
                  setState(() {
                    _emailError = false;
                    _hasError = false;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _emailError ? Colors.red : Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _emailError ? Colors.red : Colors.black,
                    ),
                  ),
                  errorText: _emailError ? emailErrorMessage : null,
                ),
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
                  labelText: 'Password',
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
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 25),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: const Text('Signup'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
