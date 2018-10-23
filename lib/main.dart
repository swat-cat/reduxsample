import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:reduxsample/redux/app/app_state.dart';
import 'package:reduxsample/redux/auth/keys.dart';
import 'package:reduxsample/ui/auth/login/sign_in.dart';
import 'utils/colors.dart';
import 'ui/auth/signup/sign_up.dart';
import 'package:reduxsample/redux/store.dart';
import 'package:flutter/services.dart';

void main() async{
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  var store = await createStore();
  runApp(new SlayWokeApp(store));
}

class SlayWokeApp extends StatefulWidget {
  final Store<AppState> store;

  SlayWokeApp(this.store);

  @override
  _SlayWokeAppState createState() => _SlayWokeAppState();
}

class _SlayWokeAppState extends State<SlayWokeApp> {
  @override
  Widget build(BuildContext context) {
    return new  StoreProvider<AppState>(
      store: widget.store,
      child: new MaterialApp(
        theme: new ThemeData(
            brightness: Brightness.dark,
            // ignore: strong_mode_invalid_cast_new_expr
            primaryColor: const Color(0xFF000000),
            accentColor: const Color(primaryPink),
        ),
        home: SignIn(),
        navigatorKey: Keys.navKey,
        routes:  <String, WidgetBuilder>{
          "/signin": (BuildContext context) => new SignIn(),
          "/signup": (BuildContext context) => new SignUp(),
        }
      ),
    );
  }
}
