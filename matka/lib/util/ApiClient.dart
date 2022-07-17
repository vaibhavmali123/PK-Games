import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:matka/navigation/screens/MainScreen.dart';

import 'CS.dart';
import 'CU.dart';

class ApiClient {
  static Future<Map<String, dynamic>> Call(context, {@required apiUrl, body, isBack, isShowPogressDilog, callMethod}) async {
    if (isShowPogressDilog == null) isShowPogressDilog = true;
    if (isShowPogressDilog) await CU.showProgressDialog(context);
    print("++++++++API++++"+apiUrl+"++++"+callMethod.toString());
    if (isBack == null) isBack = false;
    if (callMethod == null) callMethod = CallMethod.Post;
    Dio dio = Dio();
//    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//        (HttpClient client) {
//      client.badCertificateCallback =
//          (X509Certificate cert, String host, int port) => true;
//      return client;
//    };
    log("+++++++++++++++++++++++++++++++++body+++++++++++++++++++++++++++++++++");
    log(body.toString());
    log(apiUrl);
    log("+++++++++++++++++++++++++++++++++body+++++++++++++++++++++++++++++++++");
    Response response;
//    try {
    if (callMethod == CallMethod.Post) {
      response = await dio.post(
        apiUrl,
        data: FormData.fromMap(body),
      );
    } else if (callMethod == CallMethod.Get) {
      response = await dio.get(apiUrl);
    }
//    } catch (e) {
//      log("+++++++++++++++++++++++++++++++++catch+++++++++++++++++++++++++++++++++");
//      log(e.toString());
//      if (isShowPogressDilog) await CU.hideProgressDialog(context);
//      await showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, CS.ConnectionErrror));
//      log("+++++++++++++++++++++++++++++++++catch+++++++++++++++++++++++++++++++++");
//      return Call(
//          context: context,
//          apiUrl: apiUrl,
//          body: body,
//          isBack: isBack,
//          isShowPogressDilog: isShowPogressDilog);
//    }
    if (isShowPogressDilog) CU.hideProgressDialog(context);

    log("+++++++++++++++++++++++++++++++response+++++++++++++++++++++++++++++++");
    log("statusCode => " + response.statusCode.toString());
    log("body => " + response.data.toString());
    log("+++++++++++++++++++++++++++++++response+++++++++++++++++++++++++++++++");
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> resjson = response.data.runtimeType == String ? jsonDecode(response.data) : response.data;
      if (resjson[CS.status] == "1" && !CU.IsEmptyOrNull(resjson[k_walletamount])) {
        if (MainScreenState.userInfo != null) MainScreenState.userInfo[k_Walletamount] = resjson[k_walletamount];
//        await CU.setToken(resjson[CS.token]);
      }
      if (resjson[CS.status].toString() == "2") {
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (contex) {
              return CU.showAuthenticationFail(context, CU.IsEmptyOrNull(resjson[CS.message]) ? "Authentication Fail" : resjson[CS.message]);
            });
      }
      return resjson;
    } else {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CU.showDiloag(context, CS.InternalServerError);
          });
//      Post(context, $body);
      return new Map<String, dynamic>();
    }
  }
}

enum CallMethod { Post, Get }
