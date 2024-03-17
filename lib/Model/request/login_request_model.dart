class LoginRequestModel {
  String? id;
  String? password;

  LoginRequestModel({this.id, this.password});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['password'] = password;
    return data;
  }
}