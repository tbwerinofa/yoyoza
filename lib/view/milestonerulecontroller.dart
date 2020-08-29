import 'package:flutter/material.dart';
import 'package:yoyoza/Model/Milestone.dart';
import 'package:yoyoza/Model/RequestResidentialUnit.dart';
import 'package:yoyoza/Model/RuleSet.dart';
import 'package:yoyoza/view/requestcontroller.dart';
import 'package:yoyoza/service/requestresidentialunitservice.dart';
import 'package:yoyoza/service/requestservice.dart';
import 'package:yoyoza/view/milestonecontroller.dart';
import '../Model/Request.dart';



class MilestoneRuleController extends StatefulWidget {
  MilestoneRuleController({this.parentEntity});
  final Milestone parentEntity;
  @override
  _MilestoneRuleControllerState createState() => _MilestoneRuleControllerState(parentEntity:this.parentEntity);
}



class _MilestoneRuleControllerState extends State<MilestoneRuleController> {
  _MilestoneRuleControllerState({this.parentEntity});
  final Milestone parentEntity;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<RuleSet> _entityList = new  List<RuleSet>();
  @override
  Widget build(BuildContext context) {

    print('before scaffold');
    print(parentEntity);
    return new Scaffold(
      key:_scaffoldKey,
        appBar: new AppBar(
          title: new Text('Request Residential Units'),
        ),
        body: parentEntity.rules == null
            ? Center(child: Text('Empty'),)
            :_buildMilestoneRuleList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }


  Widget _buildMilestoneRuleList(){


    return ListView.builder(
      itemCount:parentEntity.rules.length,
      itemBuilder: (context,index) {


       // bool isSelected =  parentEntity.milestoneRuleSet[index].hasPassed;
        return new ListTile(

            title: new Row(
              children: <Widget>[

                new Expanded(child:

                new Text(parentEntity.rules[index].ordinal.toString() +'. ' +parentEntity.rules[index].name)),
                /*
                new Checkbox(
                    value: isSelected,
                    onChanged: (bool value) {
                      setState(() {
                        parentEntity.milestoneRuleSet[index].hasPassed = value;
                      });
                    })
                */
              ],
            ));

      },
    );
  }


  //In future builder, it calls the future function to wait for the result, and as soon as it produces the result it calls the builder function where we build the widget.
  Widget GetRequestList() {
    RequestResidentialUnitService modelSrv  = new RequestResidentialUnitService();

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


  Widget _buildResultList(List<RequestResidentialUnit> entityList){
    return ListView.builder(
      itemCount:entityList.length,
      itemBuilder: (context,index) {
        return Card(
          color:_toggleColor(entityList[index].isCompliant),
          elevation: 2.0,
          child: ListTile(
            title: ListTile(
              leading: _displayByStyle(entityList[index].isCompliant),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(
                  'Stand No: ${entityList[index].unit}'),
              onTap: () {
                navigateToMilestone(entityList,entityList[index]);
              },

            ),
            subtitle: InspectionSubtitle(entityList[index].hasInspection),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(){
    return BottomAppBar(

      child: RaisedButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Text('Finalise'),
        onPressed: (){

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
