import 'dart:convert';
import 'package:http/http.dart' as http;
class GenerateImageUrl{
  bool success;
  String message;

  bool isGenerated;
  String uploadUrl;
  String downloadUrl;
  final String url ='';
  Future<void> call(String fileType)async{
    try{
      Map body = {'fileType':fileType};
      var response = await http.post(
        url,
        body:body
      );

      var result = jsonDecode(response.body);
      print(result);

      if(result['success']!=null)
        {
          success = result['success'];
          message = result['image'];

          if(response.statusCode ==200)
            {
              isGenerated =true;
              uploadUrl = result['uploadUrl'];
              downloadUrl = result['downloadUrl'];
            }
        }
    }catch(e){
      throw('Error getting url');
    }
  }
}