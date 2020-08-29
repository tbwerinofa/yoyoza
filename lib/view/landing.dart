import 'package:flutter/material.dart';
import 'assessmentgroupcontroller.dart';
import 'questiongroupcontroller.dart';
import 'package:yoyoza/view/requestcontroller.dart';

import '../Model/Globals.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}



class _LandingPageState extends State<LandingPage> {

  List<Color> _backgroundColor;
  Color _iconColor;
  Color _textColor;
  List<Color> _actionContainerColor;
  Color _borderContainer;
  bool colorSwitched = false;
  var logoImage;


  @override
  void initState() {
    changeTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Yoyoza!!'),
      ),
      /*
      body: new Center(
          child:new RaisedButton(
              child: new Text('Requests'),
              onPressed: ()=>_navNext(context))
      ),*/
      body:BuildBodySafeArea()
    );
  }
  void changeTheme() async {
    if (colorSwitched) {
      setState(() {
        logoImage = 'assets/images/yoyoza_logo.jpg';
        _backgroundColor = [
          Color.fromRGBO(252, 214, 0, 1),
          Color.fromRGBO(251, 207, 6, 1),
          Color.fromRGBO(250, 197, 16, 1),
          Color.fromRGBO(249, 161, 28, 1),
        ];
        _iconColor = Colors.white;
        _textColor = Color.fromRGBO(253, 211, 4, 1);
        _borderContainer = Color.fromRGBO(34, 58, 90, 0.2);
        _actionContainerColor = [
          Colors.lightBlueAccent,
          Colors.lightBlueAccent,
          Colors.lightBlueAccent,
          Colors.lightBlueAccent,
        ];
      });
    } else {
      setState(() {
        logoImage = 'assets/images/yoyoza_logo.jpg';
        _borderContainer = Colors.lightBlueAccent;
        _backgroundColor = [
          Color.fromRGBO(249, 249, 249, 1),
          Color.fromRGBO(241, 241, 241, 1),
          Color.fromRGBO(233, 233, 233, 1),
          Color.fromRGBO(222, 222, 222, 1),
        ];
        _iconColor = Colors.black;
        _textColor = Colors.black;
        _actionContainerColor = [
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.white,
        ];
      });
    }
  }



  // ignore: non_constant_identifier_names
  SafeArea BuildBodySafeArea()
  {
    return SafeArea(
      child: GestureDetector(
        onLongPress: () {
          if (colorSwitched) {
            colorSwitched = false;
          } else {
            colorSwitched = true;
          }
          changeTheme();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.2, 0.3, 0.5, 0.8],
                  colors: _backgroundColor)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Image.asset(
                logoImage,
                fit: BoxFit.contain,
                height: 75.0,
                width: 75.0,
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Hello',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    'Tafara Bwerinofa',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Container(
                height: 300.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: _borderContainer,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.2, 0.4, 0.6, 0.8],
                            colors: _actionContainerColor)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 70,
                          child: Center(
                            child: ListView(
                              children: <Widget>[
                                Text(
                                  'COVID-19',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: _textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                Text(
                                  'Health Screening',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: _iconColor, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        Table(
                          border: TableBorder.symmetric(
                            inside: BorderSide(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.5),
                          ),
                          children: [
                            TableRow(children: [
                              _actionList(
                                  'assets/images/ic_transact.png', 'Screening Rules',false),
                              _actionList(
                                  'assets/images/ic_money.png', 'Surveys',true),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


// custom action widget
  Widget _actionList(String iconPath, String desc,bool isRequest) {
    return
      TableRowInkWell(
        onTap: (){
            _navNext(context,isRequest);
         },
        child:Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Image.asset(
            iconPath,
            fit: BoxFit.contain,
            height: 45.0,
            width: 45.0,
            color: _iconColor,

          ),
          SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(color: _iconColor),

          ),

        ],
      ),
        )
    );
  }

  void _navNext(BuildContext context,bool isRequest)
  {
    if(isRequest) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new AssessmentGroupController()));
    }else{
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new QuestionGroupController()));
    }
  }
}
