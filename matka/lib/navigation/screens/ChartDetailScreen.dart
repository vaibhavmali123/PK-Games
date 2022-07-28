import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matka/modal/LoginModal.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/navigation/widget/EditingController.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'GameTicketDetailScreen.dart';
import 'OtpScreen.dart';

class ChartDetailScreen extends StatefulWidget {
  Map<String, dynamic> data;

  ChartDetailScreen(this.data);

  @override
  _ChartDetailScreenState createState() => _ChartDetailScreenState();
}

class _ChartDetailScreenState extends State<ChartDetailScreen> {
  List<dynamic> lstWin = List<dynamic>();

  @override
  void initState() {
    super.initState();
    callService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CU.getAppbar(widget.data[CS.gamename] ?? "Detail"),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.blue, Colors.black])),
        child: ListView(
          children: [
            if (lstWin != null && lstWin.length > 0) getTable(),
            CU.getContactDesign(),
          ],
        ),
      ),
    );
  }

  getNote() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "Note :- Ticket can be cancelled only before 15 mins prior to result timing.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  getTable() {
    return Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black),color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
//              Row(children: [
//                getCell("Date", 2),
//                getCell("Mon", 1),
//                getCell("Tus", 1),
//                getCell("Wen", 1),
//                getCell("Ths", 1),
//                getCell("Fri", 1),
//                getCell("Sat", 1),
//                getCell("Sun", 1),
//              ]),
//              Container(
//                color: Colors.white,
//                height: 1,
//                width: double.infinity,
//              ),
              for (int i = 0; lstWin != null && i < lstWin.length; i += 7)
                Column(
                  children: [
                    Row(children: [
                      getCell(
                          lstWin[i][CS.resultdate] +
                              "\nTo\n" +
                              lstWin[(i + 7) > lstWin.length ? lstWin.length - 1 : (i + 6)][CS.resultdate],
                          2),
                      Container(
                        height: 50,
                        color: Colors.black,
                        width: 1,
                      ),
                      getWin(lstWin[i][CS.result], 1),
                      if ((i + 1) < lstWin.length) getWin(lstWin[i + 1][CS.result], 1) else getWin("", 1),
                      if ((i + 2) < lstWin.length) getWin(lstWin[i + 2][CS.result], 1) else getWin("", 1),
                      if ((i + 3) < lstWin.length) getWin(lstWin[i + 3][CS.result], 1) else getWin("", 1),
                      if ((i + 4) < lstWin.length) getWin(lstWin[i + 4][CS.result], 1) else getWin("", 1),
                      if ((i + 5) < lstWin.length) getWin(lstWin[i + 5][CS.result], 1) else getWin("", 1),
                      if ((i + 6) < lstWin.length) getWin(lstWin[i + 6][CS.result], 1) else getWin("", 1),
                    ]),
                    Container(
                      color: Colors.black,
                      height: 1,
                      width: double.infinity,
                    ),
                  ],
                ),
            ],
          ),
        ));
  }

  getWin(text, flex, {isTicket = false, data}) {
    if (text.toString().length == 4)
      text += "####";
    else if (text.toString().length == 8)
      text += "";
    else
      text = "########";

    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text[0] + "\n" + text[1] + "\n" + text[2],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              height: 40,
              color: Colors.black,
              width: 1,
            ),
            Text(
              text[3] + text[4],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              height: 40,
              color: Colors.black,
              width: 1,
            ),
            Text(
              text[5] + "\n" + text[6] + "\n" + text[7],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.only(left: 2),
              height: 50,
              color: Colors.black,
              width: 1,
            ),
          ],
        ),
      ),
    );
  }

  getCell(text, flex, {isTicket = false, data}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> callService() async {
    Map<String, dynamic> body = <String, dynamic>{
//      CS.token: await CU.getToken(),
    };
    Map<String, dynamic> resJson;
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body, apiUrl: CS.lstgameresultlist + widget.data[CS.gameid].toString(), isShowPogressDilog: true);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      lstWin = resJson[CS.lstgameresultlistdata];
      setState(() {});
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }
}
