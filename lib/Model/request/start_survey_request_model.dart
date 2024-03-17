class StartSurveyRequestModel {
  String? id;
  String? userId;

  StartSurveyRequestModel({this.id,this.userId});

  StartSurveyRequestModel.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    userId = json['user_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['user_id'] = userId;

    return data;
  }
}