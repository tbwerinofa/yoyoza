import 'package:flutter/material.dart';
import 'package:yoyoza/Model/RequestResidentialUnit.dart';
import 'package:yoyoza/view/requestcontroller.dart';
import 'package:yoyoza/service/locationbl.dart';
import 'package:yoyoza/service/requestresidentialunitservice.dart';
import 'imagecontroller.dart';
import 'imageuicontroller.dart';

class MilestoneController extends StatefulWidget {
  MilestoneController({this.parentEntity});
  final RequestResidentialUnit parentEntity;
  @override
  _MilestoneControllerState createState() => _MilestoneControllerState(parentEntity:this.parentEntity);
}

class _MilestoneControllerState extends State<MilestoneController> {
  _MilestoneControllerState({this.parentEntity});
  final RequestResidentialUnit parentEntity;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    SetUserLocation();

  }

  @override
  Widget build(BuildContext context) {

    print('before scaffold');
    print(parentEntity);
    return new Scaffold(
      key:_scaffoldKey,
      appBar: _buildAppBar(),
      body: parentEntity.milestoneRuleSet == null
          ? Center(child: Text('Empty'),)
          :_buildMilestoneRuleList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar(){
    return AppBar(

        title: Text("Stand No: ${parentEntity.unit}"));
  }

  Widget _buildMilestoneRuleList(){


    return ListView.builder(
      itemCount:parentEntity.milestoneRuleSet.length,
      itemBuilder: (context,index) {


        bool isSelected =  parentEntity.milestoneRuleSet[index].hasPassed;
        return new ListTile(

            title: new Row(
              children: <Widget>[

                new Expanded(child:

                new Text(parentEntity.milestoneRuleSet[index].ordinal.toString() +'. ' +parentEntity.milestoneRuleSet[index].name)),
                new Checkbox(
                    value: isSelected,
                    onChanged: (bool value) {
                      setState(() {
                        parentEntity.milestoneRuleSet[index].hasPassed = value;
                      });
                    })
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
        child: Text('Save & Continue'),

        onPressed: (){
          print('save milestone');
          saveMilestone();
        },
      ),

    );
  }

  Future<void> SetUserLocation()
  async {
    LocationBL location = new LocationBL();
    final userLocation =  await location.getUserLocation();
    parentEntity.latitude =userLocation.latitude;
    parentEntity.longitude =userLocation.longitude;


  }
  void saveMilestone() async{

    print('save milestone');
    var saveResponse = await RequestResidentialUnitService.postEntity(parentEntity);
    Navigator.pop(context,true);
    if(saveResponse)
      {
        await Navigator.push(context,
         // MaterialPageRoute(builder: (context) => ImageController(parentEntity:parentEntity)),

          MaterialPageRoute(builder: (context) => ImagePickerUI()),
        );
      }else{
      showMessage('An error occured please try again!',Colors.red);
    }
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
