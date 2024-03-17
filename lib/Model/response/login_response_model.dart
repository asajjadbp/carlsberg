class LoginResponseModel {
  bool? status;
  String? msg;
  List<LoginResponseItem>? data;

  LoginResponseModel({this.status, this.msg, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <LoginResponseItem>[];
      json['data'].forEach((v) {
        data!.add(LoginResponseItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoginResponseItem {
  int? id;
  String? fullName;
  String? email;

  LoginResponseItem({this.id, this.fullName, this.email});

  LoginResponseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    return data;
  }
}