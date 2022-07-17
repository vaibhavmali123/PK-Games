import 'dart:async';
import 'dart:developer';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:package_info/package_info.dart';

import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

Map<String, dynamic> resjson = <String, dynamic>{};
DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
PackageInfo packageInfo;

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Theme(
        data: new ThemeData(backgroundColor: Colors.green),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Align(
                child: Image.asset(
                  "assets/logo.jpeg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    IsloginUser();
  }

  Future<void> IsloginUser() async {
    var UserInfo = await CU.getUserInfo();
    log("+++++++++++++++++++++++++++++++++");
    log(UserInfo.toString());
    if ((UserInfo == null || CU.IsEmptyOrNull(UserInfo[k_clientid].toString()))) {
      callService();
    } else {
      CU.MobileNo = await CU.getContact();
      MainScreenState.userInfo = UserInfo;
      Future.delayed(Duration(seconds: 2), () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()))});
    }
    Future.delayed(Duration(seconds: 2), () => {callService()});
  }

  Future<void> callService() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String AppVersion = packageInfo.version;
//    Map<String, dynamic> deviceData = await CU.getDeviceState();
    Map<String, dynamic> body = <String, dynamic>{
//      CS.serviceName: CS.PlayScreen,
//      CS.token: CU.DefaultToken,
//      CS.deviceType: Platform.isAndroid ? "1" : "2",
//      CS.deviceId: deviceData[CS.deviceId],
//      CS.deviceVersion: deviceData[CS.deviceVersion],
//      CS.latitude: "0",
//      CS.longitude: "0",
//      CS.deviceToken: Token,
//      CS.deviceName: deviceData[CS.deviceName],
//      CS.appVersion: AppVersion,
    };

    Map<String, dynamic> resJson;
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context, body: body, apiUrl: CS.organizationDataSave, isShowPogressDilog: false, callMethod: CallMethod.Get);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      if (resJson[k_lstorganizationdata] != null && resJson[k_lstorganizationdata].length > 0) {
        await CU.setContact(resJson[k_lstorganizationdata][0][k_contactno]);
        log(await CU.getContact());
        Future.delayed(Duration(seconds: 2), () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()))});
      }
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CU.showDiloag(context, resJson[CS.message]);
          });
      return;
    }
  }
}
