import 'package:meta/meta.dart';
import 'package:reduxsample/redux/auth/auth_state.dart';
import 'package:reduxsample/redux/auth/signin/singin_state.dart';

@immutable
class AppState{

  final AuthState authState;
  final SignInState signInState;

  AppState({
    @required this.authState,
    @required this.signInState
  });

  factory AppState.initial(){
    return AppState(
      authState: AuthState.initial(),
      signInState: SignInState.initial()
    );
  }

  AppState copyWith({
    AuthState authState,
    SignInState signInState,
  }){
    return AppState(
      authState: authState ?? this.authState,
      signInState: signInState ?? this.signInState
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              authState == other.authState &&
              signInState == other.signInState;

  @override
  int get hashCode =>
      authState.hashCode ^
      signInState.hashCode;




}