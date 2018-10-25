
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:reduxsample/models/loading_status.dart';
import 'dart:async';

import 'package:reduxsample/redux/app/app_state.dart';
import 'package:reduxsample/redux/auth/auth_actions.dart';
import 'package:reduxsample/redux/auth/screen_state.dart';
import 'package:reduxsample/ui/auth/login/login_viewmodel.dart';
import 'package:reduxsample/utils/strings.dart';
import 'package:reduxsample/utils/colors.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin{

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  var _version = "";
  FocusNode _emailNode = new FocusNode();
  FocusNode _passNode = new FocusNode();

  AnimationController _controllerAnim;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controllerAnim = new AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = new Tween(begin: 200.0, end: 0.0).animate(
      new CurvedAnimation(
        parent: _controllerAnim,
        curve:Curves.ease,
      ),
    );
    _emailNode.addListener((){setState(() {});});
    _passNode.addListener((){setState(() {});});
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    body: LayoutBuilder(
      builder: (context, constraints)=>SafeArea(
        child: new Container(
          color: Colors.black,
          child: new StoreConnector<AppState,LoginViewModel>(
              onInit: (store){
                store.dispatch(new ClearErrorsAction());
                store.dispatch(new CheckTokenAction(
                    hasTokenCallback: (){

                    },
                    noTokenCallback: (){
                      _animation.addStatusListener((status){
                        if(status == AnimationStatus.dismissed || status == AnimationStatus.completed){
                          store.dispatch(new ChangeScreenStateAction(ScreenState.SINGIN));
                        }
                      });
                      _animation.addListener((){
                        setState((){});
                      });
                      _controllerAnim.forward();
                    }
                ));
              },
            
              converter: (store) => LoginViewModel.fromStore(store),
              builder: (_, viewModel) => content(viewModel,constraints),
          ),
        ),
      ),
    ),
  );


  Widget content(LoginViewModel viewModel, BoxConstraints constraints) =>
      (viewModel.status != LoadingStatus.loading || viewModel?.type == ScreenState.WELCOME)? new Container(
      child: new Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: <Widget>[
            new Align(
              alignment: Alignment.topCenter,
              child: new Transform(
                  transform: new Matrix4.translationValues(0.0, _animation.value, 0.0),
                  child: SingleChildScrollView(
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 65.0,right: 65.0,top: 16.0),
                          child: new Image(
                              image: AssetImage("assets/images/logo_group.png"),
                          ),
                        ),

                        viewModel.type == ScreenState.SINGIN?new Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            emailInput(viewModel),
                            (viewModel.status == LoadingStatus.error && viewModel.emailError.isNotEmpty)?emailError(viewModel):const SizedBox(),
                            passwordInput(viewModel),
                            (viewModel.status == LoadingStatus.error && viewModel.passwordError.isNotEmpty)?passwordError(viewModel):const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(left: 65.0,right: 65.0,top: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  signupBtn((){
                                    viewModel.clearError();
                                    viewModel.navigateToRegistration();
                                  }),

                                  loginBtn((){
                                    viewModel.login(viewModel.email,viewModel.password);
                                  })
                                ],
                              ),
                            ),
                            new Center(
                              child:  forgotPassword(),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 65.0,right: 65.0,top: 12.0),
                                child: new Text(terms_and_cond_label,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Color(botomAccentLightGray)
                                  ),
                                ),
                              ),
                            ),

                            termsAndConditions(),
                            new Padding(padding: const EdgeInsets.all(16.0))
                          ],
                        ):Container()
                      ],
                    ),
                  ),
              ),
            ),
          ],
      ),
  ):new Center(
    child: new CircularProgressIndicator(),
  );


  Widget emailInput(LoginViewModel viewModel) => Padding(
    padding: const EdgeInsets.only(left: 65.0,right: 65.0,top: 26.0),
    child: Container(
      alignment: new Alignment(0.5, 0.5),
      height: 56.0,
      decoration: BoxDecoration(
        color: Color(semiTransparentGray),
        border: Border(bottom: BorderSide(
            color: new Color(_getColor(viewModel.status, viewModel.emailError, _emailNode)),
            width:1.0
        )),
      ),
      child:  Padding(
        padding: const EdgeInsets.only(left: 16.0,bottom: 8.0),
        child: new TextField(
          focusNode: _emailNode,
          style: TextStyle(
            fontSize: 17.0
          ),
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          decoration: new InputDecoration(
              labelText: email,
              labelStyle: new  TextStyle(
                color: new Color(_getColor(viewModel.status, viewModel.emailError, _emailNode))
              ),
              border: InputBorder.none
          ),
          onChanged: (email){
            viewModel.validateEmail(email);
          },
        ),
      ),
    ),
  );

  Widget passwordInput(LoginViewModel viewModel) => Padding(
    padding: const EdgeInsets.only(left: 65.0,right: 65.0,top: 16.0),
    child: Container(
      alignment: new Alignment(0.5, 0.5),
      height: 56.0,
      decoration: BoxDecoration(
        color: Color(semiTransparentGray),
        border: Border(bottom: BorderSide(
            color: new Color(_getColor(viewModel.status, viewModel.passwordError, _passNode)),
            width:1.0
        )),
      ),
      child:  Padding(
        padding: const EdgeInsets.only(left: 16.0,bottom: 8.0),
        child: new TextField(
          focusNode: _passNode,
          style: TextStyle(
              fontSize: 17.0
          ),
          obscureText: true,
          keyboardType: TextInputType.text,
          controller: _passController,
          decoration: new InputDecoration(
              labelText: password,
              labelStyle: new  TextStyle(
                  color: new Color(_getColor(viewModel.status, viewModel.passwordError, _passNode))
              ),
              border: InputBorder.none
          ),
          onChanged: (password){
            viewModel.validatePassword(password);
          },
        ),
      ),
    ),
  );

  Widget actionButton(VoidCallback callback, int color, String label) =>
    GestureDetector(
      child: Container(
        width: 100.0,
        height: 44.0,
        color: Color(color),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white
          ),
        ),
      ),
      onTap: callback,
    );

  Widget signupBtn(VoidCallback callback) => actionButton(callback, primaryPink, signup);
  Widget loginBtn(VoidCallback callback) => actionButton(callback, primaryBlue, login);

  Widget forgotPassword() => Padding(
    padding: const EdgeInsets.only(left: 65.0,right: 65.0,top: 16.0),
    child: new GestureDetector(
      child: new Text(
        forgot_password,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(primaryBlue)
        ),
      ),
      onTap: (){
        //TODO navigate to forgot password
      },
    ),
  );

  Widget termsAndConditions() => Padding(
      padding: const EdgeInsets.only(left: 65.0,right: 65.0,top: 4.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child:new Text(terms,
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            onTap: (){
              //TODO navigate to terms
            },
          ),
          new Text(and_with_spaces,
            style: TextStyle(
                fontSize: 12.0,
                color: Color(botomAccentLightGray)
            ),
          ),
          GestureDetector(
            child:new Text(policy,
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            onTap: (){
              //TODO navigate to policy
            },
          ),
        ],
      ),
  );

  Future delay(Function f) async{
    await new Future.delayed(new Duration(milliseconds: 4000), f());
  }

  Widget emailError(LoginViewModel viewModel) => Padding(
    padding: EdgeInsets.only(left: 65.0,right: 65.0, top:2.0),
    child: new Text(viewModel.emailError,
      style: TextStyle(
        fontSize: 10.0,
        color: Color(error_red)
      ),
    ),
  );

  Widget passwordError(LoginViewModel viewModel) => Padding(
    padding: EdgeInsets.only(left: 65.0,right: 65.0, top:2.0),
    child: new Text(viewModel.passwordError,
      style: TextStyle(
          fontSize: 10.0,
          color: Color(error_red)
      ),
    ),
  );

  int _getColor(LoadingStatus status, String error, FocusNode node){
    if(!node.hasFocus) {
      return default_text_gray;
    }else{
      return primaryBlue;
    }
  }
}
