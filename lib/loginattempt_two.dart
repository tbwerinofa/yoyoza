import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoyoza/Model/UserResponse.dart';
import 'Model/Globals.dart';
import 'Model/User.dart';
import 'service/UserService.dart';
import 'view/landing.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key,this.title}):super(key:key);
  final String title;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  //global key
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _colors =<String>['','red','green','blue','orange'];
  String _color='';
  User newUser = new User('','','');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key:_scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body:new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            key:_formKey,
            autovalidate: true,
            child:new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new TextFormField(
                  decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter an email address',
                      labelText: 'Email',

                  ),
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                  validator: (val)=> isValidEmail(val)?null:'Please enter a valid email address',
                  onSaved: (val)=> newUser.email =val,
                ),
                new TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon:const Icon(Icons.person),
                    hintText:'Enter you password',
                    labelText: 'Password'
                  ),
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  validator: (val)=>val.isEmpty?'password is required':null,
                  onSaved: (val)=> newUser.password = val,
                ),

                new Container(
                  padding: const EdgeInsets.only(left:40.0,top:20.0),
                  child: new RaisedButton(
                    child:const Text('Submit'),
                      onPressed: _submitForm)
                )
              ],
            )

          )
          )
    );


  }
void _submitForm(){
    final FormState form = _formKey.currentState;
    if(!form.validate())
      {
        showMessage('Form is not valid! Please review and correct');
      }else{
      form.save();


      //save to rest
      var userService = new UserService();
      userService.signIn(newUser)
      .then((value)=>
          signInResult(value)
      );
    }
}

  void signInResult(UserResponse entity)
  {
  if(entity.isValid)
    {
      _navNext(context);
      //showMessage("User is logged in ${entity.user.email}",Colors.blue);
    }else{
     showMessage("Could not login ${entity.description}",Colors.red);
  }
  }

  void _navNext(BuildContext context)
  {
    print(Globals.token);
    Navigator.push(context,new MaterialPageRoute(builder: (context)=> new LandingPage()));
  }

void showMessage(String message,[MaterialColor color = Colors.red])
{
  _scaffoldKey.currentState
      .showSnackBar(new SnackBar(
      backgroundColor: color,
      content: new Text(message)));
}
  bool isValidEmail(String input)
  {

    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }
}
