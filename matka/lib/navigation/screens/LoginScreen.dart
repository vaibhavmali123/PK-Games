import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool IsCallChkMobile = false;
  bool IsPasswordScreen = false;
  bool passwordVisible = false;

//  EditingController txtUsename = new EditingController();
  EditingController txtPassword = new EditingController();
  EditingController txtMobile = new EditingController();

//  FirebaseMessaging fcm = new FirebaseMessaging();

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
        backgroundColor: Colors.white,
//        resizeToAvoidBottomInset: true,
        body: WillPopScope(
          onWillPop: () {
            FocusScope.of(context).unfocus();
            if (IsPasswordScreen) {
              IsPasswordScreen = false;
              setState(() {});
            } else
              SystemNavigator.pop();
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
//                  Container(
//                    height: 250,
//                    width: double.infinity,
//                    color: Colors.amber,
//                    child: Image.asset(
//                      'assets/logo.png',
//                      color: Colors.white,
//                    ),
//                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(bottom: 12, left: 16, right: 16),
                          child: TextField(
                            onChanged: (text) {
                              log(text);
                            },
                            controller: txtMobile,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: TextStyle(
                                height: 1.0,
                                fontWeight: FontWeight.bold,
                                color: CU.textColor,
                                fontSize: 22),
                            decoration: InputDecoration(
                              suffixIcon: IsCallChkMobile
                                  ? Container(
                                      padding: EdgeInsets.only(
                                          left: 16, bottom: 12, right: 12),
                                      child: CircularProgressIndicator(),
                                    )
                                  : null,
                              hintStyle: TextStyle(
                                  color: CU.textColorhint, fontSize: 16),
                              labelStyle: TextStyle(fontSize: 16),
                              labelText: 'Enter Mobile No',
                              hintText: 'Enter Mobile No',
                              errorText: txtMobile.error.text,
                              errorMaxLines: 10,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 36),
                          child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Material(
                              color: CU.secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                onTap: () {
                                  if (isMobilevalidated()) {
                                    callService();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 32),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => MainScreen()));
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(color: CU.secondaryColor),
                      ),
                    ),
                  ),
//                  Expanded(
//                    child: Row(
//                      children: [
//                        Expanded(
//                            child: Padding(
//                          padding: const EdgeInsets.all(12.0),
//                          child: Divider(),
//                        )),
//                        Text("or"),
//                        Expanded(
//                            child: Padding(
//                          padding: const EdgeInsets.all(12.0),
//                          child: Divider(),
//                        )),
//                      ],
//                    ),
//                  ),
//                  Expanded(
//                    child: Container(
//                      margin: EdgeInsets.only(left: 15, right: 15),
//                      child: Material(
//                        color: CU.secondaryColor,
//                        borderRadius: BorderRadius.circular(5),
//                        clipBehavior: Clip.hardEdge,
//                        child: InkWell(
//                          onTap: () {
//                            if (IsPasswordScreen) {
//                              if (isvalidated()) callPasswordService();
//                            } else
//                              MobileValidated(txtMobile.text);
//                          },
//                          child: Text(
//                            "Login",
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontWeight: FontWeight.w500,
//                              fontSize: 14.0,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> callService() async {
    Map<String, dynamic> body = <String, dynamic>{
//      CS.token: await CU.getToken(),
      CS.clientdata: LoginModal(mobileno: txtMobile.text).toJson().toString(),
    };
    Map<String, dynamic> resJson;
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context, body: body, apiUrl: CS.login);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      SharedPreferences prefs=await SharedPreferences.getInstance();
      prefs.setString("mno", txtMobile.text);

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Otp(loginModal: LoginModal.fromJson(resJson[CS.lstclientdata]),Mobile: txtMobile.text,)));
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }

  bool isMobilevalidated() {
    bool isvalid = true;
    txtMobile.error.text = null;

    if (CU.IsEmptyOrNull(txtMobile.text)) {
      txtMobile.error.text = "Please enter your mobile.";
      isvalid = false;
    }
    else if (txtMobile.text.length != 10) {
      txtMobile.error.text = "Please enter your valid mobile.";
      isvalid = false;
    }
    setState(() {});
    return isvalid;
  }
}
