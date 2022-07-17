class ClientPaymentModal {
  int clientid;
  int bankaccountid = 0;
  int amount;
  String transactionnumber;
  String transactionmobileno;

  ClientPaymentModal(
      {this.clientid,
        this.bankaccountid,
        this.amount,
        this.transactionnumber,
        this.transactionmobileno});

  ClientPaymentModal.fromJson(Map<String, dynamic> json) {
    clientid = json['clientid'];
    bankaccountid = json['bankaccountid'];
    amount = json['amount'];
    transactionnumber = json['transactionnumber'];
    transactionmobileno = json['transactionmobileno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientid'] = this.clientid;
    data['bankaccountid'] = this.bankaccountid;
    data['amount'] = this.amount;
    data['transactionnumber'] = this.transactionnumber;
    data['transactionmobileno'] = this.transactionmobileno;
    return data;
  }
}