class CityAreaRequestModel {
  String? city;

  CityAreaRequestModel({this.city});

  CityAreaRequestModel.fromJson(Map<String, dynamic> json) {

    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['city'] = city;
    return data;
  }
}