import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'logincontroller.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/slide_object.dart';

class IntroController extends StatefulWidget {
  IntroController({Key key}):super(key:key);
  @override
  _IntroControllerState createState() => _IntroControllerState();
}

class _IntroControllerState extends State<IntroController> {
  List<Slide> slides = new List();

  Function goToTab;
  @override initState() {

    slides.add(
        GenerateSlide("Check","Automated e-Health Screening","undraw_design.png")
        );
    slides.add(
        GenerateSlide("Declare","COVID-19 Symptoms and Exposure","undraw_medicine_b1ol.png")
    );
    slides.add(
        GenerateSlide("Verify","COVID-19 Risk mitigation","undraw_observations_mejb.png")
    );

  }

  void onDonePress(){
    //this.goToTab(0);
    Navigator.push(context,new MaterialPageRoute(builder: (context)=>
    new  LoginPageAsync(
        onSignIn: () => print('login successful!'))

    ));


  }
  void onTabChangeCompleted(index){
  }

  Widget renderNextBtn(){
  return Icon(
    Icons.navigate_next,
    color: Color(0xffffcc5c),
      size:35.0
  ) ;
  }

  Widget renderDoneBtn(){
    return Icon(
        Icons.done,
        color: Color(0xffffcc5c),
    ) ;
  }
  Widget renderSkipBtn(){
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    ) ;
  }
List<Widget> renderListCustomTabs(){
    List<Widget> tabs = new List();

    for(int i=0;i<slides.length;i++)
      {
        Slide currentSlide =slides[i];
        tabs.add(Container(
          margin:EdgeInsets.only(bottom: 60.0,top:60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                child:
                Image.asset(
                  currentSlide.pathImage,
                  width: 200.0,
                  height: 200.0,
                  fit:BoxFit.contain,
                )
              ),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top:20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top:20.0),
              )
            ],
          ),
        )
        );
      }
    return tabs;
}



  @override
  Widget build(BuildContext context) {
    return new IntroSlider(slides: this.slides,
    renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33ffcc5c),
      highlightColorSkipBtn: Color(0xffffcc5c),

      renderNextBtn: this.renderNextBtn(),

      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33ffcc5c),
      highlightColorDoneBtn: Color(0xffffcc5c),

      colorDot:Color(0x33ffcc5c),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc){
      this.goToTab =refFunc;
      },

      shouldHideStatusBar: true,

      onTabChangeCompleted: this.onTabChangeCompleted,



    );
  }
}

Slide GenerateSlide(String title,String description,String image){
  return new Slide(
    title:title,
    styleTitle: TextStyle(
        color: Color(0xff3da4ab),
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        fontFamily: "RobotMono"),
    description:description,
    styleDescription:TextStyle(
        color: Color(0xfffe9c8f),
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        fontFamily: "Raleway"),
    pathImage: "assets/images/${image}",
  );
}