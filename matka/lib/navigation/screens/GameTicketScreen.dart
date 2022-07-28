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

class GameTicketScreen extends StatefulWidget {
  @override
  _GameTicketScreenState createState() => _GameTicketScreenState();
}

class _GameTicketScreenState extends State<GameTicketScreen> {
  List<dynamic> lstTicket;

  @override
  void initState() {
    super.initState();
    callService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CU.getAppbar("View Ticket"),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.blue, Colors.black])),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Text(
                CS.AppNmae,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: Text(
                '* Game Rate *',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),
           // getNote(),
            getTable(),
            //getNote(),
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
        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(children: [
                getCell("S.No", 1),
                getCell("Ticket\nNo", 2),
                getCell("Date\nTime", 2),
                getCell("Name", 2),
                getCell("Amount", 2),
                getCell("Ticket", 2),
              ]),
              Container(
                color: Colors.white,
                height: 1,
                width: double.infinity,
              ),
              for (int i = 0; lstTicket != null && i < lstTicket.length; i++)
                Column(
                  children: [
                    Row(children: [
                      getCell((i + 1).toString(), 1),
                      getCell(lstTicket[i][CS.ticketid].toString(), 2),
                      getCell(lstTicket[i][CS.purchasedatetime], 2),
                      getCell(lstTicket[i][CS.gamename].toString() + "- " + lstTicket[i][CS.openclose].toString(), 2),
                      getCell(lstTicket[i]["purchaseamount"].toString(), 2),
                      getCell("", 2, isTicket: true, data: lstTicket[i]),
                    ]),
                    Container(
                      color: Colors.white,
                      height: 1,
                      width: double.infinity,
                    ),
                  ],
                ),
            ],
          ),
        ));
  }

  getCell(text, flex, {isTicket = false, data}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: isTicket
            ? Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 4),
                      height: 20,
                      child: OutlineButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) => GameTicketDetailScreen(data)));
                          },
                          child: Text(
                            "View",
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ))),
                  /*data[CS.isdeleteview] == 1
                      ? Container(
                          height: 20,
                          child: OutlineButton(
                              onPressed: () {
                                callDeleteService(data[CS.purchaseid]);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.white, fontSize: 8),
                              )))
                      : Container(),*/
                ],
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10),
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
          body: body,
          apiUrl: CS.lstpurchaselist + MainScreenState.userInfo[k_clientid].toString(),
          isShowPogressDilog: true);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      lstTicket = resJson[CS.lstpurchaselistdata];
      setState(() {});
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }

  Future<void> callDeleteService(purchaseId) async {
    Map<String, dynamic> body = <String, dynamic>{
      k_clientid: MainScreenState.userInfo[k_clientid],
//      CS.token: await CU.getToken(),
    };
    Map<String, dynamic> resJson;
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body, apiUrl: CS.lstpurchasedelete + purchaseId.toString(), isShowPogressDilog: true);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      callService();
      CU.showToast(context, resJson[CS.message]);
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }
}
