import 'package:flutter/material.dart';
import 'package:yoyoza/Model/Assessment.dart';
import 'package:yoyoza/Model/AssessmentGroup.dart';
//import 'package:yoyoza/view/answercontroller.dart';
import 'package:yoyoza/service/assessmentservice.dart';
import '../Model/Request.dart';
import 'answercontroller.dart';
import 'assessmentgroupcontroller.dart';
import 'logincontroller.dart';



class AssessmentController extends StatefulWidget {
  AssessmentController({this.parentEntity});
  final AssessmentGroup parentEntity;
  @override
  _AssessmentControllerState createState() => _AssessmentControllerState(parentEntity:this.parentEntity);
}



class _AssessmentControllerState extends State<AssessmentController> {
  _AssessmentControllerState({this.parentEntity});
  final AssessmentGroup parentEntity;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Assessment> _entityList = new  List<Assessment>();
  @override
  Widget build(BuildContext context) {

    print('before scaffold');
    print(parentEntity);
    return new Scaffold(
      key:_scaffoldKey,
        appBar: new AppBar(
          title: new Text('Results'),
        ),
        body: GetEntityList(),
     // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  //In future builder, it calls the future function to wait for the result, and as soon as it produces the result it calls the builder function where we build the widget.
  Widget GetEntityList() {
    AssessmentService modelSrv  = new AssessmentService();

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
              _entityList = snapshot.data;
              return _buildResultList(snapshot.data);
            }
        }},


      future: modelSrv.fetchEntityList(parentEntity.id),
    );
  }


  Widget _buildResultList(List<Assessment> entityList) {
    if (entityList == null) {
      return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: ListTile(
                title: Text(
                    "Session Expired, Click to login"),
                onTap: () {
                  navigateToLogin();
                },
              ),
            ),
          );
        },
      );
    }
    else {
      return ListView.builder(
        itemCount: entityList.length,
        itemBuilder: (context, index) {
          return Card(
            color: _toggleColor(entityList[index].riskColor),
            elevation: 2.0,
            child: ListTile(
              title: ListTile(
                leading: _displayByStyle(entityList[index].riskColor),
               trailing: Icon(Icons.arrow_forward_ios),
                title: Text(
                    'Name: ${entityList[index].fullName}'),

                onTap: () {
                  navigateToNext(entityList, entityList[index]);
                },

              ),
              subtitle: InspectionSubtitle(entityList[index].riskLevel,entityList[index].outComes),
            ),
          );
        },
      );
    }
  }

  Widget _buildBottomNavigationBar(){
    return BottomAppBar(

      child: RaisedButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Text('Finalise'),
        onPressed: (){
          Navigator.pop(context,true);
        },
      ),

    );
  }

  Text InspectionSubtitle(String riskLevel,String outcomes)
  {
    return riskLevel == "Low" ? Text(

        riskLevel + ':' + outcomes,
        style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.green))
        :
    Text(
      riskLevel + ':' + outcomes,
      style: TextStyle(
          fontStyle: FontStyle.italic),
    );

  }

  void navigateToPrev() async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => AssessmentGroupController()),
    );
  }

  void navigateToNext(List<Assessment> entityList,Assessment entity) async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => AnswerController(parentEntity:entity)),
    );
  }


  Color _toggleColor(String color){
    return color == 'Green' ?Colors.white: Colors.limeAccent;
  }

  Widget _displayByStyle(String color){
    return color == 'Green' ?Icon(Icons.check_circle):Icon(Icons.error);
  }

  void showMessage(String message,[MaterialColor color = Colors.red])
  {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(
        backgroundColor: color,
        content: new Text(message)));
  }
  void navigateToLogin() async{

    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginPageAsync( onSignIn: () =>{}))
    );
  }
}
