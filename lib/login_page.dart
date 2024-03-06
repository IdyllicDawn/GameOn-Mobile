import 'package:flutter/material.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      child: Image.asset('images/TestLogo.png')),
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        String username = _usernameController.text;
                        String password = _passwordController.text;
                        // TODO: Login Authentication
                        print('Username: $username, Password: $password');

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 25),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5.0),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text('New User? Create Account')
            ],
          ),
        ),
      ),
    );
  }
}
