import 'package:flutter/material.dart';
import 'register.dart';

void main() {
  runApp(const MaterialApp(
    home: LandingPage(),
  ));
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mosaik'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Route route =
                MaterialPageRoute(builder: (context) => const RegisterPage());
            Navigator.push(context, route);
          },
          child: const Text('Register'),
        ),
      ),
    );
  }
}
