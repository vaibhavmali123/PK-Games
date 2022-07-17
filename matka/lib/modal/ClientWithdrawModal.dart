class ClientWithdrawModal {
  int clientid;
  int ewithdrawmode;
  int amount;
  String mobileno;

  ClientWithdrawModal(
      {this.clientid, this.ewithdrawmode, this.amount, this.mobileno});

  ClientWithdrawModal.fromJson(Map<String, dynamic> json) {
    clientid = json['clientid'];
    ewithdrawmode = json['ewithdrawmode'];
    amount = json['amount'];
    mobileno = json['mobileno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientid'] = this.clientid;
    data['ewithdrawmode'] = this.ewithdrawmode;
    data['amount'] = this.amount;
    data['mobileno'] = this.mobileno;
    return data;
  }
}