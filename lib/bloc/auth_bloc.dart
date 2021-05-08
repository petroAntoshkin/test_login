import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:test_login/bloc/password.dart';
import 'package:test_login/bloc/email.dart';

part 'login_event.dart';

part 'login_state.dart';

class AuthBloc extends Bloc<LoginEvent, LoginState> {
  User get currentUser => _firebaseAuth.currentUser;

  final _firebaseAuth = FirebaseAuth.instance;

  bool _isLoading = false;

  AuthBloc(initialState) : super(initialState);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    } else if (event is LoginRegister) {
      yield* _mapRegisterToState(event, state);
    } else if (event is LogOut) {
      yield* _logOut(event);
    }
  }

  LoginState _mapEmailChangedToState(
    LoginEmailChanged event,
    LoginState state,
  ) {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.password, email]),
    );
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.email]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    if (state.status.isValidated && !_isLoading) {
      _isLoading = true;
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        _signInWithEmail(
          email: state.email.value,
          password: state.password.value,
        );
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      } finally {
        _isLoading = false;
      }
    }
  }

  Stream<LoginState> _mapRegisterToState(
    LoginRegister event,
    LoginState state,
  ) async* {
    if (state.status.isValidated && !_isLoading) {
      _isLoading = true;
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        _registerWithEmail(
          email: state.email.value,
          password: state.password.value,
        );
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      } finally {
        _isLoading = false;
      }
    }
  }

  Future<void> _signInWithEmail({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _registerWithEmail({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
    }
  }

  Stream<LoginState> _logOut(
    LogOut event,
  ) async* {
    await _firebaseAuth.signOut();
    yield state;
  }
}
