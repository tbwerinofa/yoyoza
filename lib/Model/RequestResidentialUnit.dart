import 'MilestoneRule.dart';


class RequestResidentialUnit {
  int id;
  String unit;
  int residentialUnitId;
  int requestId;
  String milestone;
  int milestoneId;
  bool isCompliant;
  bool hasInspection;
  double latitude;
  double longitude;
  List<MileStoneRule> milestoneRuleSet;


  RequestResidentialUnit({
    this.id,
    this.unit,
    this.residentialUnitId,
    this.milestone,
    this.requestId,
    this.milestoneId,
    this.isCompliant,
    this.hasInspection,
    this.latitude,
    this.longitude,
    this.milestoneRuleSet
  });

  factory RequestResidentialUnit.fromJson(Map<String, dynamic> json) {
    var model = new RequestResidentialUnit(
        id: json['Id'],
        unit: json['Unit'],
        residentialUnitId: json['ResidentialUnitId'],
        milestone: json['Milestone'],
        milestoneId: json['MilestoneId'],
        requestId: json['RequestId'],
        isCompliant: json['IsCompliant'],
        hasInspection:json['HasInspection'],
        latitude:json['Latitude'],
        longitude:json['Longitude'],
        milestoneRuleSet: (json['MilestoneRuleSet'] as List).map((value) => new MileStoneRule.fromJson(value)).toList()

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
    map["Unit"] = unit;
    map["ResidentialUnitId"] = residentialUnitId;
    map["Milestone"] = milestone;
    map["RequestId"] = requestId;
    map["MilestoneId"] = milestoneId;
    map["IsCompliant"] = isCompliant;
    map["HasInspection"] = hasInspection;
    map["Latitude"] = latitude;
    map["Longitude"] = longitude;
    map["MilestoneRuleSet"] =encondeToJson(milestoneRuleSet);


    return map;
  }

  static List encondeToJson(List<MileStoneRule>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toMap())
    ).toList();
    return jsonList;
  }
}
