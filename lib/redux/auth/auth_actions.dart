import 'dart:ui';

import 'package:reduxsample/models/auth_request.dart';
import 'package:reduxsample/models/gender.dart';
import 'package:reduxsample/models/loading_status.dart';
import 'package:reduxsample/models/signup_request.dart';

import 'screen_state.dart';
import 'screen.dart';

class ValidateEmailAction{
  final String email;
  final Screen screen;
  ValidateEmailAction(this.email, this.screen);
}

class ValidatePasswordAction{
  final String password;
  final Screen screen;
  ValidatePasswordAction(this.password, this.screen);
}

class ValidateLoginFields{
  final String email;
  final String password;

  ValidateLoginFields(this.email, this.password);
}

class ValidatePasswordMatchAction{
  final String password;
  final String confirmPassword;
  final Screen screen;
  ValidatePasswordMatchAction(this.password, this.confirmPassword, this.screen);
}

class ValidateSignUpFieldsAction{
  final SignUpRequest request;
  ValidateSignUpFieldsAction(this.request);
}

class ValidateCodeAction{
  final String code;
  ValidateCodeAction(this.code);
}

class ChangeGenderAction{
  final Gender gender;
  ChangeGenderAction(this.gender);
}

class ChangeScreenStateAction{
  final ScreenState type;
  ChangeScreenStateAction(this.type);
}

class ChangeLoadingStatusAction{
  final LoadingStatus status;
  ChangeLoadingStatusAction(this.status);
}

class EmailErrorAction{
  final String message;
  final Screen screen;
  EmailErrorAction(this.message, this.screen);
}

class PasswordErrorAction{
  final String message;
  final Screen screen;
  PasswordErrorAction(this.message, this.screen);
}

class RetypePasswordErrorAction{
  final String message;
  final Screen screen;
  RetypePasswordErrorAction(this.message, this.screen);
}

class CodeErrorAction{
  final String message;
  CodeErrorAction(this.message);
}

class SignInAction{
  final AuthRequest request;
  SignInAction(this.request);
}

class SignUpAction{
  final SignUpRequest request;
  SignUpAction(this.request);
}

class SaveTokenAction{
  final String token;
  SaveTokenAction(this.token);
}

class RequestCodeAction{
  final String email;
  RequestCodeAction(this.email);
}

class ConfirmForgotPasswordAction{
  final String code;
  final String password;
  ConfirmForgotPasswordAction(this.code, this.password);
}

class CheckTokenAction{
  final VoidCallback hasTokenCallback;
  final VoidCallback noTokenCallback;

  CheckTokenAction({this.hasTokenCallback, this.noTokenCallback});

}

class ClearErrorsAction{}

class NavigateToRegistrationAction{}
