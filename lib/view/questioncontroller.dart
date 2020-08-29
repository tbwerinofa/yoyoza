import 'package:flutter/material.dart';
import 'package:yoyoza/Model/Milestone.dart';
import 'package:yoyoza/Model/QuestionGroup.dart';
import 'package:yoyoza/Model/RequestResidentialUnit.dart';
import 'package:yoyoza/Model/Question.dart';
import 'package:yoyoza/view/requestcontroller.dart';
import 'package:yoyoza/service/requestresidentialunitservice.dart';
import 'package:yoyoza/service/requestservice.dart';
import 'package:yoyoza/view/milestonecontroller.dart';
import '../Model/Request.dart';



class QuestionController extends StatefulWidget {
  QuestionController({this.parentEntity});
  final QuestionGroup parentEntity;
  @override
  _QuestionControllerState createState() => _QuestionControllerState(parentEntity:this.parentEntity);
}

class _QuestionControllerState extends State<QuestionController> {
  _QuestionControllerState({this.parentEntity});
  final QuestionGroup parentEntity;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    print('before scaffold');
    print(parentEntity);
    return new Scaffold(
      key:_scaffoldKey,
        appBar: new AppBar(
          title: new Text(parentEntity.ordinal.toString() +'. ' + parentEntity.name + ': Questions'),

        ),
        body:parentEntity.questions == null
            ? Center(child: Text('Empty'),)
            :_buildMilestoneRuleList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMilestoneRuleList(){


    return ListView.builder(
      itemCount:parentEntity.questions.length,
      itemBuilder: (context,index) {
        return new ListTile(

            title: new Row(
              children: <Widget>[

                new Expanded(child:

                new Text(parentEntity.questions[index].ordinal.toString() +'. ' +parentEntity.questions[index].name)),
              ],
            ));

      },
    );
  }

  Widget _buildBottomNavigationBar(){
    return BottomAppBar(

      child: RaisedButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Text('Back to List'),
        onPressed: (){
          Navigator.pop(context,true);
        },
      ),

    );
  }

  Text InspectionSubtitle(bool hasInspection)
  {
    return hasInspection ? Text(

        'Status:Inspected.',
        style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.green))
        :
    Text(
      'Status:New',
      style: TextStyle(
          fontStyle: FontStyle.italic),
    );

  }

  void navigateToRequest() async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => RequestController()),
    );
  }

  void navigateToMilestone(List<RequestResidentialUnit> entityList,RequestResidentialUnit entity) async{
    print('navigate to milestone');
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => MilestoneController(parentEntity:entity)),
    );
  }


  Color _toggleColor(bool isCompliant){
    return Colors.white;
  }

  Widget _displayByStyle(bool isCompliant){
    return isCompliant ?Icon(Icons.check_circle):Icon(Icons.account_balance);
  }
}
