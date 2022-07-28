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

import 'OtpScreen.dart';

class GameRatesScreen extends StatefulWidget {
  @override
  _GameRatesScreenState createState() => _GameRatesScreenState();
}

class _GameRatesScreenState extends State<GameRatesScreen> {
  List<dynamic> lstGameRate = jsonDecode(strGameRate);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CU.getAppbar("Game Rates"),
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
                margin: EdgeInsets.all(8),
                child: Text(
                  '* Game Rate *',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), border: Border.all(width: 1, color: Colors.white)),
                child: Table(
                    border: TableBorder(
                        horizontalInside: BorderSide(width: 1, color: Colors.white), verticalInside: BorderSide(width: 1, color: Colors.white)),
                    children: lstGameRate.map((item) {
                      return TableRow(children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item[CS.GameType],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item[CS.GameRate], style: TextStyle(color: Colors.white)),
                        ),
                      ]);
                    }).toList()),
              ),
              CU.getContactDesign(),
            ],
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
      resJson = await ApiClient.Call(context, body: body, apiUrl: CS.profileSave);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }
}
