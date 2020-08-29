
class MileStoneRule {
  int id;
  String name;
  int ordinal;
  String milestone;
  int milestoneId;
  int requestResidentialUnitId;
  int requestId;
  bool hasPassed;

  MileStoneRule({
    this.id,
    this.name,
    this.ordinal,
    this.milestone,
    this.milestoneId,
    this.requestResidentialUnitId,
    this.requestId,
    this.hasPassed,
  });



  factory MileStoneRule.fromJson(Map<String, dynamic> json) {
    return new MileStoneRule(
      id: json['Id'],
      name: json['Name'],
      ordinal: json['Ordinal'],
      milestone: json['Milestone'],
      milestoneId: json['MilestoneId'],
      requestResidentialUnitId: json['RequestResidentialUnitId'],
      requestId: json['RequestId'],
      hasPassed: json['HasPassed'],
    );
  }

  Map<String,dynamic>toMap()
  {
    var map = Map<String,dynamic>();
    map["Id"] = id;
    map["Name"] = name;
    map["Ordinal"] = ordinal;
    map["Milestone"] = milestone;
    map["MilestoneId"] = milestoneId;
    map["RequestResidentialUnitId"] = requestResidentialUnitId;
    map["RequestId"] = requestId;
    map["HasPassed"] = hasPassed;
    return map;
  }
}
