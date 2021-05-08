import 'package:formz/formz.dart';

enum EmailValidationError { empty }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError validator(String value) {
    RegExp _emailReg = RegExp(r'\b[\w.-]+?@\w+?\.\w+?\b');
    return _emailReg.allMatches(value).length == 1 ? null : EmailValidationError.empty;
  }
}
