import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matka/navigation/screens/ChartDetailScreen.dart';
import 'package:matka/navigation/screens/GameTypeScreen.dart';
import 'package:matka/navigation/widget/CarouselSlider.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';

import 'MainScreen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChartScreen extends StatefulWidget {
  List<dynamic> homeData;

  Map<String, dynamic> userInfo;

  ChartScreen(this.homeData, this.userInfo);

  @override
  ChartScreenState createState() => ChartScreenState();
}

class ChartScreenState extends State<ChartScreen> {
  List<dynamic> courselist = new List<dynamic>();
  int page = 0;
  int totalPages;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CU.getAppbar("Chart"),
      body: widget.homeData == null
          ? Container()
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.homeData.length,
              itemBuilder: (contex, i) {
                return getHomeSlide(widget.homeData[i]);
              },
            ),
    );
  }

  Widget getHomeSlide(Cell) {
    log("getHomeSlide " + Cell.toString());
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChartDetailScreen(Cell)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        borderOnForeground: true,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                Cell[CS.gamename] ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.brown, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward_ios,color: Colors.grey,),
            ),
          ],
        ),
      ),
    );
  }
}
