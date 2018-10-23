import 'dart:async';
import 'package:redux/redux.dart';
import 'package:reduxsample/models/auth_request.dart';
import 'package:reduxsample/models/loading_status.dart';
import 'package:reduxsample/redux/app/app_state.dart';
import 'package:reduxsample/redux/auth/auth_actions.dart';
import 'package:reduxsample/redux/auth/screen.dart';
import 'package:reduxsample/utils/strings.dart';

class ValidationMiddleware extends MiddlewareClass<AppState>{

  final String emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
      if(action is ValidateEmailAction){
        validateEmail(action.screen,action.email, next);
      }

      if(action is ValidatePasswordAction){
        validatePassword(action.screen,action.password, next);
      }

      if(action is ValidatePasswordMatchAction){
        validatePassMatch(action.screen,action.password, action.confirmPassword, next);
      }

      if(action is ValidateCodeAction){
        if(isNumeric(action.code) && action.code.length>=6){
          next(new CodeErrorAction(""));
        }else{
          next(CodeErrorAction(code_error));
        }
      }

      if(action is ValidateLoginFields){
        validateEmail(Screen.SIGNIN,action.email, next);
        validatePassword(Screen.SIGNIN,action.password, next);
        RegExp exp = new RegExp(emailPattern);
        if(!exp.hasMatch(action.email) || action.password.length<6){
          next(ChangeLoadingStatusAction(LoadingStatus.error));
        }else{
          next(new SignInAction(new AuthRequest(action.email,action.password)));
        }
      }
      if(action is ValidateSignUpFieldsAction){
        validateEmail(Screen.SIGNUP,action.request.email, next);
        validatePassword(Screen.SIGNUP,action.request.password, next);
        validatePassMatch(Screen.SIGNUP,action.request.password, action.request.retypePassword, next);
        RegExp exp = new RegExp(emailPattern);
        if(!exp.hasMatch(action.request.email) || action.request.password.length<6 || action.request.password != action.request.retypePassword){
          next(ChangeLoadingStatusAction(LoadingStatus.error));
        }else{
          next(new SignUpAction(action.request));
        }
      }
      next(action);
  }

  void validatePassMatch(Screen screen, String password, String confirmPassword, NextDispatcher next) {
    if(password != confirmPassword){
      next(new RetypePasswordErrorAction(password_match_error,screen));
    }else{
      next(new RetypePasswordErrorAction("",screen));
    }
  }

  void validatePassword(Screen screen, String password, NextDispatcher next) {
    if(password.length<6){
      next(new PasswordErrorAction(password_error,screen));
    }else{
      next(new PasswordErrorAction("",screen));
    }
  }

  void validateEmail(Screen screen, String email, NextDispatcher next) {
    RegExp exp = new RegExp(emailPattern);
    if(!exp.hasMatch(email)){
      next(new EmailErrorAction(email_error,screen));
    }else{
      next(new EmailErrorAction("",screen));
    }
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}