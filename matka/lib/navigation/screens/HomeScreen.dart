import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matka/navigation/screens/GameTypeScreen.dart';
import 'package:matka/navigation/widget/CarouselSlider.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'MainScreen.dart';

class HomeScreen extends StatefulWidget {
  List<dynamic> homeData;

  Map<String, dynamic> userInfo;

  HomeScreen(this.homeData, this.userInfo);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<dynamic> courselist = new List<dynamic>();
  int page = 0;
  int totalPages;
  final ScrollController controller = ScrollController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  DateFormat dateFormat=DateFormat("dd-MM-yyyy hh:mm:ss");

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch
    await callService();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.homeData == null
          ? Container()
          : SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: widget.homeData.length + 2,
                itemBuilder: (contex, i) {
                  if (i == 0)
                    return getTagline();
                  else if (i == 1)
                    return getContact();
                  else
                    return getHomeSlide1(widget.homeData[i - 2]);
                },
              ),
            ),
    );
  }

  List<Widget> getHomeList(Map<String, dynamic> data) {
    switch (data[CS.menu_type]) {
      case "Banner":
        return getHomeSlide(data);
        break;
      default:
        return <Widget>[];
        break;
    }
  }

  List<Widget> getHomeSlide(Map<String, dynamic> data) {
    log(data.toString());
    List<dynamic> categoryList = List<dynamic>();
    categoryList.add(data);
    double aspectRatio = 3;
    try {
      aspectRatio = double.tryParse(data[CS.aspectRatio]);
    } catch (e) {
      aspectRatio = 3; // 16 / 9
    }
    return <Widget>[
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                children: <Widget>[
                  CarouselSlider(
                    items: map<Widget>(
                      categoryList,
                      (index, i) {
                        return InkWell(
                          onTap: () {
                            MainScreenState.onSelectRedirectScreen(setState: setState, context: context, Screen: i[CS.screen_name], data: i);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CU.loadImage(url: i[CS.main_title_background_image], isShowLoader: true),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    aspectRatio: aspectRatio,
                    autoPlay: false,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlayInterval: Duration(seconds: 0),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: Duration(seconds: 0),
                    onPageChanged: (index) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
  }

  Widget getTagline() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          /*Text(
            "!!" + CS.AppNmae + "!!",
            style: TextStyle(color: CU.primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
          )*/Image.asset("assets/appbaricon.png",height:70,width:70),
          Text(
            "!!" + CS.AppNmae + "!!",
            style: TextStyle(color: CU.primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            "play online earn online".toUpperCase(),
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget getContact() {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  CU.launchURL("tel:" + CU.MobileNo);
                },
                icon: Container(
                  child: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                ),
              ),
              Text(
                CU.MobileNo,
                style: TextStyle(color: CU.primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () {
                  CU.launchURL("whatsapp://send?phone=91" + CU.MobileNo + "&text=hi, Play matka with us.");
                },
                icon: Image.asset(
                  "assets/whatsapp.png",
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 4,
            color: Colors.black45,
          ),
        ],
      ),
    );
  }

  Widget getHomeSlide1(Cell) {
    log("getHomeSlide " + Cell.toString());
    return InkWell(
      onTap: () {
        bool available;
        DateTime openTime=DateTime.parse(dateFormat.parse(Cell["opentimeValue"].toString(),false).toString());
        DateTime closeTime=DateTime.parse(dateFormat.parse(Cell["closetimeValue"].toString(),false).toString());
        DateTime dateTimeNow=DateTime.now();

        log("DATE opentimeValue"+Cell["opentimeValue"].toString());
        log("DATE closetimeValue"+Cell["closetimeValue"].toString());

        if(dateTimeNow.isAfter(closeTime)|| dateTimeNow.isBefore(openTime)){
          setState(() {
            available=false;

          });
        }
        else{
          setState(() {
            available=true;

          });
        }

        Navigator.push(context
         , MaterialPageRoute(builder: (BuildContext context) => GameTypeScreen(Cell,available: available,)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,

            child: Row(
              children: [
                Expanded(
                  child:
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child:Container(
                            color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Cell[CS.gamename] ?? "",
                                //textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.brown, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                "OPEN -" + Cell[CS.opentime] ,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "CLOSE -" + Cell[CS.closetime],
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),

                            Text(
                              getReult(Cell[CS.lastgameresult] ?? ""),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                      Expanded(
                        flex: 1,
                        child:
                        LayoutBuilder(
                          builder: (BuildContext context,BoxConstraints constraints){
                            bool available;
                            DateTime openTime=DateTime.parse(dateFormat.parse(Cell["opentimeValue"].toString(),false).toString());
                            DateTime closeTime=DateTime.parse(dateFormat.parse(Cell["closetimeValue"].toString(),false).toString());

                            // DateTime openTime=DateTime.parse("2022-07-16 21:16:00");
                            //DateTime closeTime=DateTime.parse("2022-07-17 13:02:00");

                            DateTime dateTimeNow=DateTime.now();
                            if(dateTimeNow.isAfter(closeTime.subtract(Duration(minutes: 30)))){
                              available=false;
                            }
                            else{
                              available=true;
                            }
                            return CircleAvatar(
                              radius: 34,
                              backgroundColor:Colors.grey,
                              child:
                              Container(
                                child:CircleAvatar(
                                  radius: 30,
                                  backgroundColor: !available?Colors.red:Colors.green,
                                  child:Center(
                                    child:Container(
                                      margin:EdgeInsets.only(left: 14),
                                      child:Text("Play Now"),
                                    ),
                                  ),
                                ),
                              ),
                            );
                        },
                        ),
                      ),

                    ],
                  ),
                ),
//                Container(
//                  padding: EdgeInsets.all(12),
//                  child: Image.asset(
//                    "assets/logo.png",
//                    height: 60,
//                  ),
//                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  String getReult(str) {
    if (CU.IsEmptyOrNull(str)) return "###-##-###";
    if (str.toString().length == 4) return str.toString().substring(0, 3) + "-" + str.toString()[3] + "#-###";
    if (str.toString().length == 8) return str.toString().substring(0, 3) + "-" + str.toString().substring(3, 5) + "-" + str.toString().substring(5);
    return str;
  }

  Future<void> callService() async {
    Map<String, dynamic> resJson;
    Map<String, dynamic> body = <String, dynamic>{};

    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context, body: body, apiUrl: CS.homeScreen, isShowPogressDilog: true, callMethod: CallMethod.Get);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }

    if (resJson[CS.status].toString() == StatusCode.Success) {
      widget.homeData = resJson[CS.lstgamedata];
      log(resJson.toString());
      setState(() {});
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CU.showDiloag(context, resJson[CS.message]);
          });
    }
  }
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}
