import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Model/Globals.dart';
import '../Model/UserResponse.dart';
import '../Model/User.dart';

class UserService{
static const _serviceUrl ='http://mockbin.org/echo';
static final _headers ={'Content-Type':'application/json'};

Future<UserResponse> signIn(User entity) async {
  String targethost = '13.244.198.236';
  UserResponse resp = new UserResponse();
  var queryParameters = {
    'username': entity.email,
    'password': entity.password,

  };
  //we are using asp.net Identity for login/registration. the first time we
  //login we must obtain an OAuth token which we obtain by calling the Token endpoint
  //and pass in the email and password that the user registered with.
  try {

    var gettokenuri = new Uri(scheme: 'http',
        //      host: '10.0.2.2',
        //port: 80,
        host: targethost,
        path: '/Token');

    //the user name and password along with the grant type are passed the body as text.
    //and the contentype must be x-www-form-urlencoded
    var loginInfo = 'UserName=' + entity.email + '&Password=' + entity.password +
        '&grant_type=password';
  print('login info ${loginInfo }');
    final response = await http
        .post(
        gettokenuri,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: loginInfo
    );


    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      resp.isValid =true;
      resp.user = entity;
      Globals.token = json['access_token'] as String;

      //need to get user details at this point
      //userID
      //FullName
    }
    else {

      final json = jsonDecode(response.body);
      //this call will fail if the security stamp for user is null

      resp.error = response.statusCode.toString() + ' ' + response.body;
      resp.description = json['error_description'] as String;
      resp.isValid =false;
      return resp;
    }
  }
  catch (e){
    print('thrown exception');
    resp.isValid =false;
    resp.error = e.message;
  }
  return   resp ;
}

Future<UserResponse> forgotPassword(User entity) async {
print('forgot password');
  UserResponse resp = new UserResponse();

  try {

    var url = new Uri(scheme: Globals.scheme,
        host: Globals.apiHost,
        path: HttpUrl.accountForgotPath
    );
print(url);
print(entity.email);
    var loginInfo = 'email=' + entity.email;

    final response = await http
        .post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: loginInfo
    );
print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      resp.isValid =true;
      resp.user = entity;
    }
    else {
      final json = jsonDecode(response.body);
      resp.error = response.statusCode.toString() + ' ' + response.body;
      resp.description = json['error_description'] as String;
      resp.isValid =false;
      return resp;
    }
  }
  catch (e){
    resp.isValid =false;
    resp.error = e.message;
  }
  return   resp ;
}
}