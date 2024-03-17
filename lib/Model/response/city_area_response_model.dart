class CityAreaListResponseModel {
  bool? status;
  String? msg;
  List<CityAreaListItem>? data;

  CityAreaListResponseModel({this.status, this.msg, this.data});

  CityAreaListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CityAreaListItem>[];
      json['data'].forEach((v) {
        data!.add(CityAreaListItem.fromJson(v));
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

class CityAreaListItem {
  String? area;

  CityAreaListItem({this.area});

  CityAreaListItem.fromJson(Map<String, dynamic> json) {
    area = json['area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area'] = area;
    return data;
  }
}