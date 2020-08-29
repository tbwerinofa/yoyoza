import 'package:flutter/material.dart';
import 'package:yoyoza/view/assessmentcontroller.dart';
import 'package:yoyoza/service/assessmentgroupservice.dart';
import '../Model/Globals.dart';
import '../Model/AssessmentGroup.dart';
import '../Model/Assessment.dart';
import 'logincontroller.dart';



class AssessmentGroupController extends StatefulWidget {
  @override
  _AssessmentGroupControllerState createState() => _AssessmentGroupControllerState();
}

void _navNext(BuildContext context)
{
  print(Globals.token);
  Navigator.push(context,new MaterialPageRoute(builder: (context)=> new AssessmentGroupController()));
}

class _AssessmentGroupControllerState extends State<AssessmentGroupController> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('myAssessments'),
        ),
        body: GetEntityList()
    );
  }

  //In future builder, it calls the future function to wait for the result, and as soon as it produces the result it calls the builder function where we build the widget.
  Widget GetEntityList() {
    AssessmentGroupService modelSrv  = new AssessmentGroupService();

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

              print('has error');
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

  Widget _buildEntityList(List<AssessmentGroup> entityList){

    if(entityList ==null || entityList.length == 0)
      {
        return ListView.builder(
          itemCount:1,
          itemBuilder: (context,index) {
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: ListTile(
                    title: entityList ==null
                        ?Text("Session Expired, Click to login!")
                        :Text("No Pending Assessments!") ,
                  onTap: () {
                    if(entityList ==null) {
                      navigateToLogin();
                    }
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
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: ListTile(
                leading: _displayByStyle(),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text(
                    entityList[index].organisation),
                onTap: () {
                  print('navigate');


                  navigateToRequest(entityList[index]);
                },
              ),
              subtitle: Text('Survey Date: ${entityList[index].surveyDateString}'),
            ),
          );
        },
      );
    }
  }

  void navigateToRequest(AssessmentGroup entity) async{
    print('about to navigate');
    print(entity.id);

    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => AssessmentController(parentEntity: entity))
    );
  }


  void navigateToLogin() async{

    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginPageAsync( onSignIn: () =>{}))
    );
  }

  Widget _buildFloatingActionButton(){
    return FloatingActionButton(
      child:Icon(Icons.person_add),
      onPressed: (){
        //navigateToRequest(Assessment('','','','',''));
      },
    );
  }

  Widget _displayByStyle(){
    return Icon(Icons.account_balance);
  }

}

