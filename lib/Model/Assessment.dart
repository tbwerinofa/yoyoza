import 'Question.dart';


class Assessment {
  int id;
  String respondent;
  String fullName;
  String riskLevel;
  String outComes;
  String lastUpdated;
  String riskColor;
  //List<Question> milestoneRuleSet;


  Assessment({
    this.id,
    this.respondent,
    this.fullName,
    this.riskLevel,
    this.outComes,
    this.lastUpdated,
    this.riskColor

   // this.milestoneRuleSet
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    var model = new Assessment(
        id: json['Id'],
        respondent: json['Respondent'],
        fullName: json['FullName'],
        riskLevel: json['RiskLevel'],
        outComes: json['OutComes'],
      lastUpdated: json['LastUpdated'],
      riskColor: json['RiskColor'],

       // milestoneRuleSet: (json['MilestoneRuleSet'] as List).map((value) => new Question.fromJson(value)).toList()

    );


    // var list = json['MilestoneRuleSet'] as List;
    //print(list.runtimeType); //returns List<dynamic>
    // List<MileStoneRule> imagesList = list.map((i) => MileStoneRule.fromJson(i)).toList();
    return model;
  }

  Map<String,dynamic>toMap()
  {
    var map = Map<String,dynamic>();
    map["Id"] = id;
    map["Respondent"] = respondent;
    map["FullName"] = fullName;
    map["RiskLevel"] = riskLevel;
    map["OutComes"] = outComes;
    map["LastUpdated"] =lastUpdated;
    map["RiskColor"] =riskColor;
   // map["MilestoneRuleSet"] =encondeToJson(milestoneRuleSet);


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
