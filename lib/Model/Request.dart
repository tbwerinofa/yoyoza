class Request {
  int _id;
  String _comment;
  String _requestNo;
  String _project;
  String _requestDateString;
  String _stateMachine;

  Request(this._comment,this._requestNo,this._project,this._requestDateString,this._stateMachine);
  Request.WithId(this._id,this._comment,this._requestNo,this._project,this._requestDateString,this._stateMachine);


  int get  id => _id;
  String get comment =>_comment;
  String get requestNo =>_requestNo;
  String get project =>_project;
  String get requestDateString =>_requestDateString;
  String get stateMachine =>_stateMachine;


  set comment(String newComment)
  {
    _comment = newComment;
  }
  set requestNo(String newRequestNo)
  {
    _requestNo = newRequestNo;
  }
  set project(String newProject)
  {
    _project = newProject;
  }
  set requestDateString(String newRequestDateString)
  {
    _requestDateString = newRequestDateString;
  }
  set stateMachine(String newStateMachine)
  {
    _stateMachine = newStateMachine;
  }

  Map<String,dynamic>toMap()
  {
    var map = Map<String,dynamic>();
    map["Id"] = _id;
    map["Comment"] = _comment;
    map["RequestNo"] = _requestNo;
    map["Project"] = _project;
    map["RequestDateString"] = _requestDateString;
    map["StateMachine"] = _stateMachine;

    return map;
  }

  Request.fromObject(dynamic o){
    this._id =o["Id"];
    this._comment = o["Comment"];
    this._requestNo = o["RequestNo"];
    this._project = o["Project"];
    this._requestDateString = o["RequestDateString"];
    this._stateMachine = o["StateMachine"];

  }
}

/*import 'package:json_annotation/json_annotation.dart';
part 'Request.g.dart';

@JsonSerializable()
class Request{
  int id;
  String comment;
  String requestNo;
  String project;
  String requestDateString;
  String stateMachine;

  Request(this.id,this.comment,this.requestNo,this.project,this.requestDateString,this.stateMachine);

  factory Request.fromJson(Map<String,dynamic> json)=> _$RequestFromJson(json);
  Map<String,dynamic> toJson()=>_$RequestToJson(this);
}
*/
