class LoginModal {
  int clientid;
  int organizationid = 1;
  String clientname = "";
  String email = "";
  String mobileno = "";
  String otp;
  double Walletamount;

  LoginModal({this.clientid, this.organizationid, this.clientname, this.email, this.mobileno, this.otp, this.Walletamount});

  LoginModal.fromJson(Map<String, dynamic> json) {
    clientid = json['clientid'];
    organizationid = json['organizationid'];
    clientname = json['clientname'];
    email = json['email'];
    mobileno = json['mobileno'];
    otp = json['otp'];
    Walletamount = double.parse(json['Walletamount'].toString().replaceAll(",",""));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientid'] = this.clientid;
    data['organizationid'] = this.organizationid;
    data['clientname'] = this.clientname;
    data['email'] = this.email;
    data['mobileno'] = this.mobileno;
    data['otp'] = this.otp;
    data['Walletamount'] = this.Walletamount;
    return data;
  }
}
