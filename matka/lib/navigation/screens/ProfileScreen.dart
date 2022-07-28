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

class ProfileScreen extends StatefulWidget {
  bool isFragment = false;

  ProfileScreen();

  ProfileScreen.bottom() {
    isFragment = true;
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LoginModal loginModal;
  EditingController nameController = EditingController();
  EditingController emailController = EditingController();
  EditingController mobileController = EditingController();

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isFragment ? null : CU.getAppbar("Profile", isCenter: true, isShowRightSide: false),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: mobileController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mobile No',
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Save'),
                      onPressed: () {
                        callService();
                      },
                    )),
                if (!widget.isFragment)
                  Container(
                      child: Row(
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text(
                          'Skip',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          //signup screen
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ))
              ],
            )));
  }

  setData() async {
    loginModal = LoginModal.fromJson(await CU.getUserInfo());
    nameController.text = loginModal.clientname ?? "";
    emailController.text = loginModal.email ?? "";
    mobileController.text = loginModal.mobileno ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    nameController.clear();
    emailController.clear();
    mobileController.clear();
  }

  Future<void> callService() async {
    loginModal.email = emailController.text;
    loginModal.clientname = nameController.text;
    Map<String, dynamic> body = <String, dynamic>{
      CS.clientdata: jsonEncode(loginModal.toJson()),
    };
    Map<String, dynamic> resJson;
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context, body: body, apiUrl: CS.profileSave);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      SharedPreferences prefs=await SharedPreferences.getInstance();
      prefs.setString("profile", jsonEncode(body));
      print("++++Body"+jsonEncode(body));
      print("++++Body D"+jsonEncode(prefs.getString("profile")));
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }
}
