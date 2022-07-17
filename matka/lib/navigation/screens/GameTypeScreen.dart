import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matka/navigation/screens/GameDetailScreen.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';

class GameTypeScreen extends StatefulWidget {
  Map<String, dynamic> data;
  bool available;
  GameTypeScreen(this.data,{bool this.available});

  @override
  _GameTypeScreenState createState() => _GameTypeScreenState(available: available);
}

class _GameTypeScreenState extends State<GameTypeScreen> {
  double width = 100;
  bool available;

  _GameTypeScreenState({bool this.available});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) {
//      txtMobile.text = "9909906512";
//      txtMobile.text = "9925155594";
//      txtPassword.text = "123456";
    }
    return new Scaffold(
        appBar: CU.getAppbar("Game Type"),
        backgroundColor: Colors.white,
//        resizeToAvoidBottomInset: true,
          body: Container(
            decoration:
                BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.blue, Colors.black])),
            child: ListView(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    getGameTypeCell(image: "assets/singledigit.png", title: "Single Digit", type: 1),
                    getGameTypeCell(image: "assets/jodidigit.png", title: "Jodi Digit", type: 2),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    getGameTypeCell(image: "assets/singlepana.png", title: "Single Pana", type: 3),
                    getGameTypeCell(image: "assets/doublepana.png", title: "Double Pana", type: 4),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    getGameTypeCell(image: "assets/triplepana.png", title: "Triple Pana", type: 5),
                    getGameTypeCell(image: "assets/halfsangam.png", title: "Half Sangam", type: 6),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    getGameTypeCell(image: "assets/halfsangam2.jpeg", title: "Half Sangam 2", type: 8),
                    getGameTypeCell(image: "assets/fullsangam.png", title: "Full Sangam", type: 7),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              CU.getContactDesign(),
            ],
          ),
        ));
  }

  getGameTypeCell({title = "", image: "assets/logo.png", type: 1}) {
    return InkWell(
      onTap: () {
        var Cell = <String, dynamic>{CS.title: title, CS.type: type, CS.gameid: widget.data[CS.gameid]};
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GameDetailScreen(Cell,available:available,type: type,)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: width,
        alignment: Alignment.center,
        width: width,
        color: Colors.green,
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}
