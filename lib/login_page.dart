import 'dart:convert';
import 'package:GameOn/resetpass_page.dart';
import 'package:GameOn/verificationcode_page.dart';
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
  String _verifyText = "";
  bool _hasError = false;
  bool isButtonEnabled = false;
  String? globalEmail;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    globalEmail = await getEmail(username);
    final url =
        Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/users');
    final response = await http.post(
      url,
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    
    FocusScope.of(context).unfocus();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final v = data['error'];
      bool cred = false;
      bool valid = false;
      if(v == "")
      {
        cred = true;
      }
      final u =
        Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/userCheck');

      final res = await http.post(u,
      body: jsonEncode({'username': username}),
      headers: {'Content-Type': 'application/json'},);

     final d = jsonDecode(res.body);
     final resul = d["result"];
     if(resul.isNotEmpty)
     {
      valid = resul[0]['Validate'];
     }

      if (cred && valid){
        print("VALID");
        isButtonEnabled = false;
        _verifyText = "";
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(loggedInUsername: username)),
        );  
      }
      else if (cred && !valid)
      {
        setState(() {
          isButtonEnabled = true;
        _verifyText = "Send Verification Link";
        _error = "Account Not Verified";
        _hasError = true;
        });
        print("not valid");
      }
      else
      {
        print("NOT VALID and null");
        setState(() {
          print("Invalid username or password");
          _error = 'Invalid username/password combination.';
          _hasError = true;
        });
        return;
      }
    }
    else
    {
        setState(() {
        print("error logging in");
        _error = 'There was an error logging in. Please try again.';
        _hasError = true;
      });
    }
  }

  void _guestLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage(loggedInUsername: null)),
    );
  }

  Future<String> getEmail(String username) async {
    print("Username is of type: ");
    print(username.runtimeType);
  final url = Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/userCheck'); // Replace with your API endpoint
  final response = await http.post(
    url,
    body: jsonEncode({'username': username}),
    headers: {'Content-Type': 'application/json'},
  );
  print("USER: $username");
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
  final em = await getEmail(username);
  final url = Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/send-email');
  final response = await http.post(
    url,
    body: jsonEncode({
      'emailR': em,
      'username': username,
    }),
    headers: {'Content-Type': 'application/json'} 
  );
  print(response);

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
                    child: Image.asset('images/GameOnLogo.png'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordPage()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()),
                      );
                    },
                    child: const Text(
                      "Create Account.",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guestLogin,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 25),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const Text('Continue as a guest'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: isButtonEnabled ? () {
                        sendEmail(_usernameController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationCodePage(loggedInEmail: globalEmail),
                      ));
                      } : null,
                      child: Text(
                      _verifyText,
                      style: const TextStyle(color: Colors.blue),
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
