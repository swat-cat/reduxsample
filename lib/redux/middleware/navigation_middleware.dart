

import 'package:redux/redux.dart';
import 'package:reduxsample/redux/app/app_state.dart';
import 'package:reduxsample/redux/auth/auth_actions.dart';
import 'package:reduxsample/redux/auth/keys.dart';

class NavigationMiddleware extends MiddlewareClass<AppState>{
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if(action is NavigateToRegistrationAction){
      Keys.navKey.currentState.pushNamed("/signup");
    }
    next(action);
  }
}