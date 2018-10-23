import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:reduxsample/models/gender.dart';
import 'package:reduxsample/models/loading_status.dart';
import 'package:reduxsample/models/signup_request.dart';
import 'package:reduxsample/redux/app/app_state.dart';
import 'signup_viewmodel.dart';
import 'package:reduxsample/utils/strings.dart';
import 'package:reduxsample/utils/colors.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  final TextEditingController _retypePassController =  new TextEditingController();

  FocusNode _emailNode = new FocusNode();
  FocusNode _passNode = new FocusNode();
  FocusNode _retypePassNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) =>
          SafeArea(
            child: Container(
              color: Colors.black,
              child: StoreConnector<AppState,SignUpViewModel>(
                  builder: (_,viewModel)=> content(viewModel, constraints),
                  converter: (store) => SignUpViewModel.fromStore(store)),

            ),
          )
      ),
    );
  }

  Widget content(SignUpViewModel viewModel, BoxConstraints constraints) =>
    viewModel.status != LoadingStatus.loading?Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          header(),
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      input(
                        controller: _emailController,
                        hint: email,
                        type: TextInputType.emailAddress,
                        changeCallback: (value) => viewModel.validateEmail(value),
                        node: _emailNode,
                        status: viewModel.status,
                        error: viewModel.emailError
                      ),
                      (viewModel.status == LoadingStatus.error && viewModel.emailError.isNotEmpty)?
                          error(viewModel.emailError):SizedBox(),

                      input(
                        controller: _passController,
                        hint: password,
                        obscure: true,
                        changeCallback: (value) => viewModel.validatePassword(value),
                        node: _passNode,
                          status: viewModel.status,
                          error: viewModel.passwordError
                      ),
                      (viewModel.status == LoadingStatus.error && viewModel.passwordError.isNotEmpty)?
                          error(viewModel.passwordError):SizedBox(),

                      input(
                        controller: _retypePassController,
                        hint: retype_password,
                        obscure: true,
                        changeCallback: (value) => viewModel.validatePasswordMatch(viewModel.password,value),
                        node: _retypePassNode,
                          status: viewModel.status,
                          error: viewModel.retypePasswordError
                      ),
                      (viewModel.status == LoadingStatus.error && viewModel.retypePasswordError.isNotEmpty)?
                          error(viewModel.retypePasswordError):SizedBox(),
                      genderBox(viewModel,constraints),
                      new Padding(padding: EdgeInsets.only(bottom: 16.0,left: 16.0,right: 16.0, top: 24.0),
                        child: createBtn(viewModel),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ):new Center(
      child: new CircularProgressIndicator(),
    );

  Widget input({
      LoadingStatus status,
      String error,
      TextEditingController controller,
      Function(String) changeCallback,
      String hint,
      bool obscure = false,
      TextInputType type = TextInputType.text,
      FocusNode node
  }) => Padding(
    padding: new EdgeInsets.only(right: node.hasFocus?16.0:32.0,top: 16.0, left:node.hasFocus?16.0:0.0),
    child: Container(
      alignment: new Alignment(0.5, 0.5),
      height: 56.0,
      decoration: BoxDecoration(
        color: Color(semiTransparentGray),
        border: Border(bottom: BorderSide(
            color: new Color(node.hasFocus?primaryBlue:botomAccentLightGray),
            width:1.0
        )),
      ),
      child:  Padding(
        padding: const EdgeInsets.only(left: 16.0,bottom: 8.0),
        child: new TextField(
          focusNode: node,
          style: TextStyle(
              fontSize: 17.0
          ),
          obscureText: obscure,
          keyboardType: type,
          controller: controller,
          decoration: new InputDecoration(
            labelText: hint,
            labelStyle: new  TextStyle(
                color: new Color(_getColor(status, error, node))
            ),
            border: InputBorder.none
        ),
          onChanged: (value){
            changeCallback(value);
          },
        ),
      ),
    ),
  );

  Widget error(String error) => Padding(
    padding: EdgeInsets.only(top: 2.0),
    child: new Text(error,
      style: TextStyle(
          fontSize: 10.0,
          color: Color(error_red)
      ),
    ),
  );

  Widget header() => Padding(
    padding: const EdgeInsets.only(left: 21.0, top: 21.0),
    child: new Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(Icons.arrow_back,color:  Colors.white,),
          ),
          onTap: (){
            Navigator.of(context).pop();
          },
        ),
        Padding(padding: EdgeInsets.only(left: 32.0,bottom: 4.0),
          child: new Text(create_account,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
            ),
          ),
        )
      ],
    ),
  );

  Widget genderBox(SignUpViewModel viewModel, BoxConstraints constraints) => new Padding(padding: EdgeInsets.only(top: 16.0,right: 32.0),
    child: new Container(
      color: new Color(semiTransparentGray),
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: constraints.maxWidth
        ),
        child: new Padding(padding: EdgeInsets.only(top: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: new Text(select_gender,
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.white
                  ),
                ),
              ),

              new Padding(padding: EdgeInsets.only(top:4.0),
                child: new Row(
                  children: <Widget>[
                    new Radio(
                        activeColor: Color(primaryBlue),
                        value: Gender.UNDEFINED.index,
                        groupValue: viewModel.gender.index,
                        onChanged: (value){
                          Gender gender = Gender.values[value];
                          viewModel.changeGender(gender);
                        },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    new Text(undefined,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: viewModel.gender == Gender.UNDEFINED?Colors.white:new Color(0xB3FFFFFF)
                      ),
                    )
                  ],
                ),
              ),

              new Row(
                children: <Widget>[
                  new Radio(
                      activeColor: Color(primaryBlue),
                      value: Gender.MALE.index,
                      groupValue: viewModel.gender.index,
                      onChanged: (value){
                        Gender gender = Gender.values[value];
                        viewModel.changeGender(gender);
                      },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  new Text(male,
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: viewModel.gender == Gender.MALE?Colors.white:new Color(0xB3FFFFFF)
                    ),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(
                      activeColor: Color(primaryBlue),
                      value: Gender.FEMALE.index,
                      groupValue: viewModel.gender.index,
                      onChanged: (value){
                        Gender gender = Gender.values[value];
                        viewModel.changeGender(gender);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  new Text(female,
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: viewModel.gender == Gender.FEMALE?Colors.white:new Color(0xB3FFFFFF)
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );


  Widget createBtn(SignUpViewModel viewModel) =>
      GestureDetector(
        child: Container(
          height: 44.0,
          color: Color(primaryBlue),
          alignment: Alignment.center,
          child: Text(
            create,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white
            ),
          ),
        ),
        onTap: (){
          var request = new SignUpRequest(viewModel.email,viewModel.password,viewModel.retypePassword);
          viewModel.signUp(request);
        },
      );

  int _getColor(LoadingStatus status, String error, FocusNode node){
    if(!node.hasFocus) {
      return default_text_gray;
    }else{
      return primaryBlue;
    }
  }
}
