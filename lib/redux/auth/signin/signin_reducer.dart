import 'package:redux/redux.dart';
import 'package:reduxsample/models/loading_status.dart';
import 'package:reduxsample/redux/auth/auth_actions.dart';
import 'package:reduxsample/redux/auth/screen.dart';
import 'package:reduxsample/redux/auth/signin/singin_state.dart';

final signinReducer = combineReducers<SignInState>([
  TypedReducer<SignInState,ValidateEmailAction>(_validateEmail),
  TypedReducer<SignInState,ValidatePasswordAction>(_validatePassword),
  TypedReducer<SignInState,ValidateLoginFields>(_validateLoginFieldsAction),
  TypedReducer<SignInState,ChangeLoadingStatusAction>(_changeLoadingStatusAction),
  TypedReducer<SignInState,EmailErrorAction>(_emailErrorAction),
  TypedReducer<SignInState,PasswordErrorAction>(_passwordErrorAction),
  TypedReducer<SignInState,SaveTokenAction>(_saveToken),
  TypedReducer<SignInState,ConfirmForgotPasswordAction>(_confirmCodeAction),
  TypedReducer<SignInState,CheckTokenAction>(_checkTokenAction),
  TypedReducer<SignInState,ClearErrorsAction>(_clearErrorsAction),
  TypedReducer<SignInState,ChangeScreenStateAction>(_changeScreenStateAction),
]);

SignInState _changeScreenStateAction(SignInState state, ChangeScreenStateAction action) =>
    state.copyWith(type: action.type);

SignInState _validateEmail(SignInState state, ValidateEmailAction action){
  return state.copyWith(email: action.email);
}

SignInState _validatePassword(SignInState state, ValidatePasswordAction action) =>
    state.copyWith(password: action.password);

SignInState _validateLoginFieldsAction(SignInState state, ValidateLoginFields action) => state;

SignInState _changeLoadingStatusAction(SignInState state, ChangeLoadingStatusAction action) =>
    state.copyWith(loadingStatus: action.status);

SignInState _emailErrorAction(SignInState state, EmailErrorAction action){
  if(action.screen == Screen.SIGNIN){
    return state.copyWith(emailError: action.message);
  }else return state;
}

SignInState _passwordErrorAction(SignInState state, PasswordErrorAction action){
  if (action.screen == Screen.SIGNIN) {
    return state.copyWith(passwordError: action.message);
  }else return state;
}


SignInState _signInAction(SignInState state, SignInAction action) => state;


SignInState _saveToken(SignInState state, SaveTokenAction action) =>
    state.copyWith(token: action.token);

SignInState _confirmCodeAction(SignInState state, ConfirmForgotPasswordAction action) => state;


SignInState _checkTokenAction(SignInState state, CheckTokenAction action) => state;

SignInState _clearErrorsAction(SignInState state, ClearErrorsAction action) =>
    state.copyWith(loadingStatus: LoadingStatus.success, emailError: "", passwordError: "", retypePasswordError: "");