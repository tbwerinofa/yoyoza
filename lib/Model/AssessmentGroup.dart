class AssessmentGroup {
  int _id;
  String _organisation;
  String _surveyDateString;
  //String _surveyDate;
  int _finYear;
  String _calendarMonth;
  int _assessments;




  AssessmentGroup(this._organisation,this._surveyDateString,this._finYear,this._calendarMonth,this._assessments);
  AssessmentGroup.WithId(this._id,this._organisation,this._surveyDateString,this._finYear,this._calendarMonth,this._assessments);


  int get  id => _id;
  String get organisation =>_organisation;
  String get surveyDateString =>_surveyDateString;
  int get finYear =>_finYear;
  String get calendarMonth =>_calendarMonth;
  int get assessments =>_assessments;


  set comment(String neworganisation)
  {
    _organisation = neworganisation;
  }
  set surveyDateString(String newsurveyDateString)
  {
    _surveyDateString = newsurveyDateString;
  }
  set project(int newfinYear )
  {
    _finYear = newfinYear;
  }
  set requestDateString(String newcalendarMonth)
  {
    _calendarMonth = newcalendarMonth;
  }
  set assessments(int newassessments)
  {
    _assessments = newassessments;
  }

  Map<String,dynamic>toMap()
  {
    var map = Map<String,dynamic>();
    map["Id"] = _id;
    map["Organisation"] = _organisation;
    map["SurveyDateString"] = _surveyDateString;
    map["FinYear"] = _finYear;
    map["CalendarMonth"] = _calendarMonth;
    map["Assessments"] = _assessments;
    
    return map;
  }

  AssessmentGroup.fromObject(dynamic o){
    this._id =o["Id"];
    this._organisation = o["Organisation"];
    this._surveyDateString = o["SurveyDateString"];
    this._finYear = o["FinYear"];
    this._calendarMonth = o["CalendarMonth"];
    this._assessments = o["Assessments"];

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
