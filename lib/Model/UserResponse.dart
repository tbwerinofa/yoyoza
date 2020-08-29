import 'User.dart';


class UserResponse {
  User user;
  String error;
  String description;
  bool isValid;

  UserResponse();
  UserResponse.mock(User user):
        user  = user,error = "",description="",isValid=false;
}