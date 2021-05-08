import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_login/bloc/auth_bloc.dart';
import 'package:test_login/pages/email_sign_in_page.dart';
import 'package:test_login/pages/welcome_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    User _user = context.read<AuthBloc>().currentUser;

    return BlocListener<AuthBloc, LoginState>(
      listener: (context, state) {
        setState(() {});
      },
      child: _user == null
          ? EmailSignInPage()
          : WelcomePage(
              regOrSign: false,
              onSignOut: () {
                context.read<AuthBloc>().add(LogOut());
                setState(() {});
              },
            ),
    );
  }
}
