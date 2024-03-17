class SurveyAllQuestionsList {
  bool? status;
  String? msg;
  String? storeId;
  List<SurveyAllQuestionsListItem>? data;

  SurveyAllQuestionsList({this.status, this.msg, this.data,this.storeId});

  SurveyAllQuestionsList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    storeId = json['store_id'] ?? "";
    if (json['data'] != null) {
      data = <SurveyAllQuestionsListItem>[];
      json['data'].forEach((v) {
        data!.add(SurveyAllQuestionsListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    data['store_id'] = storeId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SurveyAllQuestionsListItem {
  String? id;
  String? question;
  String? arQuestion;
  String? answerType;
  String? showOther;
  String? showOtherOnValue;
  String? answer;
  String? extraAnswer;
  String? listOrder;
  String? isActive;
  String? updatedAt;
  List<Detail>? detail;

  SurveyAllQuestionsListItem(
      {this.id,
        this.question,
        this.arQuestion,
        this.answerType,
        this.showOther,
        this.showOtherOnValue,
        this.answer,
        this.extraAnswer,
        this.listOrder,
        this.isActive,
        this.updatedAt,
        this.detail});

  SurveyAllQuestionsListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    question = json['question'];
    arQuestion = json['ar_question'];
    answerType = json['answer_type'].toString();
    showOther = json['show_other'].toString();
    showOtherOnValue = json['show_other_on_value'];
    answer = json['answer'] ?? "";
    extraAnswer = json['extra_answer'] ?? "";
    listOrder = json['list_order'].toString();
    isActive = json['is_active'].toString();
    updatedAt = json['updated_at'].toString();
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['ar_question'] = arQuestion;
    data['answer_type'] = answerType;
    data['show_other'] = showOther;
    data['show_other_on_value'] = showOtherOnValue;
    data['answer'] = answer;
    data['extra_answer'] = extraAnswer;
    data['list_order'] = listOrder;
    data['is_active'] = isActive;
    data['updated_at'] = updatedAt;
    if (detail != null) {
      data['detail'] = detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  String? type;
  String? title;
  String? isImage;
  String? imageName;

  Detail({this.type, this.title, this.isImage,this.imageName});

  Detail.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    isImage = json['is_image'];
    imageName = json['image_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    data['is_image'] = isImage;
    data['image_name'] = imageName;
    return data;
  }
}