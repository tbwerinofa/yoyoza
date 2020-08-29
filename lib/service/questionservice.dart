import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:yoyoza/Model/QuestionGroup.dart';
import '../Model/Globals.dart';


class QuestionService{


  Future<List<QuestionGroup>> fetchEntityList() async{
    print('Api Call');
    List<QuestionGroup> resultList = new List<QuestionGroup>();

    var url = new Uri(scheme: Globals.scheme,
      host: Globals.apiHost,
      path: Globals.questionPath,
    );
    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
    print('Api before milestone Url');
    print(url);
    print('AUth - ${Globals.authorization}');
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: Globals.authorization},
    );

    print(response.statusCode);

    //alice.onHttpResponse(response);
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      print('In business');
      print(json);
      resultList = json.map((model)=> QuestionGroup.fromJson(model)).toList();
      print('finished');
    }
    else {
      // resp.error = response.reasonPhrase;
     // return 'error';
    }

    print('Api After return');
    return resultList;
  }

  static Future<bool> postEntity(QuestionGroup entity) async{

    var url = new Uri(scheme: Globals.scheme,
        host: Globals.apiHost,
        path: Globals.questionPath
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