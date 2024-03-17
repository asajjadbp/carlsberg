class UpdateSignBoardPhotoRequestModel {
  String? id;
  String? userLoc;

  UpdateSignBoardPhotoRequestModel({this.id,this.userLoc,});

  UpdateSignBoardPhotoRequestModel.fromJson(Map<String, String> json) {

    id = json['id'];
    userLoc = json['user_loc'];

  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};

    data['id'] = id!;
    data['user_loc'] = userLoc!;

    return data;
  }
}