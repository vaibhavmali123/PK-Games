import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';

class GameTicketDetailScreen extends StatefulWidget {
  Map<String, dynamic> data;

  GameTicketDetailScreen(this.data);

  @override
  _GameTicketDetailScreenState createState() => _GameTicketDetailScreenState(data: data);
}

class _GameTicketDetailScreenState extends State<GameTicketDetailScreen> {
  List<dynamic> lstItem;
  Map<String, dynamic> data;

  _GameTicketDetailScreenState({this.data});

  @override
  void initState() {
    super.initState();
    print("AMT ${data.toString()}");
    callService();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.data.toString());
    return Scaffold(
      appBar: CU.getAppbar(
        "View Ticket",
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.blue, Colors.black])),
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
              margin: EdgeInsets.all(4),
              child: Text(
                "Ticket No." + widget.data[CS.ticketid].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: Text(
                widget.data[CS.gamename].toString() + " ( " + widget.data[CS.openclose].toString() + " )",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: Text(
                widget.data[CS.datetime].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            getTable(),
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
    log(widget.data.toString());
    double WinAmt = 0;
    for (int i = 0; lstItem != null && i < lstItem.length; i++) WinAmt += lstItem[i][CS.winningamount] ?? 0;
    return Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(children: [
                getCell("Number", 1),
                getCell("Number2", 1),
                getCell("Amt", 2),
//                getCell("Bat Total", 2),
                getCell("Win", 2),
              ]),
              Container(
                color: Colors.white,
                height: 1,
                width: double.infinity,
              ),
              for (int i = 0; lstItem != null && i < lstItem.length; i++)
                Column(
                  children: [
                    Row(children: [
                      getCell(CU.IsEmptyOrNull(lstItem[i][CS.number].toString()) ? "-" : lstItem[i][CS.number].toString(), 1),
                      getCell(CU.IsEmptyOrNull(lstItem[i][CS.number2].toString()) ? "-" : lstItem[i][CS.number2].toString(), 1),
                      getCell(CU.IsEmptyOrNull(data['purchaseamount'].toString()) ? "-" : data['purchaseamount'].toString() ?? "", 2),
                      getCell(lstItem[i][CS.winningamount] ?? "", 2),
                    ]),
                    Container(
                      color: Colors.white,
                      height: 1,
                      width: double.infinity,
                    ),
                  ],
                ),
              Row(children: [
                getCell("Total (pts.)", 2),
                getCell(widget.data[CS.amount].toString(), 2),
//                getCell("Bat Total", 2),
                getCell(WinAmt.toString(), 2),
              ]),
            ],
          ),
        ));
  }

  getCell(text, flex, {isTicket = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: isTicket
            ? Column(
          children: [
            /*Container(
                      margin: EdgeInsets.only(bottom: 4),
                      height: 20,
                      child:
                      OutlineButton(
                          onPressed: () {},
                          child: Text(
                            "View",
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ))),*/
            Container(
                height: 20,
                child: OutlineButton(
                    onPressed: () {},
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ))),
          ],
        )
            : Text(
          text.toString(),
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
      resJson = await ApiClient.Call(context, body: body, apiUrl: CS.lstpurchaseitemlist + widget.data[CS.purchaseid].toString());
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      lstItem = resJson[CS.lstpurchaseitemlistdata];
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
