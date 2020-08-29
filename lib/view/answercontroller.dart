import 'package:flutter/material.dart';
import 'package:yoyoza/Model/Assessment.dart';
import 'package:yoyoza/Model/RequestResidentialUnit.dart';
import 'package:yoyoza/view/requestcontroller.dart';
import 'package:yoyoza/service/locationbl.dart';
import 'package:yoyoza/service/requestresidentialunitservice.dart';
import 'imagecontroller.dart';
import 'imageuicontroller.dart';

class AnswerController extends StatefulWidget {
  AnswerController({this.parentEntity});
  final Assessment parentEntity;
  @override
  _AnswerControllerState createState() => _AnswerControllerState(parentEntity:this.parentEntity);
}

class _AnswerControllerState extends State<AnswerController> {
  _AnswerControllerState({this.parentEntity});
  final Assessment parentEntity;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

   // SetUserLocation();

  }

  @override
  Widget build(BuildContext context) {

    print('before scaffold');
    print(parentEntity);
    return new Scaffold(
      key:_scaffoldKey,
      appBar: _buildAppBar(),
      body: parentEntity.resultSet == null
          ? Center(child: Text('Empty'),)
          :_buildEntityList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar(){
    return AppBar(

        title: Text("Name: ${parentEntity.fullName}"));
  }

  Widget _buildEntityList(){


    return ListView.builder(
      itemCount:parentEntity.resultSet.length,
      itemBuilder: (context,index) {
        return Card(
            elevation: 2.0,
            child: ListTile(
            title: ListTile(
              leading:_displayByStyle(parentEntity.resultSet[index].isSuccess) ,
            trailing: parentEntity.resultSet[index].isSuccess?
                      new Text("Yes"):new Text("No"),
            title: new Row(
              children: <Widget>[

                new Expanded(child:

                new Text(parentEntity.resultSet[index].ordinal.toString() +'. ' +parentEntity.resultSet[index].name)),
              ],
            ))
        ));
      },
    );
      }

  Widget _buildBottomNavigationBar(){
    return BottomAppBar(

      child: RaisedButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Text('Back'),

        onPressed: (){
          Navigator.pop(context,true);
          //  saveMilestone();
        },
      ),

    );
  }



/*
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
  */
  Widget _displayByStyle(bool isCompliant){
    return isCompliant ?Icon(Icons.check_circle,):Icon(Icons.error_outline);
  }
  void showMessage(String message,[MaterialColor color = Colors.red])
  {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(
        backgroundColor: color,
        content: new Text(message)));
  }

}
