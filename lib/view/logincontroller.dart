import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yoyoza/Model/User.dart';
import 'package:yoyoza/Model/UserResponse.dart';
import 'package:yoyoza/service/UserService.dart';

import 'forgotpasswordcontroller.dart';
import 'landing.dart';

class LoginPageAsync extends StatefulWidget {
  final VoidCallback _onSignIn;

  LoginPageAsync({@required onSignIn})
  :assert(onSignIn != null),
  _onSignIn = onSignIn;

  @override
  _LoginPageAsyncState createState() => _LoginPageAsyncState();
}



class _LoginPageAsyncState extends State<LoginPageAsync> {
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
          userService.signIn(newUser)
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
     print('sign in result');
     print(entity.description);
     print(entity.error);
    widget._onSignIn();
    if(entity.isValid)
    {
        _isLoggedIn =true;
      _isInAsyncCall = false;
      _navNext(context);
      //showMessage("User is logged in ${entity.user.email}",Colors.blue);
    }else{
      //showMessage("Could not login ${entity.description}",Colors.red);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoyoza !!',textAlign: TextAlign.center),
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
            child: txtEmail('Email',Icons.email,textTheme),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:txtPassword("Password",Icons.lock,textTheme),
          ),
      Padding(
        padding: const EdgeInsets.all(32.0),
          child:
          Row(children: <Widget>[

            Expanded(
              child: RaisedButton(
                onPressed: _submit,
                child: Text('Login'),
                color: Colors.blue,
                textColor: Colors.white,
                splashColor: Colors.grey,
              ),
            ),
            Expanded(
              child:RaisedButton(
                onPressed: () {
                  _navForgotPassword(context);
                },
                child: Text('Forgot Password'),
                color: Colors.white,
                textColor: Colors.black,
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
    Navigator.push(context,new MaterialPageRoute(builder: (context)=> new LandingPage()));
  }

  void _navForgotPassword(BuildContext context)
  {
    Navigator.push(context,new MaterialPageRoute(builder: (context)=> new ForgotPasswordController()));
  }

  Container headerSection()
  {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:30.0),
        child:Text("Sign In.",

            style: TextStyle(
                color:Colors.black26,
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            ))
    );
  }

  TextFormField txtEmail(String title,IconData icon,TextTheme textTheme){
/*
    TextFormField(
      key: Key('username'),
      decoration: InputDecoration(
          hintText: 'enter email', labelText: 'User Name'),
      style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
      validator: _validateEmail,
      onSaved: (value) => _email = value,
    );
*/
    return TextFormField(
      key: Key('username'),
      controller: emailController,
      decoration: const InputDecoration(
        icon: const Icon(Icons.email),
        hintText: 'Enter an email address',
        labelText: 'Email',

      ),
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [new LengthLimitingTextInputFormatter(50)],
      validator: _validateEmail,
      onSaved: (val)=> newUser.email =val,
    );
/*
    return TextFormField(
        key: Key('username'),
        controller: emailController,
        style: TextStyle(color:Colors.white70),
        decoration:InputDecoration(
            hintText:title,
            hintStyle:TextStyle(color:Colors.white70),
            icon:Icon(icon)
        )

    );
    */
  }

  TextFormField txtPassword(String title,IconData icon,TextTheme textTheme){
    /*
    return TextFormField(
        controller: passwordController,
        obscureText: true,
        style: TextStyle(color:Colors.white70),
        decoration:InputDecoration(
            hintText:title,
            hintStyle:TextStyle(color:Colors.white70),
            icon:Icon(icon)
        )

    );

    TextFormField(
              key: Key('password'),
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'enter password', labelText: 'Password'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: _validatePassword,
              onSaved: (value) => _password = value,
            ),
*/
    return TextFormField(
      key: Key('password'),
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
          icon:const Icon(Icons.person),
          hintText:'Enter you password',
          labelText: 'Password'
      ),
      inputFormatters: [new LengthLimitingTextInputFormatter(30)],
      validator: _validatePassword,
      onSaved: (val)=> newUser.password = val,
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
