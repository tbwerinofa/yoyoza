import 'package:flutter/material.dart';
import 'package:yoyoza/Model/QuestionGroup.dart';
import 'package:yoyoza/service/questionservice.dart';
import 'package:yoyoza/view/QuestionController.dart';
import '../Model/Globals.dart';

class QuestionGroupController extends StatefulWidget {
  @override
  _QuestionGroupControllerState createState() => _QuestionGroupControllerState();
}

void _navNext(BuildContext context)
{
  print(Globals.token);
  Navigator.push(context,new MaterialPageRoute(builder: (context)=> new QuestionGroupController()));
}

class _QuestionGroupControllerState extends State<QuestionGroupController> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Questions'),
        ),
        body: GetEntityList()
    );
  }

  //In future builder, it calls the future function to wait for the result, and as soon as it produces the result it calls the builder function where we build the widget.
  Widget GetEntityList() {
    QuestionService modelSrv  = new QuestionService();

    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Input a URL to start');
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          case ConnectionState.active:
            return new Text('');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return new Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {
              return _buildEntityList(snapshot.data);
            }
        }},


      future: modelSrv.fetchEntityList(),
    );
  }

  Widget _buildEntityList(List<QuestionGroup> entityList){
    return ListView.builder(
      itemCount:entityList.length,
      itemBuilder: (context,index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: ListTile(
              leading: Text('${entityList[index].ordinal}'),
              trailing: entityList[index].questions.length >0?Icon(Icons.arrow_forward_ios):null,
              title: Text(
                  entityList[index].name),
              onTap: () {
                if(entityList[index].questions.length >0) {
                  navigateToQuestion(entityList[index]);
                }
              },
              subtitle: Text('Questions: ${entityList[index].questions.length}'),
            ),
          ),
        );
      },
    );
  }

  void navigateToQuestion(QuestionGroup entity) async{
    print('about to navigate');
    print(entity.id);

    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => QuestionController(parentEntity: entity))
    );
  }



  Widget _displayByStyle(){
    return Icon(Icons.account_balance,);
  }

}

