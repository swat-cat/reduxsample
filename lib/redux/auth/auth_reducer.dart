import 'package:redux/redux.dart';
import 'package:reduxsample/models/loading_status.dart';
import 'package:reduxsample/redux/auth/auth_state.dart';
import 'auth_actions.dart';
import 'screen_state.dart';
import 'screen.dart';

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState,ValidateEmailAction>(_validateEmail),
  TypedReducer<AuthState,ValidatePasswordAction>(_validatePassword),
  TypedReducer<AuthState,ValidateLoginFields>(_validateLoginFieldsAction),
  TypedReducer<AuthState,ValidatePasswordMatchAction>(_validatePasswordMatch),
  TypedReducer<AuthState,ValidateCodeAction>(_validateCodeAction),
  TypedReducer<AuthState,ChangeLoadingStatusAction>(_changeLoadingStatusAction),
  TypedReducer<AuthState,EmailErrorAction>(_emailErrorAction),
  TypedReducer<AuthState,PasswordErrorAction>(_passwordErrorAction),
  TypedReducer<AuthState,RetypePasswordErrorAction>(_retypePasswordErrorAction),
  TypedReducer<AuthState,CodeErrorAction>(_codeErrorAction),
  TypedReducer<AuthState,ChangeGenderAction>(_changeGenderAction),
  TypedReducer<AuthState,SignInAction>(_signInAction),
  TypedReducer<AuthState,SignUpAction>(_signUpAction),
  TypedReducer<AuthState,SaveTokenAction>(_saveToken),
  TypedReducer<AuthState,RequestCodeAction>(_requestCodeAction),
  TypedReducer<AuthState,ConfirmForgotPasswordAction>(_confirmCodeAction),
  TypedReducer<AuthState,NavigateToRegistrationAction>(_navigateToRegistrationAction),
  TypedReducer<AuthState,CheckTokenAction>(_checkTokenAction),
  TypedReducer<AuthState,ClearErrorsAction>(_clearErrorsAction)
]);

AuthState _validateEmail(AuthState state, ValidateEmailAction action){
  return state.copyWith(email: action.email);
}

AuthState _validatePassword(AuthState state, ValidatePasswordAction action) =>
    state.copyWith(password: action.password);

AuthState _validateLoginFieldsAction(AuthState state, ValidateLoginFields action) => state;

AuthState _validatePasswordMatch(AuthState state, ValidatePasswordMatchAction action) =>
    state.copyWith(password: action.password,retypePassword: action.confirmPassword);

AuthState _validateCodeAction(AuthState state, ValidateCodeAction action) =>
    state.copyWith(code: action.code);

AuthState _changeLoadingStatusAction(AuthState state, ChangeLoadingStatusAction action) =>
    state.copyWith(loadingStatus: action.status);

AuthState _emailErrorAction(AuthState state, EmailErrorAction action){
  if(action.screen == Screen.SIGNUP){
    return state.copyWith(emailError: action.message);
  }else return state;
}

AuthState _passwordErrorAction(AuthState state, PasswordErrorAction action){
    if (action.screen == Screen.SIGNUP) {
      return state.copyWith(passwordError: action.message);
    }else return state;
}

AuthState _retypePasswordErrorAction(AuthState state, RetypePasswordErrorAction action) {
      if (action.screen == Screen.SIGNUP) {
        return state.copyWith(retypePasswordError: action.message);
      }else return state;
}

AuthState _codeErrorAction(AuthState state, CodeErrorAction action) =>
  state.copyWith(codeError: action.message);

AuthState _changeGenderAction(AuthState state, ChangeGenderAction action) =>
    state.copyWith(gender: action.gender);

AuthState _signInAction(AuthState state, SignInAction action) => state;

AuthState _signUpAction(AuthState state, SignUpAction action) => state;

AuthState _saveToken(AuthState state, SaveTokenAction action) =>
    state.copyWith(token: action.token);

AuthState _requestCodeAction(AuthState state, RequestCodeAction action) => state;

AuthState _confirmCodeAction(AuthState state, ConfirmForgotPasswordAction action) => state;

AuthState _navigateToRegistrationAction(AuthState state,NavigateToRegistrationAction action) => state;

AuthState _checkTokenAction(AuthState state, CheckTokenAction action) => state;

AuthState _clearErrorsAction(AuthState state, ClearErrorsAction action) =>
    state.copyWith(loadingStatus: LoadingStatus.success, emailError: "", passwordError: "", retypePasswordError: "");