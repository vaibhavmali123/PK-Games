import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matka/modal/ClientPaymentModal.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/navigation/widget/EditingController.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddBalanceScreen extends StatefulWidget {
  @override
  _AddBalanceScreenState createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  ClientPaymentModal clientPaymentModal = ClientPaymentModal();
  EditingController amountController = EditingController();
  EditingController paymentTypeController = EditingController();
  EditingController idController = EditingController();
  EditingController mobileController = EditingController();
List<String>items=["Seelect Payment Type","Cheque","Netbanking","UPI"];
var selected;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CU.getAppbar("Add Balance"),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                    controller: amountController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Amount',
                      errorText: amountController.error.text,
                      prefixText: "₹",
                      prefixStyle:TextStyle(color: Colors.black,fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  height: 55,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width/1.2,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border:Border.all(color:Colors.black,width: 0.4)
                  ),
                  child:DropdownButtonHideUnderline(
                    child:DropdownButton(
                      isDense: false,
                      items:items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value!=null?value:"Select Payment Type",style: TextStyle(color: Colors.black),),
                        );
                      }).toList(),
                      isExpanded: true,
                      hint:Text("Select Payment Type",style: TextStyle(color: Colors.black),),
                      value:selected,
                      onChanged: (val) {
                        setState(() {
                          selected=val;
                        });
                      },
                    ),
                  )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Transaction Id',
                      errorText: idController.error.text,
                      prefixIcon: Icon(Icons.compare_arrows),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                    controller: mobileController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Transaction Mobile No',
                      errorText: mobileController.error.text,
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 6),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Add Balance'),
                      onPressed: () {
                        if (IsValidate()) callService();
                      },
                    )),
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
    amountController.clear();
    paymentTypeController.clear();
    mobileController.clear();
  }

  Future<void> callService() async {
    clientPaymentModal.clientid = MainScreenState.userInfo[k_clientid];
    clientPaymentModal.amount = int.parse(amountController.text);
    clientPaymentModal.transactionnumber = idController.text;
    clientPaymentModal.transactionmobileno = mobileController.text;
    clientPaymentModal.bankaccountid = paymentTypeController.text == "Google Pay"
        ? 1
        : paymentTypeController.text == "Paytm"
            ? 2
            : 3;
    Map<String, dynamic> body = <String, dynamic>{
//      CS.token: await CU.getToken(),
      CS.clientpayment: jsonEncode(clientPaymentModal.toJson()),
    };
    Map<String, dynamic> resJson;
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context, body: body, apiUrl: CS.clientPaymentSave);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      CU.showToast(context, resJson[CS.message], backgroundColor: Colors.green);
      Navigator.of(context).pop(true);
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }

  bool IsValidate() {
    bool isValid = true;

    amountController.error.text = null;
    paymentTypeController.error.text = null;
    idController.error.text = null;
    mobileController.error.text = null;

    if (amountController.text.isEmpty) {
      amountController.error.text = "Please Enter Amount.";
      isValid = false;
    }
    if (selected==null) {
      paymentTypeController.error.text = "Select Payment Type.";
      isValid = false;
    }
    if (idController.text.isEmpty) {
      idController.error.text = "Please Enter Transaction Id.";
      isValid = false;
    }
    if (mobileController.text.isEmpty) {
      mobileController.error.text = "Please Enter Transaction Mobile No.";
      isValid = false;
    }
    setState(() {});

    return isValid;
  }
}

class ModalFit extends StatelessWidget {
  final ScrollController scrollController;
  final EditingController paymentTypeController;

  const ModalFit({Key key, this.scrollController, this.paymentTypeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Google Pay'),
            onTap: () => callonTap(context, 'Google Pay'),
          ),
          ListTile(
            title: Text('Paytm'),
            onTap: () => callonTap(context, 'Paytm'),
          ),
          ListTile(
            title: Text('Phone pay'),
            onTap: () => callonTap(context, 'Phone pay'),
          )
        ],
      ),
    ));
  }

  callonTap(context, Text) {
    Navigator.of(context).pop();
    paymentTypeController.text = Text;
  }
}
