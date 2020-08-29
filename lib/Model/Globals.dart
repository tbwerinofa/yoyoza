import 'User.dart';

class Globals {
  static String token; //oauth token
  static User user;
  static String scheme = 'http';
  static String apiHost = '13.244.198.236';
  static String requestPath = '/api/request/';
  static String authorization = 'Bearer ' + Globals.token;
}

class HttpUrl {
  static String accountForgotPath = '/api/accountmanager/forgotpassword';
}
