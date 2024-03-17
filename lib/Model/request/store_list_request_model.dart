class StoresListRequestModel {
  String? city;
  String? area;
  String? location;

  StoresListRequestModel({this.city,this.area,this.location});

  StoresListRequestModel.fromJson(Map<String, dynamic> json) {

    city = json['city'];
    area = json['area'];
    location = json['lat_lon'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['city'] = city;
    data['area'] = area;
    data['lat_lon'] = location;

    return data;
  }
}