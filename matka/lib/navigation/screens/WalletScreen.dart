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
import 'package:shared_preferences/shared_preferences.dart';

import 'OtpScreen.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  EditingController amountController = EditingController();
  Map<String, dynamic> resJson;

  @override
  void initState() {
    super.initState();
    callService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Container(
          decoration:
              BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.blue, Colors.black])),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.all(12),
                child: Image.asset(
                  'assets/logo.png',
                  height: 150,
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                child: TextField(
                  readOnly: true,
                  enabled: false,
                  style: TextStyle(color: Colors.white),
                  controller: amountController,
                  decoration: InputDecoration(
                    disabledBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintStyle: TextStyle(
                      color: CU.textColorhint,
                    ),
                    prefixIcon: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                    ),
                    labelText: "Available Funds",
                  ),
                ),
              ),
              Container(
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('Add Funds'),
                    onPressed: () {
                      MainScreenState.onSelectRedirectScreen(context: context, Screen: "BalanceListScreen");
                    },
                  )),
              CU.getContactDesign(),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> callService() async {
    /*Map<String, dynamic> body = <String, dynamic>{
      CS.token: await CU.getToken(),
    };*/
   /* if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body, apiUrl: CS.walletAmount + MainScreenState.userInfo[k_clientid].toString(), callMethod: CallMethod.Get);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      MainScreenState.userInfo[k_Walletamount] = resJson[k_walletamount];
      log("++++++++++++++++++++++++++++++++++++");
      log(MainScreenState.userInfo.toString());
      log("++++++++++++++++++++++++++++++++++++");
      CU.setUserInfo(jsonEncode(MainScreenState.userInfo));
      setState(() {});
//      CU.showToast(context, resJson[CS.message], backgroundColor: Colors.green);
//      Navigator.of(context).pop();
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }*/
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var mno=prefs.getString("mno");
    Map<String, dynamic> body = <String, dynamic>{};

    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context, body: body, apiUrl: CS.homeScreen+mno, isShowPogressDilog: true, callMethod: CallMethod.Get);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }

    if (resJson[CS.status].toString() == StatusCode.Success) {
      log(resJson.toString());
      amountController.text=resJson["walletamount"].toString();
      setState(() {});
    }
    else if (resJson[CS.status].toString() == StatusCode.Error) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CU.showDiloag(context, resJson[CS.message]);
          });
    }

}}
