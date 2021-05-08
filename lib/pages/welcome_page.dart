import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({this.regOrSign, @required this.onSignOut});

  final VoidCallback onSignOut;
  final bool regOrSign;

  @override
  Widget build(BuildContext context) {
    String _message = regOrSign == true
        ? 'Welcome!\nYour registration is successful'
        : 'Welcome!';
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Success')),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          _message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSignOut(),
        child: Text(
          'Log\nout',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
