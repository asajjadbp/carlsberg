class SurveyQuestionListResponseModel {
  bool? status;
  String? msg;
  List<SurveyQuestionListItem>? data;

  SurveyQuestionListResponseModel({this.status, this.msg, this.data});

  SurveyQuestionListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <SurveyQuestionListItem>[];
      json['data'].forEach((v) {
        data!.add(SurveyQuestionListItem.fromJson(v));
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

class SurveyQuestionListItem {
  String? id;
  String? question;
  String? answerType;
  String? showInputIfNo;
  String? answer;
  String? isActive;
  String? updatedAt;

  SurveyQuestionListItem(
      {this.id,
        this.question,
        this.answerType,
        this.showInputIfNo,
        this.answer,
        this.isActive,
        this.updatedAt});

  SurveyQuestionListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    question = json['question'].toString();
    answerType = json['answer_type'].toString();
    showInputIfNo = json['show_input_if_no'].toString();
    answer = json['answer'].toString();
    isActive = json['is_active'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer_type'] = answerType;
    data['show_input_if_no'] = showInputIfNo;
    data['answer'] = answer;
    data['is_active'] = isActive;
    data['updated_at'] = updatedAt;
    return data;
  }
}