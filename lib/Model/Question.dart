
class Question {
  int id;
  String name;
  int ordinal;
  String message;
  String discriminator;
  bool isSuccess;

  Question({
    this.id,
    this.name,
    this.ordinal,
    this.message,
    this.discriminator,
    this.isSuccess

  });



  factory Question.fromJson(Map<String, dynamic> json) {
    return new Question(
      id: json['ID'],
      name: json['Name'],
      ordinal: json['Ordinal'],
      discriminator: json['Discriminator'],
      message: json['Message'],
      isSuccess: json['IsSuccess'],
    );
  }

  Map<String,dynamic>toMap()
  {
    var map = Map<String,dynamic>();
    map["Id"] = id;
    map["Name"] = name;
    map["Ordinal"] = ordinal;
    map["Discriminator"] = discriminator;
    map["Message"] = message;
    map["IsSuccess"] = isSuccess;
    return map;
  }
}
