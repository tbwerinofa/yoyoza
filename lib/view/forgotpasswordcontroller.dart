import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yoyoza/Model/User.dart';
import 'package:yoyoza/Model/UserResponse.dart';
import 'package:yoyoza/service/UserService.dart';
import 'package:yoyoza/view/logincontroller.dart';

import 'forgotpasswordcontroller.dart';
import 'landing.dart';

class ForgotPasswordController extends StatefulWidget {

  @override
  _ForgotPasswordControllerState createState() => _ForgotPasswordControllerState();
}



class _ForgotPasswordControllerState extends State<ForgotPasswordController> {
  // maintains validators and state of form fields
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  User newUser = new User('','','');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  bool _isInvalidAsyncUser = false; // managed after response from server
  bool _isInvalidAsyncPass = false; // managed after response from server

  String _email;
  String _password;
  bool _isLoggedIn = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  // validate user name
  String _validateEmail(String userName) {
    if (userName.length < 6) {
      return 'Username must be at least 6 characters';
    }
    if (!isValidEmail(userName)) {
      return 'Please enter a valid email address';
    }
    if (_isInvalidAsyncUser) {
      // disable message until after next async call
      _isInvalidAsyncUser = false;
      return 'Incorrect user name';
    }

    return null;
  }

  // validate password
  String _validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }


    if (_isInvalidAsyncPass) {
      // disable message until after next async call
      _isInvalidAsyncPass = false;
      return 'Incorrect password';
    }

    return null;
  }

  void _submit() {

    //_loginFormKey.currentState?.validate();
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      // dismiss keyboard during async call
      FocusScope.of(context).requestFocus(new FocusNode());

      // start the modal progress HUD
      setState(() {
        _isInAsyncCall = true;
      });

      // Simulate a service call
      Future.delayed(Duration(seconds: 1), () {

        //save to rest
        setState(() {
          var userService = new UserService();
          userService.forgotPassword(newUser)
              .then((value) =>
              signInResult(value)
          );
          _isInAsyncCall = false;
        });
      });
    }
  }


  void signInResult(UserResponse entity)
  {


    if(entity.isValid)
    {
      _isLoggedIn =true;
      _isInAsyncCall = false;
      _navNext(context);
      //showMessage("User is logged in ${entity.user.email}",Colors.blue);
    }else{
      showMessage("Could not reset password ${entity.description}",Colors.red);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HRTI SYSTEM',textAlign: TextAlign.center),
        backgroundColor: Colors.blue,
      ),
      // display modal progress HUD (heads-up display, or indicator)
      // when in async call
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: buildLoginForm(context),
          ),
        ),
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // run the validators on reload to process async results
    //_loginFormKey.currentState?.validate();
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            //print('Card tapped.');
          },

          child:Form(
            key: this._loginFormKey,

            child: Column(
              children: [
                headerSection(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: txtEmail('UserName',Icons.email,textTheme),
                ),
                Padding(
                    padding: const EdgeInsets.all(32.0),
                    child:
                    Row(children: <Widget>[

                      Expanded(
                        child: RaisedButton(
                          onPressed: _submit,
                          child: Text('Reset Password!'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          splashColor: Colors.grey,
                        ),
                      ),
                    ],
                    )
                )
              ],
            ),
          ),

        ),
      ),
    );
  }

  void _navNext(BuildContext context)
  {
    Navigator.push(context,new MaterialPageRoute(builder: (context)=> new LoginPageAsync(onSignIn: ()=>{})));
  }

  Container headerSection()
  {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:30.0),
        child:Text("Forgot Password.",

            style: TextStyle(
                color:Colors.black26,
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            ))
    );
  }

  TextFormField txtEmail(String title,IconData icon,TextTheme textTheme){

    return TextFormField(
      key: Key('username'),
      controller: emailController,
      decoration: const InputDecoration(
        icon: const Icon(Icons.email),
        hintText: 'Enter an user name',
        labelText: 'Username',

      ),
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [new LengthLimitingTextInputFormatter(50)],
      validator: _validateEmail,
      onSaved: (val)=> newUser.email =val,
    );
  }

  bool isValidEmail(String input)
  {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  void showMessage(String message,[MaterialColor color = Colors.red])
  {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(
        backgroundColor: color,
        content: new Text(message)));
  }
}
