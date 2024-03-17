class StoresListResponseModel {
  bool? status;
  String? msg;
  List<StoresListItem>? data;

  StoresListResponseModel({this.status, this.msg, this.data});

  StoresListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <StoresListItem>[];
      json['data'].forEach((v) {
        data!.add(StoresListItem.fromJson(v));
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

class StoresListItem {
  String? id;
  String? lat;
  String? lon;
  String? storeName;
  String? city;
  String? area;
  String? location;
  int? visitStatus;

  StoresListItem(
      {this.id,
        this.lat,
        this.lon,
        this.storeName,
        this.city,
        this.area,
        this.location,
        this.visitStatus,
      });

  StoresListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    lat = json['lat'].toString();
    lon = json['lon'].toString();
    storeName = json['store_name'] ?? "";
    city = json['city'] ?? "";
    area = json['area'] ?? "";
    location = json['location'] ?? "";
    visitStatus = json['visit_status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lat'] = lat;
    data['lon'] = lon;
    data['store_name'] = storeName;
    data['city'] = city;
    data['area'] = area;
    data['location'] = location;
    data['visit_status'] = visitStatus;
    return data;
  }
}