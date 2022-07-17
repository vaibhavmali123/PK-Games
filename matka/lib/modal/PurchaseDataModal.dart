class PurchaseDataModal {
  int purchaseid;
  int gameid;
  int clientid;
  int eopenclose;
  int egametype;
  List<Lstpurchaseitem> lstpurchaseitem;

  PurchaseDataModal({this.purchaseid = 0, this.gameid, this.clientid, this.eopenclose, this.egametype, this.lstpurchaseitem});

  PurchaseDataModal.fromJson(Map<String, dynamic> json) {
    purchaseid = json['purchaseid'];
    gameid = json['gameid'];
    clientid = json['clientid'];
    eopenclose = json['eopenclose'];
    egametype = json['egametype'];
    if (json['lstpurchaseitem'] != null) {
      lstpurchaseitem = new List<Lstpurchaseitem>();
      json['lstpurchaseitem'].forEach((v) {
        lstpurchaseitem.add(new Lstpurchaseitem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purchaseid'] = this.purchaseid;
    data['gameid'] = this.gameid;
    data['clientid'] = this.clientid;
    data['eopenclose'] = this.eopenclose;
    data['egametype'] = this.egametype;
    if (this.lstpurchaseitem != null) {
      data['lstpurchaseitem'] = this.lstpurchaseitem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lstpurchaseitem {
  int purchaseitemid;
  String number;
  String number2;
  int amount;

  Lstpurchaseitem({this.purchaseitemid = 0, this.number, this.number2, this.amount});

  Lstpurchaseitem.fromJson(Map<String, dynamic> json) {
    purchaseitemid = json['purchaseitemid'];
    number = json['number'];
    number2 = json['number2'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purchaseitemid'] = this.purchaseitemid;
    data['number'] = this.number;
    data['number2'] = this.number2;
    data['amount'] = this.amount;
    return data;
  }
}
