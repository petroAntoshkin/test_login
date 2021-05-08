import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_login/bloc/auth_bloc.dart';
import 'package:test_login/models/email_form_type.dart';
import 'package:formz/formz.dart';

class EmailSignInFormWithBloc extends StatefulWidget {
  @override
  _EmailSignInFormWithBlocState createState() =>
      _EmailSignInFormWithBlocState();
}

class _EmailSignInFormWithBlocState extends State<EmailSignInFormWithBloc> {
  EmailFormType _formType = EmailFormType.login;

  void _toggleForm() {
    setState(() {
      _formType = _formType == EmailFormType.login
          ? EmailFormType.register
          : EmailFormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _elemSpace = 10.0;
    return BlocListener<AuthBloc, LoginState>(
      listener: (context, state) {
        // print('--------------- listen in sign in form ----------------');
        // if (state.status.isSubmissionFailure) {
        //   ScaffoldMessenger.of(context)
        //     ..hideCurrentSnackBar()
        //     ..showSnackBar(
        //       const SnackBar(content: Text('Authentication Failure')),
        //     );
        // }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Email(),
            SizedBox(height: _elemSpace),
            _Password(),
            SizedBox(height: _elemSpace),
            _SignInButton(isRegistered: _formType == EmailFormType.login),
            SizedBox(height: _elemSpace),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: _toggleForm,
              child: Text(
                _formType == EmailFormType.login
                    ? 'Don\'t have an account? Register'
                    : 'Have an account? Sign in',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Email extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_emailInput_textField'),
          onChanged: (email) => context
              .read<AuthBloc>()
              .add(LoginEmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'email',
            hintText: 'example@example.com',
          ),
        );
      },
    );
  }
}

class _Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_passwordInput_textField'),
          onChanged: (pass) => context
              .read<AuthBloc>()
              .add(LoginPasswordChanged(pass)),
          decoration: InputDecoration(
            labelText: 'password',
          ),
          obscureText: true,
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  _SignInButton({@required this.isRegistered});

  final bool isRegistered;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                // key: const Key('loginForm_continue_raisedButton'),
                child: Text(isRegistered ? 'Sign in' : 'Create an account'),
                onPressed: state.status.isValidated
                    ? () {
                        isRegistered
                            ? context.read<AuthBloc>().add(LoginSubmitted())
                            : context.read<AuthBloc>().add(LoginRegister());
                      }
                    : null,
              );
      },
    );
  }
}
