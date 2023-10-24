import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => Modular.to.navigate('/auth/login'),
                child: const Text('Login')),
            ElevatedButton(
              onPressed: () => Modular.to.navigate('/auth/register'),
              child: const Text('register'),
            )
          ],
        ),
      ),
    );
  }
}
