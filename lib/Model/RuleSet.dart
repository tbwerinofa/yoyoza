
class RuleSet {
  int id;
  String name;
  String description;
  bool isMandatory;
  int milestoneId;
  int ordinal;

  RuleSet({
    this.id,
    this.name,
    this.description,
    this.isMandatory,
    this.milestoneId,
    this.ordinal,
  });



  factory RuleSet.fromJson(Map<String, dynamic> json) {
    return new RuleSet(
      name: json['Name'],
      description: json['Description'],
      isMandatory: json['IsMandatory'],
      milestoneId: json['MilestoneId'],
      ordinal: json['Ordinal'],

    );
  }



  Map<String,dynamic>toMap()
  {
    var map = Map<String,dynamic>();
    map["Id"] = id;
    map["Name"] = name;
    map["Description"] = description;
    map["MilestoneId"] = milestoneId;
    map["Ordinal"] = ordinal;
    return map;
  }


}
