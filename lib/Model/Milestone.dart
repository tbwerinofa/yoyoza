import 'RuleSet.dart';

class Milestone {
  int id;
  String name;
  String discriminator;
  String description;
  int ordinal;
  List<RuleSet> rules;

  Milestone({
    this.id,
    this.name,
    this.discriminator,
    this.description,
    this.ordinal,
    this.rules});

  factory Milestone.fromJson(Map<String, dynamic> json) {
    var model = new Milestone(
        id: json['Id'],
        name: json['Name'],
        discriminator: json['Discriminator'],
        description: json['Description'],
        ordinal: json['Ordinal'],
        rules: (json['Rules'] as List).map((value) => new RuleSet.fromJson(value)).toList()
    );
    return model;
  }

  Map<String,dynamic>toMap()
  {
    var map = Map<String,dynamic>();
    map["Id"] = id;
    map["Name"] = name;
    map["Discriminator"] = discriminator;
    map["Description"] = description;
    map["Ordinal"] = ordinal;
    rules: encondeToJson(rules);;

    return map;
  }

  static List encondeToJson(List<RuleSet>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toMap())
    ).toList();
    return jsonList;
  }
}
