import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matka/util/CU.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  String Title = "";
  String Url = 'https://flutter.dev';

  WebViewPage(Title, this.Url) {
    this.Title = CU.IsEmptyOrNull(Title) ? "Web Page" : Title;

    log("++++++++++++++++++++++++++++++++++++++++++++");
    log(Title);
    log(Url);
    log("++++++++++++++++++++++++++++++++++++++++++++");
  }

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  num _stackToView = 1;
  final _key = UniqueKey();

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CU.getAppbar(widget.Title),
        body: IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: <Widget>[
                Expanded(
                    child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget.Url,
                  onPageFinished: _handleLoad,
                )),
              ],
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: CU.getCircularProgressIndicator(),
              ),
            ),
          ],
        ));
  }
}
