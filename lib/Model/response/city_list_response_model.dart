class CityListResponseModel {
  bool? status;
  String? msg;
  List<CityListItem>? data;

  CityListResponseModel({this.status, this.msg, this.data});

  CityListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CityListItem>[];
      json['data'].forEach((v) {
        data!.add(CityListItem.fromJson(v));
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

class CityListItem {
  String? city;

  CityListItem({this.city});

  CityListItem.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    return data;
  }
}