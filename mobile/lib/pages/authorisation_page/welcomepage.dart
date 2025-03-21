import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final String username;

  const WelcomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Привет, $username!')),
      body: Center(
        child: Text(
          'Добро пожаловать, $username!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
