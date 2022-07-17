import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matka/modal/LoginModal.dart';
import 'package:matka/navigation/screens/LoginScreen.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/navigation/screens/SplashScreen.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CS.dart';

class CU {
  static final String iOSAppId = "";
  static String email = "social@gmail.com";
  static ProgressDialog progress_dialog;
  static String MobileNo = "";

//  static String MobileNo = "";
  static String DateFormate = 'dd-MM-yyyy';
  static String SeverFormate = 'yyyy-MM-dd';
  static String DefaultToken = "52AKs05yGEUjRmck7syo9AQmkdrzfIYigogpyJthG6A=";
  static Color primaryColor = Colors.brown;
  static Color secondaryColor = Color(0xFF3f98d3);
  static Color greenColor = Color(0xFF8eba49);
  static Color redColor = Color(0xFFe52726);
  static Color heliotropeColor = Color(0xFFb668f3);
  static Color yellowlightColor = Color(0xFFbab233);
  static Color textColorDark = Color(0xFF2a3338);
  static Color textColor = Color(0xFF65665a);
  static Color textColorlight = Color(0xFF9f9f9f);
  static Color textColorhint = Color(0xFFdddddd);
  static Color errorColor = Color(0xFFd84747);
  static List<Color> primaryGradientColor = [primaryColor, secondaryColor];
  static List<Color> AbsentGradientColor = [Color(0xFFf64a78), Color(0xFFff6ea6)];
  static List<Color> PresentGradientColor = [Color(0xFF28c8a8), Color(0xFF36de98)];
  static List<Color> HolidayGradientColor = [Color(0xFFfaa367), Color(0xFFf3bc64)];
  static List<Color> NAGradientColor = [Colors.blueGrey, Colors.grey];

  static showProgressDialog(BuildContext context) async {
    progress_dialog = new ProgressDialog(context);
    progress_dialog.style(
        message: 'Please Wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CU.getCircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    await progress_dialog.show();
  }

  static hideProgressDialog(context) async {
    log("hideProgressDialog()");
//    if (progress_dialog != null && progress_dialog.isShowing()){
    if (progress_dialog != null && progress_dialog.isShowing()) {
      Navigator.of(context).pop();
      progress_dialog = null;
      log("hideProgressDialog() =>");
//      progress_dialog.hide().whenComplete(() {
//        log("hideProgressDialog() => " +
//            progress_dialog.isShowing().toString());
//      });
    }
  }

  static Future<bool> CheckInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return (result.isNotEmpty && result[0] != null && result[0].rawAddress != null && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }

  static showNoInternetDiloag(BuildContext context, body) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Image.asset(
                                "assets/no_internet.png",
                                height: 120,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "No Internet Connection",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8, bottom: 24, left: 20, right: 20),
                            alignment: Alignment.center,
                            child: Text(
                              CS.NoInernetError,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: CU.textColorlight, fontSize: 12),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  color: CU.secondaryColor,
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        body();
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                                          child: Text(CS.RETRY,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                              )))))
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }

  static showMaintenanceDiloag(BuildContext context, Message, body) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
              elevation: 0.0,
              backgroundColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Image.asset(
                                  "assets/warning.png",
                                  height: 120,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Maintenance",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8, bottom: 24),
                              alignment: Alignment.center,
                              child: Text(
                                Message,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: CU.textColorlight, fontSize: 12),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    color: CU.secondaryColor,
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          body();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                                            child: Text(CS.RETRY,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0,
                                                )))))
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ));
        });
  }

  static showToast(BuildContext context, message, {backgroundColor = Colors.red}) {
    return Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: backgroundColor, textColor: Colors.white, fontSize: 16.0);
  }

  static showDiloag(BuildContext context, message) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Image.asset(
                          "assets/warning.png",
                          height: 120,
                        ),
                      ),
                    ),
//                    Container(
//                      alignment: Alignment.center,
//                      padding: const EdgeInsets.only(top: 8),
//                      child: Text(
//                        "Maintenance",
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, fontSize: 16),
//                      ),
//                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8, bottom: 24),
                      alignment: Alignment.center,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: CU.textColor, fontSize: 12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            color: CU.secondaryColor,
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
//                                  body();
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                    child: Text(CS.cancel,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                        )))))
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  static showUpdateDiloag(BuildContext context, updateVersionText, isComplusory) async {
    if (!kReleaseMode) {
      isComplusory = "0";
    }
    await showDialog(
        barrierDismissible: isComplusory == "0",
        context: context,
        builder: (context) {
          return WillPopScope(
              onWillPop: () {
                if (isComplusory == "1") {
                  SystemNavigator.pop();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                insetPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), image: DecorationImage(image: AssetImage("assets/update.png"))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0, top: 120, right: 16.0, bottom: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    "What's New",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8, bottom: 36),
                                  alignment: Alignment.center,
                                  child: Text(
                                    updateVersionText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: CU.textColorlight, fontSize: 12),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Material(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        color: CU.secondaryColor,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                            onTap: () async {
                                              PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                              StoreRedirect.redirect(androidAppId: packageInfo.packageName, iOSAppId: CU.iOSAppId);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                                                child: Text(CS.Update,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14.0,
                                                    )))))
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ));
        });
  }

  static showAuthenticationFail(BuildContext context, message) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.grey[800],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 15.0),
                    blurRadius: 15.0,
                  ),
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, -10.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        "assets/logo.png",
                        height: 100,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        message,
                        style: TextStyle(color: CU.primaryColor, fontSize: 14),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                              width: 200,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: CU.primaryGradientColor),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(.3),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0,
                                  )
                                ],
                              ),
                              child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        logout(context);
                                      },
                                      child: Center(
                                          child: Text('OK',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.0,
                                              )))))),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  static Widget loadImageWithLoadingProgressHight(url, height) {
    return Container(
      color: Colors.transparent,
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        fit: BoxFit.fill,
        placeholder: (context, url) => CU.getCircularProgressIndicator(),
        errorWidget: (context, url, error) => CU.getCircularProgressIndicator(),
      ),
    );
  }

  static Widget loadImage({@required url, height, isShowLoader = false, color}) {
    return Container(
      color: Colors.transparent,
      child: CachedNetworkImage(
          imageUrl: url,
          height: height,
          fit: BoxFit.fill,
          color: color,
          placeholder: (context, url) {
            if (isShowLoader) CU.getCircularProgressIndicator();
          },
          errorWidget: (context, url, error) => Image.asset(
                "assets/warning.png",
                height: height,
                fit: BoxFit.fill,
              )),
    );
  }

  static void logout(context) {
    CU.setUserInfo("");
    CU.setToken("");
    CU.setHomeData("");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (Route<dynamic> route) => false);
  }

  static Widget getCircularProgressIndicator() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
            ],
          ),
        ));
  }

  static Widget getAppbar(String Title, {List<Widget> actions, isCenter = false, bool isShowRightSide = true}) {
    if (isShowRightSide &&MainScreenState.userInfo!=null) {
      if (actions == null) actions = List<Widget>();
      LoginModal loginModal;

      if(MainScreenState.userInfo!=null){
        LoginModal.fromJson(MainScreenState.userInfo);
      }
      if(loginModal!=null){
        actions.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    launchURL("whatsapp://send?phone=91" + MobileNo + "&text=hi, Play matka with us.");
                  },
                  icon: Image.asset(
                    "assets/whatsapp.png",
                    color: Colors.white,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome '" + loginModal.clientname!=null?loginModal.clientname.toString():"" + "'",
                      style: new TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    /*Text(
                      "Points : " + MainScreenState.resJson["walletamount"].toString(),
                      style: new TextStyle(color: Colors.white, fontSize: 10),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
        );
      }

    }
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      brightness: Brightness.dark,
//      gradient: LinearGradient(colors: primaryGradientColor),
      centerTitle: isCenter,
      title:Title=="Profile"?Text(
        "Profile ",
        style: new TextStyle(color: Colors.white, fontSize: 17),
      ):MainScreenState.resJson["walletamount"]!=null?Row(children: [Expanded(flex:3,child:Text(
          Title,
          style: new TextStyle(color: Colors.white)),
      ),Expanded(flex:2,child: Text(
        "Points : " + MainScreenState.resJson["walletamount"].toString(),
        style: new TextStyle(color: Colors.white, fontSize: 10),
      ),)],):CircularProgressIndicator(), /*new Text(
        Title,
        style: new TextStyle(color: Colors.white),
      ),*/
    );
  }

  static void launchURL(url) async {
    log(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void openEmailInquiryApp() {
    openEmailApp(email, "Matka Master Inquiry", "");
  }

  static void openEmailFeedBackApp() {
    openEmailApp(email, "Feed Back", "");
  }

  static Future<void> ShareImageNText(String ShareUrl, String ShareText) async {
    var request = await HttpClient().getUrl(Uri.parse(ShareUrl));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file('Share', 'amlog.jpg', bytes, 'image/*', text: ShareText);
  }

  static void ShareText(String ShareText) {
    Share.text('Text', ShareText, 'text/plain');
  }

  static void openEmailApp(email, subject, body) {
    launchURL("mailto:$email?subject=$subject&body=$body");
  }

  static Widget getRateDialogue(BuildContext context, String Url) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.grey[800],
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black54,
            height: 175,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // To make the card compact
              children: <Widget>[
                Padding(
                  child: Text(
                    "Rate This App",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                ),
                Center(
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => CU.launchURL(Url),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: new Image.asset(
                              "build/flutter_assets/packages/cupertino_icons/assets/ic_happy.png",
                              width: 75,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => CU.openEmailFeedBackApp(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: new Image.asset(
                              "build/flutter_assets/packages/cupertino_icons/assets/ic_sad.png",
                              width: 75,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void setHomeData(Data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('HomeData', Data);
  }

  static Future<Map<String, dynamic>> getHomeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('HomeData'));
  }

  static bool IsEmptyOrNull(String str) {
    return str == null || str.isEmpty || str == "null";
  }

  static bool IsLogin({context, bool action = false}) {
    bool isLogin = !(MainScreenState.userInfo == null || CU.IsEmptyOrNull(MainScreenState.userInfo[k_clientid].toString()));
    if (!isLogin && action) Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    return isLogin;
  }

  static Future<Map<String, dynamic>> getDeviceState() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo data = await deviceInfoPlugin.androidInfo;
        return await <String, dynamic>{
          CS.deviceId: data.id,
          CS.deviceName: data.model,
          CS.deviceVersion: data.version.sdkInt.toString(),
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        return <String, dynamic>{
          CS.deviceId: data.identifierForVendor,
          CS.deviceName: data.model,
          CS.deviceVersion: data.systemVersion,
        };
      }
    } on PlatformException {
      return <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }
  }

  static void setToken(Data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Token', Data);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Token = prefs.getString('Token');
    return CU.IsEmptyOrNull(Token) ? DefaultToken : Token;
  }

  static void setContact(Data) async {
    MobileNo = Data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Contact', Data);
  }

  static Future<String> getContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Contact = prefs.getString('Contact');
    return CU.IsEmptyOrNull(Contact) ? "9999999999" : Contact;
  }

  static void setUsersInfo(Data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('UsersInfo', Data);
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUserInfo = prefs.getString('UserInfo');
    return CU.IsEmptyOrNull(strUserInfo) ? null : jsonDecode(strUserInfo);
  }

  static Future<List<dynamic>> getUsersInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUserInfo = prefs.getString('UsersInfo');
    return CU.IsEmptyOrNull(strUserInfo) ? null : jsonDecode(strUserInfo);
  }

  static void setUserInfo(Data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserInfo', Data);
  }

  static bool IsValidateEmail(String value) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" + "\\@" + "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" + "(" + "\\." + "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" + ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static bool IsImage(String Url) {
    if (IsEmptyOrNull(Url)) return false;
    String ex = CU.getFileExtensionOfURL(Url).toLowerCase();
    return ex == "jpg" || ex == "png" || ex == "jepg";
  }

  static String getFileNameOfURL(String Url) {
    return Url.substring(Url.lastIndexOf("/") + 1);
  }

  static String getFileExtensionOfURL(String Url) {
    return Url.substring(Url.lastIndexOf(".") + 1);
  }

  static Widget getContactDesign() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                CS.AppNmae,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            Text(
              MobileNo,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      launchURL("tel:" + MobileNo);
                    },
                    icon: Container(
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      launchURL("whatsapp://send?phone=91" + MobileNo + "&text=hi");
                    },
                    icon: Image.asset(
                      "assets/whatsapp.png",height: 22,
                      color: Colors.green,
                    )/*Icon(
                      Icons.whatshot,
                      color: Colors.white,
                    )*/,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
