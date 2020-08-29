import 'Question.dart';

class QuestionGroup {
  int id;
  int ordinal;
  String name;
  List<Question> questions;

  QuestionGroup({
    this.id,
    this.name,
    this.ordinal,
    this.questions});

  factory QuestionGroup.fromJson(Map<String, dynamic> json) {
    var model = new QuestionGroup(
        id: json['Id'],
        name: json['Name'],
        ordinal: json['Id'],
        questions: (json['Questions'] as List).map((value) => new Question.fromJson(value)).toList()
    );
    return model;
  }

  Map<String,dynamic>toMap()
  {
    var map = Map<String,dynamic>();
    map["Id"] = id;
    map["Name"] = name;
    map["Ordinal"] = ordinal;
    questions: encondeToJson(questions);;

    return map;
  }

  static List encondeToJson(List<Question>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toMap())
    ).toList();
    return jsonList;
  }
}
