// ignore_for_file: avoid_print, duplicate_ignore

import 'package:carlsberg/Model/request/city_area_request_model.dart';
import 'package:carlsberg/Model/request/store_list_request_model.dart';
import 'package:carlsberg/Model/response/city_area_response_model.dart';
import 'package:carlsberg/Model/response/city_list_response_model.dart';
import 'package:carlsberg/Model/response/stores_list_response_model.dart';
import 'package:carlsberg/Network/response_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/request/login_request_model.dart';
import '../Model/request/start_survey_request_model.dart';
import '../Model/request/update_sign_board_photo.dart';
import '../Model/response/login_response_model.dart';
import '../Model/response/survey_list_for_dynamic_screen_model.dart';
import '../Model/response/survey_question_list_response_model.dart';
import 'api_urls.dart';

class HTTPManager {
  final ResponseHandler _handler = ResponseHandler();


  Future<LoginResponseModel> loginUser(
      LoginRequestModel loginRequestModel) async {

    var url = ApplicationURLs.API_LOGIN;
  print(url);
    final response =
        await _handler.post(Uri.parse(url), loginRequestModel.toJson());
    LoginResponseModel logInResponseModel = LoginResponseModel.fromJson(response);

    return logInResponseModel;
  }

  //CITY LIST
  Future<CityListResponseModel> cityList() async {

    var url = ApplicationURLs.API_CITY_LIST;
    print(url);
    final response =
    await _handler.get(Uri.parse(url),);
    CityListResponseModel cityListResponseModel = CityListResponseModel.fromJson(response);

    return cityListResponseModel;
  }

  //CITY AREA LIST
  Future<CityAreaListResponseModel> cityAreaList(CityAreaRequestModel cityAreaRequestModel) async {

    var url = ApplicationURLs.API_CITY_AREA;
    print(url);
    final response =
    await _handler.post(Uri.parse(url),cityAreaRequestModel.toJson());
    CityAreaListResponseModel cityAreaListResponseModel = CityAreaListResponseModel.fromJson(response);

    return cityAreaListResponseModel;
  }

  //STORES LIST
  Future<StoresListResponseModel> storesList(StoresListRequestModel storesListRequestModel) async {

    var url = ApplicationURLs.API_LOAD_STORE;
    print(url);
    final response =
    await _handler.post(Uri.parse(url),storesListRequestModel.toJson());
    StoresListResponseModel storesListResponseModel = StoresListResponseModel.fromJson(response);

    return storesListResponseModel;
  }

  //START SURVEY
  Future<dynamic> startSurvey(StartSurveyRequestModel startSurveyRequestModel) async {

    var url = ApplicationURLs.API_START_SURVEY;
    print(url);
    final response =
    await _handler.post(Uri.parse(url),startSurveyRequestModel.toJson());

    return response;
  }

  //UPDATE SIGN BOARD PHOTO
  Future<dynamic> updateSignBoardPhoto(UpdateSignBoardPhotoRequestModel updateSignBoardPhotoRequestModel, XFile photoFile) async {

    var url = ApplicationURLs.API_UPDATE_SIGNBOARD_PHOTO;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImage(url, updateSignBoardPhotoRequestModel.toJson(), photoFile);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }

  //SURVEY QUESTION LIST
  Future<SurveyQuestionListResponseModel> surveyQuestionList() async {

    var url = ApplicationURLs.API_SURVEY_QUESTIONS;
    print(url);
    final response =
    await _handler.get(Uri.parse(url),);
    SurveyQuestionListResponseModel surveyQuestionListResponseModel = SurveyQuestionListResponseModel.fromJson(response);

    return surveyQuestionListResponseModel;
  }

  //SURVEY QUESTION LIST
  Future<SurveyAllQuestionsList> surveyQuestionListV1() async {

    var url = ApplicationURLs.API_SURVEY_QUESTIONS_V1;
    print(url);
    final response =
    await _handler.get(Uri.parse(url),);
    SurveyAllQuestionsList surveyQuestionListResponseModel = SurveyAllQuestionsList.fromJson(response);

    return surveyQuestionListResponseModel;
  }

  //UPLOAD PHOTO FOR OPTIONS
  Future<dynamic> uploadPhotoOnOptions(XFile photoFile) async {

    var url = ApplicationURLs.API_UPLOAD_PHOTO_OPTION;
    // ignore: avoid_print
    print(url);

    final response = await _handler.postImageForOptions(url, photoFile);
    // JourneyPlanResponseModel journeyPlanResponseModel = JourneyPlanResponseModel.fromJson(response);

    return response;
  }


  //SAVE SURVEY ANSWER
  Future<dynamic> saveSurveyAnswers(dynamic answerJson) async {

    var url = ApplicationURLs.API_SAVE_ANSWER_LIST;
    print(url);
    final response = await _handler.postWithJsonRequest(Uri.parse(url),answerJson);

    return response;
  }

}
