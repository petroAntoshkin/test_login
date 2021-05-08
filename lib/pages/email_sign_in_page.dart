import 'package:flutter/material.dart';
import 'package:test_login/elements/email_sign_in_form_with_bloc.dart';

class EmailSignInPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => EmailSignInPage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign in')),
        elevation: 4.0,
        automaticallyImplyLeading: false,
      ),
      body: Card(
        // child: BlocProvider(
        //   create: (context){
        //     return AuthBloc(const LoginState());
        //   },
          child: EmailSignInFormWithBloc(),
        // ),
        // child: EmailSignInFormWithBloc(),
      ),
      backgroundColor: Colors.grey[300],
    );
  }
}
