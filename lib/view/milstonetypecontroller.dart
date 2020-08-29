import 'package:flutter/material.dart';
import 'package:yoyoza/Model/Milestone.dart';
import 'package:yoyoza/service/milestoneservice.dart';
import 'package:yoyoza/view/requestresidentialunitcontroller.dart';
import 'package:yoyoza/service/requestservice.dart';
import 'package:yoyoza/view/rulesetcontroller.dart';
import '../Model/Globals.dart';
import '../Model/Request.dart';



class MilestoneTypeController extends StatefulWidget {
  @override
  _MilestoneTypeControllerState createState() => _MilestoneTypeControllerState();
}

void _navNext(BuildContext context)
{
  print(Globals.token);
  Navigator.push(context,new MaterialPageRoute(builder: (context)=> new MilestoneTypeController()));
}

class _MilestoneTypeControllerState extends State<MilestoneTypeController> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Milestone'),
        ),
        body: GetEntityList()
    );
  }

  //In future builder, it calls the future function to wait for the result, and as soon as it produces the result it calls the builder function where we build the widget.
  Widget GetEntityList() {
    MilestoneService modelSrv  = new MilestoneService();

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
              return _buildRequestList(snapshot.data);
            }
        }},


      future: modelSrv.fetchEntityList(),
    );
  }

  Widget _buildRequestList(List<Milestone> entityList){
    return ListView.builder(
      itemCount:entityList.length,
      itemBuilder: (context,index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: ListTile(
              leading: Text('${entityList[index].ordinal}'),
              trailing: entityList[index].rules.length >0?Icon(Icons.arrow_forward_ios):null,
              title: Text(
                  entityList[index].name),
              onTap: () {
                if(entityList[index].rules.length >0) {
                  navigateToRequest(entityList[index]);
                }
              },
              subtitle: Text('Rules: ${entityList[index].rules.length}'),
            ),
          ),
        );
      },
    );
  }

  void navigateToRequest(Milestone entity) async{
    print('about to navigate');
    print(entity.id);

    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => RuleSetController(parentEntity: entity))
    );
  }



  Widget _displayByStyle(){
    return Icon(Icons.account_balance,);
  }

}

