// @dart=2.9

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:matka/util/CU.dart';

import 'navigation/screens/SplashScreen.dart';

//import 'package:Matka Master/util/CU.dart';
//import 'navigation/screens/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
//  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
    runApp(
      MyApp(),
    );
  }, onError: (dynamic error, dynamic stack) {
//    Crashlytics.instance.recordError;
    print(error);
    print(stack);
  });
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
//  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PK Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "GoogleSans-Regular",
        hintColor: CU.textColorhint,
//        cursorColor: CU.primaryColor,
        primaryColor: CU.primaryColor,
        textSelectionColor: CU.primaryColor,
        inputDecorationTheme: InputDecorationTheme(
//          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
//          enabledBorder: new OutlineInputBorder(
//            borderSide: BorderSide(color: CU.primaryColor, width: 1.0),
//          ),
////          border: OutlineInputBorder(
////            borderSide: BorderSide(color: CU.primaryColor, width: 1.0),
////          ),
////          focusedBorder: new OutlineInputBorder(
////            borderSide: BorderSide(color: CU.primaryColor, width: 1.0),
////          ),
//          enabledBorder: new OutlineInputBorder(
//            borderSide: BorderSide(color: Colors.white, width: 0),
//          ),
//          errorBorder: new OutlineInputBorder(
//            borderSide: BorderSide(color: Colors.white, width: 0),
//          ),
//          border: OutlineInputBorder(
//            borderSide: BorderSide(color: Colors.white, width: 0),
//          ),
//          focusedBorder: new OutlineInputBorder(
//            borderSide: BorderSide(color: Colors.white, width: 0),
//          ),
//          focusedErrorBorder: new OutlineInputBorder(
//            borderSide: BorderSide(color: Colors.white, width: 0),
//          ),
//          labelStyle: TextStyle(
//            color: Colors.grey,
//          ),
//          hintStyle: TextStyle(
//            color: CU.textColorhint,
//          ),

            ),
      ),
      builder: (context, child) {
        // double scale = (MediaQuery.of(context).size.height /
        // MediaQuery.of(context).size.width );
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: Platform.isAndroid ? 1.2 : 1.4),
        );
//          ScrollConfiguration(
//          behavior: MyScrollBehavior(),
//          child: child,
//        );
      },
      home: SplashScreen(),
//      navigatorObservers: [
//        FirebaseAnalyticsObserver(analytics: analytics),
//      ],
    );
  }
}
