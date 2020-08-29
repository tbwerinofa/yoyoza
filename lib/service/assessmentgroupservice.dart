import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:yoyoza/Model/AssessmentGroup.dart';
import '../Model/Globals.dart';


class AssessmentGroupService{

  Future<List<AssessmentGroup>> fetchEntityList() async{

    List<AssessmentGroup> resultList = new List<AssessmentGroup>();

    var url = new Uri(scheme: Globals.scheme,
      host: Globals.apiHost,
      path: Globals.assessmentGroupPath,
    );
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: Globals.authorization},
    );

    print(response.statusCode);
    print(response.headers);
    //alice.onHttpResponse(response);
    if (response.statusCode == 200) {
        try {
          Iterable json = convert.jsonDecode(response.body);
          resultList = json.map((model) => AssessmentGroup.fromObject(model)).toList();
        } catch (e) {
          return null;
       }
    }
    return resultList;
  }

  static Future<bool> postEntity(AssessmentGroup entity) async{

    var url = new Uri(scheme: Globals.scheme,
        host: Globals.apiHost,
        path: Globals.assessmentGroupPath
    );

    var entityBody = convert.jsonEncode(entity.toMap());
    var res = await http.post(
        url,
        headers:headers,
        body:entityBody);
    return Future.value(res.statusCode == 200?true:false);
  }

  static Map<String,String> headers = {
    'Content-type':'application/json',
    'Accpet':'application/json',
    HttpHeaders.authorizationHeader: Globals.authorization
  };
}