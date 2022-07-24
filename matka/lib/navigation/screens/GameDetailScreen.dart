import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:matka/modal/PurchaseDataModal.dart';
import 'package:matka/navigation/screens/GameTicketScreen.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/navigation/widget/EditingController.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';

class GameDetailScreen extends StatefulWidget {
  List<dynamic> lstdata = List<dynamic>();
  bool available;
  Map<String, dynamic> data;
 dynamic type;
  GameDetailScreen(this.data,{bool this.available,this.type}) {
    log(data.toString());
    switch (data[CS.type]) {
      case 1:
        for (int i = 1; i < 10; i++) {
          lstdata.add(<String, dynamic>{
            CS.Number: i.toString(),
            CS.Value: EditingController(),
          });
        }
        lstdata.add(<String, dynamic>{
          CS.Number: "0",
          CS.Value: EditingController(),
        });
        break;
      case 2:
        for (int i = 1; i <= 10; i++) {
          if (i == 10) i = 0;
          for (int j = 1; j <= 10; j++) {
            if (j == 10) j = 0;
            lstdata.add(<String, dynamic>{
              CS.Number: i.toString() + j.toString(),
              CS.Value: EditingController(),
            });
            if (j == 0) break;
          }
          if (i == 0) break;
        }
        break;
      case 3:
        List<dynamic> lstSP = jsonDecode(strSP);
        log(lstSP.toString());
        lstdata.clear();
        int breakPoint = (lstSP.length / 10).toInt();
        for (int j = 0; j < breakPoint; j++) {
          log("j => " + j.toString());
          for (int i = j; i < lstSP.length; i += breakPoint) {
            log("i => " + i.toString());
            lstdata.add(<String, dynamic>{
              CS.Number: lstSP[i][CS.Number].toString(),
              CS.Value: EditingController(),
            });
          }
        }
        break;
      case 4:
        List<dynamic> lstSP = jsonDecode(strDP);
        log(lstSP.toString());
        lstdata.clear();
        int breakPoint = (lstSP.length / 10).toInt();
        for (int j = 0; j < breakPoint; j++) {
          log("j => " + j.toString());
          for (int i = j; i < lstSP.length; i += breakPoint) {
            log("i => " + i.toString());
            lstdata.add(<String, dynamic>{
              CS.Number: lstSP[i][CS.Number].toString(),
              CS.Value: EditingController(),
            });
          }
        }
        break;
      case 44:
        for (int i = 0; i < 10; i++) {
          for (int j = 0; j < 10; j++) {
            if (i != j)
              lstdata.add(<String, dynamic>{
                CS.Number: i.toString() + j.toString() + j.toString(),
                CS.Value: EditingController(),
              });
          }
        }
        break;
      case 5:
        List<dynamic> lstTPana = jsonDecode(strTPana);
        log(lstTPana.toString());
        for (int i = 0; i < lstTPana.length; i++) {
          lstdata.add(<String, dynamic>{
            CS.Number: lstTPana[i][CS.Number].toString(),
            CS.Value: EditingController(),
          });
        }
        break;
    }
    log(lstdata.length.toString());
  }

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState(available: available,type: type);
}
enum RadioValues{open,close}

class _GameDetailScreenState extends State<GameDetailScreen> {
  bool available;
  dynamic type;
  _GameDetailScreenState({this.available,this.type});
  double width = 100;
  List<String> items;
  String selectedItem = 'close';
  RadioValues valR=RadioValues.open;
  PurchaseDataModal purchaseDataModal;
  List<dynamic> lsteopenclosedata;
  EditingController SumController = EditingController();
  EditingController OpenController = EditingController();
  EditingController CloseController = EditingController();
  EditingController PointsController = EditingController();

  @override
  void initState() {
    super.initState();
    callServiceDrop();
    purchaseDataModal = PurchaseDataModal();
//    if (widget.data[CS.type] == 2 || widget.data[CS.type] == 6 || widget.data[CS.type] == 7)
//      items = <String>[widget.data[CS.title] + ' Close'];
//    else
//      items = <String>[widget.data[CS.title] + ' Open', widget.data[CS.title] + ' Close'];
  }

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) {}
    return Scaffold(
      appBar: CU.getAppbar(widget.data[CS.title]),
      backgroundColor: Colors.white,
//        resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.black])),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: Text(
                  CS.AppNmae,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Date :" + DateFormat("dd MMM yyyy").format(DateTime.now()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              items == null || items.length == 0
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(left: 0.0),
                      child:type!=2&&type!=6&&type!=7&&type!=8?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Open",style: TextStyle(color: Colors.white)),
                          Radio(
                            value: RadioValues.open,
                            groupValue: valR,
                            activeColor: Colors.white,
                            onChanged:(RadioValues value){
                              setState(() {
                                valR=value;
                                selectedItem=value.toString();
                              });
                            },
                          ),
                          Text("Close",style: TextStyle(color: Colors.white),),

                          Radio(
                            value: RadioValues.close,
                            groupValue: valR,
                            activeColor: Colors.white,
                            onChanged:(RadioValues value){
                              setState(() {
                                valR=value;
                                selectedItem=value.toString();
                              });
                            },
                          )
                        ],
                      ):Container()
                      /*DropdownButton<String>(
                        value: selectedItem,
                        focusColor: Colors.white,
                        onChanged: (String string) =>
                            setState(() => selectedItem = string),
                        selectedItemBuilder: (BuildContext context) {
                          return items.map<Widget>((String item) {
                            return Row(
                              children: [
                                Container(
                                  child: Text(
                                    item,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        hint: Text("Select Game"),
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text(
                              '$item',
                            ),
                            value: item,
                          );
                        }).toList(),
                        isDense: false,
                      )*/,
                    ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                color: Colors.brown,
                child: Text(
                  widget.data[CS.title],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: getGameType(widget.data[CS.type]),
              ),
              if (widget.data[CS.type] < 6)
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        "Total : ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 30,
                      padding: EdgeInsets.only(left: 4),
                      margin: EdgeInsets.fromLTRB(4, 12, 12, 12),
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: SumController,
                        readOnly: true,
                        enabled: true,
                        style: TextStyle(fontSize: 14),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: OutlineButton(
                      onPressed: () {
                        if(available==true){
                          if (selectedItem == 'Select Game Type') {
                            CU.showToast(context, "Please Select Game  Type");
                          } else if (CU.IsEmptyOrNull(SumController.text) &&
                              widget.data[CS.type] == 6 &&
                              widget.data[CS.type] == 7) {
                            CU.showToast(context, "Please Enter One Number");
                          } else
                            callService();
                        }
                        else{
                          CU.showToast(context, "Sorry Game Time Closed");

                        }
                      },
                      borderSide: BorderSide(color: Colors.white),
                      child: Text("Submit",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
              CU.getContactDesign(),
            ],
          ),
        ),
      ),
    );
  }

  getGameType(type) {
    switch (type) {
      case 1:
        return ListView.separated(
          shrinkWrap: true,
          itemCount: widget.lstdata.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  color: Colors.brown,
                  alignment: Alignment.center,
                  child: Text(
                    widget.lstdata[index][CS.Number],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: 100,
                  height: 30,
                  child: TextField(
                    controller: widget.lstdata[index][CS.Value],
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(fontSize: 14),
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                    ),
                    onChanged: (text) {
                      int Sum = 0;
                      Sum = 0;
                      for (int i = 0; i < widget.lstdata.length; i++) {
                        if (widget.lstdata[i][CS.Value].text.isNotEmpty)
                          Sum =
                              Sum + int.parse(widget.lstdata[i][CS.Value].text);
                      }
                      SumController.text = Sum.toString();
                    }, // Only
                  ),
                  margin: EdgeInsets.only(left: 12),
                  color: Colors.white,
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
        );
      case 2:
      case 3:
      case 4:
      case 5:
        return Column(
          children: [
            Center(
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 10,
                childAspectRatio: 0.5,
                children: List.generate(widget.lstdata.length, (index) {
                  String oldtext = widget.lstdata[index][CS.Value].text;
                  return Container(
                    margin: EdgeInsets.all(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          color: Colors.brown,
                          alignment: Alignment.center,
                          child: Text(
                            widget.lstdata[index][CS.Number],
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        Container(
                          height: 30,
                          color: Colors.white,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: widget.lstdata[index][CS.Value],
                            style: TextStyle(fontSize: 10),
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (text) {
                              int Sum = 0;
                              Sum = 0;
                              log(widget.lstdata[index][CS.Value].text);
                              log("oldtext => " + oldtext.toString());
                              log("text => " + text);
                              for (int i = 0; i < widget.lstdata.length; i++) {
                                if (widget.lstdata[i][CS.Value].text.isNotEmpty)
                                  Sum = Sum +
                                      int.parse(
                                          widget.lstdata[i][CS.Value].text);
                              }
                              log(Sum.toString());
                              SumController.text = Sum.toString();
                            }, // Only
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      case 6:
      case 7:
      case 8:
        return Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: TextField(
                controller: CloseController,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: type == 6
                        ? "CLOSE PANNA"
                        : type == 8 ? "OPEN PANNA" : "CLOSE PANNA",
                    hintStyle: TextStyle(fontWeight: FontWeight.w600),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
              ),
              color: Colors.white,
            ),

            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: TextField(
                controller: OpenController,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: type == 6
                        ? "OPEN DIGIT"
                        : type == 8 ? "CLOSE DIGIT" : "OPEN PANA",
                    hintStyle: TextStyle(fontWeight: FontWeight.w600),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3)
                ],
              ),
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: TextField(
                controller: PointsController,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "POINTS",
                    hintStyle: TextStyle(fontWeight: FontWeight.w600),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3)
                ],
              ),
              color: Colors.white,
            ),
          ],
        );
    }
  }

  Future<void> callServiceDrop() async {
    Map<String, dynamic> resJson;
    Map<String, dynamic> body = <String, dynamic>{};

    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body,
          apiUrl: CS.DetailDropDownScreen +
              "&gameid=" +
              widget.data[CS.gameid].toString() +
              "&egametype=" +
              widget.data[CS.type].toString(),
          isShowPogressDilog: true,
          callMethod: CallMethod.Get);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }

    if (resJson[CS.status].toString() == StatusCode.Success) {
      items = List<String>();
      lsteopenclosedata = resJson[CS.lsteopenclosedata];
      lsteopenclosedata.forEach((e) {
        log(e.toString());
        items.add(e[CS.openclosename]);
      });
      log(items.toString());
      selectedItem = items[0];
      setState(() {});
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      items = <String>['No Game Found'];
      selectedItem = items[0];
      setState(() {});
    }
  }

  Future<void> callService() async {
    log("selectedItem " + items.indexOf(selectedItem).toString());
    if (!CU.IsLogin(context: context, action: true)) return;
    purchaseDataModal.clientid = MainScreenState.userInfo[k_clientid];
    purchaseDataModal.gameid = widget.data[CS.gameid];
    purchaseDataModal.egametype = widget.data[CS.type];
    purchaseDataModal.eopenclose =
        lsteopenclosedata[items.indexOf(selectedItem)]["opencloseid"] ?? 0;
    purchaseDataModal.lstpurchaseitem = List<Lstpurchaseitem>();
    log(widget.lstdata.length.toString());

    await widget.lstdata.forEach((item) {
      if (!CU.IsEmptyOrNull(item[CS.Value].text))
        purchaseDataModal.lstpurchaseitem.add(
          Lstpurchaseitem(
            amount: int.parse(item[CS.Value].text),
            number: item[CS.Number].toString(),
          ),
        );
    });

    if (widget.data[CS.type] == 6 ||
        widget.data[CS.type] == 7 ||
        widget.data[CS.type] == 8) {
      purchaseDataModal.lstpurchaseitem.add(
        Lstpurchaseitem(
          amount: int.parse(PointsController.text),
          number: OpenController.text,
          number2: CloseController.text,
        ),
      );
    }

    Map<String, dynamic> body = <String, dynamic>{
//      CS.token: await CU.getToken(),
      CS.purchasedata: jsonEncode(purchaseDataModal.toJson()),
    };
    Map<String, dynamic> resJson;
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body, apiUrl: CS.purchaseDataSave);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      CU.showToast(context, resJson[CS.message], backgroundColor: Colors.green);
      MainScreenState.userInfo[k_Walletamount] = resJson[k_walletamount];
      log("++++++++++++++++++++++++++++++++++++");
      log(MainScreenState.userInfo.toString());
      log("++++++++++++++++++++++++++++++++++++");
      CU.setUserInfo(jsonEncode(MainScreenState.userInfo));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => GameTicketScreen()));
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
