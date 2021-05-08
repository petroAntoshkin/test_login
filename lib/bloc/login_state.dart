part of 'auth_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.user,
  });

  final FormzStatus status;
  final Email email;
  final Password password;
  final User user;

  LoginState copyWith({
    FormzStatus status,
    Email email,
    Password password,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, email, password];
}