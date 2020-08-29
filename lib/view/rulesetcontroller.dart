import 'package:flutter/material.dart';
import 'package:yoyoza/Model/Milestone.dart';
import 'package:yoyoza/Model/RequestResidentialUnit.dart';
import 'package:yoyoza/Model/RuleSet.dart';
import 'package:yoyoza/view/requestcontroller.dart';
import 'package:yoyoza/service/requestresidentialunitservice.dart';
import 'package:yoyoza/service/requestservice.dart';
import 'package:yoyoza/view/milestonecontroller.dart';
import '../Model/Request.dart';



class RuleSetController extends StatefulWidget {
  RuleSetController({this.parentEntity});
  final Milestone parentEntity;
  @override
  _RuleSetControllerState createState() => _RuleSetControllerState(parentEntity:this.parentEntity);
}

class _RuleSetControllerState extends State<RuleSetController> {
  _RuleSetControllerState({this.parentEntity});
  final Milestone parentEntity;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    print('before scaffold');
    print(parentEntity);
    return new Scaffold(
      key:_scaffoldKey,
        appBar: new AppBar(
          title: new Text(parentEntity.ordinal.toString() +'. ' + parentEntity.name + ': Rules'),

        ),
        body:parentEntity.rules == null
            ? Center(child: Text('Empty'),)
            :_buildMilestoneRuleList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMilestoneRuleList(){


    return ListView.builder(
      itemCount:parentEntity.rules.length,
      itemBuilder: (context,index) {
        return new ListTile(

            title: new Row(
              children: <Widget>[

                new Expanded(child:

                new Text(parentEntity.rules[index].ordinal.toString() +'. ' +parentEntity.rules[index].name)),
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

  void showMessage(String message,[MaterialColor color = Colors.red])
  {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(
        backgroundColor: color,
        content: new Text(message)));
  }

}
