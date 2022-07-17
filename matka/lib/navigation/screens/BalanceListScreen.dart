import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matka/modal/ClientWithdrawModal.dart';
import 'package:matka/modal/LoginModal.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/navigation/widget/EditingController.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'AddBalanceScreen.dart';
import 'OtpScreen.dart';
import 'WithdrowalScreen.dart';

class BalanceListScreen extends StatefulWidget {
  @override
  _BalanceListScreenState createState() => _BalanceListScreenState();
}

class _BalanceListScreenState extends State<BalanceListScreen> {
  List<dynamic> lstdata;
  Map<String, dynamic> resJson;

  @override
  void initState() {
    super.initState();
    callService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CU.getAppbar("Balance List"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = (await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddBalanceScreen()))) ?? false;
          if (res) callService();
        },
        child: Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
      body: lstdata == null
          ? CU.getCircularProgressIndicator()
          : lstdata.length == 0
              ? Container(
                  child: Center(child: Text(resJson[CS.message])),
                )
              : Container(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: lstdata.length,
                    itemBuilder: (BuildContext context, int i) {
                      return getlistDesign(lstdata[i]);
                    },
                  )),
    );
  }

  getlistDesign(item) {
    return Card(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset(
                item[CS.BankAccountName].toString().contains("Google Pay")
                    ? "assets/googlepay.png"
                    : item[CS.BankAccountName].toString().contains("Paytm") ? "assets/paytm.png" : "assets/phonepay.png",
                height: 60,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(item[CS.TransactionMobileNo], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text(item[CS.TransactionNumber].toString(), style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54, fontSize: 14)),
                Text("Amount : " + item[CS.Amount].toString(), style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              color: item[CS.ApproveStatus] == "Approve" ? Colors.green : item[CS.ApproveStatus] == "Pending" ? Colors.amber : Colors.red,
              child: Text(
                item[CS.ApproveStatus],
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
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
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body, apiUrl: CS.lstbalancelist + MainScreenState.userInfo[k_clientid].toString(), callMethod: CallMethod.Get);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      lstdata = resJson[CS.lstclientpaymentlistdata];
      setState(() {});
//      CU.showToast(context, resJson[CS.message], backgroundColor: Colors.green);
//      Navigator.of(context).pop();
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }
}
