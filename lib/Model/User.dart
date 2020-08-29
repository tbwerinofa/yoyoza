import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';

@JsonSerializable()
class User{
  String id;
  String email;
  String password;

  User(this.id,this.email,this.password);

  factory User.fromJson(Map<String,dynamic> json)=> _$UserFromJson(json);
  Map<String,dynamic> toJson()=>_$UserToJson(this);
}