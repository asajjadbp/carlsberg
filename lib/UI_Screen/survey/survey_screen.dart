
import 'package:carlsberg/Model/response/survey_question_list_response_model.dart';
import 'package:carlsberg/Network/http_manager.dart';
import 'package:carlsberg/UI_Screen/survey/survey_screen1.dart';
import 'package:carlsberg/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request/update_sign_board_photo.dart';
import '../../utills/app_colors_new.dart';
import '../../utills/user_constants.dart';
import '../../widgets/alert_dialogue.dart';
import '../../widgets/buttons_widgets.dart';
import '../../widgets/handle_location_permission.dart';
import '../../widgets/iamge_compression.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key,required this.storeId,required this.surveyName});

  final String surveyName;
  final String storeId;

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {

  int groupValue = -1;

  List<SurveyQuestionListItem> surveyQuestionList = <SurveyQuestionListItem>[];

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  Position? _currentPosition;

  bool isLoading = true;
  bool isLoadingArea = false;

  String userId = "";
  String name = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    getQuestionList();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userId = sharedPreferences.getString(UserConstants().userId)!;
      name = sharedPreferences.getString(UserConstants().userName)!;
    });

  }

  getQuestionList() {
    setState(() {
      isLoading = true;
    });

    HTTPManager().surveyQuestionList().then((value) {
      setState(() {
        surveyQuestionList = value.data!;
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      showToastMessage(false, e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Welcome $name", overflow: TextOverflow.ellipsis,style:const TextStyle(color: AppColors.white),),
      ),
      body: isLoading ?
      const Center(child:  CircularProgressIndicator(color: AppColors.primaryColor,))
          : surveyQuestionList.isEmpty ?
          const Center( child:  Text("Questions not available yet"),)
          : Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                     width: MediaQuery.of(context).size.width,
                       alignment: Alignment.center,
                       child: Text(widget.surveyName,overflow: TextOverflow.ellipsis,style: const TextStyle(fontWeight: FontWeight.bold),)),
                  const SizedBox(height: 5,),
                  NormalButton(buttonName: "Take Sign Board Photo",
                    onTap: (){
                      _getCurrentPositionAndImage();
                    },),
                  const SizedBox(height: 20,),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(3)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1: ${surveyQuestionList[0].question}"),
                        InkWell(
                          onTap: (){
                            setState(() {
                              groupValue = 0;
                            });
                          },
                          child: Row(
                            children: [
                              Radio(
                                  hoverColor: AppColors.primaryColor,
                                  value: 0,
                                  groupValue: groupValue,
                                  onChanged: (value) {

                                    setState(() {
                                      groupValue = value!;
                                    });
                                  }
                              ),
                              const Text("Yes"),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              groupValue = 1;
                            });
                          },
                          child: Row(
                            children: [
                              Radio(
                                  hoverColor: AppColors.primaryColor,
                                  value: 1,
                                  groupValue: groupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      groupValue = value!;
                                    });
                                  }
                              ),
                              const Text("No"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  NextPreviousButtons(
                    isPreviousVisible: false,
                    isNextVisible: true,
                    buttonNextName: 'Next',buttonPrevName: "Previous",nextOnTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SurveyScreen1(storeId: widget.storeId,surveyQuestionList: surveyQuestionList,surveyName: widget.surveyName,)));
                  },prevOnTap: (){
                    Navigator.of(context).pop();
                  },),

                ],
              ),
            ),
          ),
          if(isLoadingArea)
            const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),)
        ],
      ),
    );
  }

  Future<void> _getCurrentPositionAndImage() async {


    final hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      return;
    }
    setState(() {
      isLoadingArea = true;
    });
    await Geolocator.getCurrentPosition().then((Position position) async {
      setState(() => _currentPosition = position);

      String location = "${_currentPosition!.latitude},${_currentPosition!.longitude}";

      pickedImage(location);

    }).catchError((e) {
      debugPrint(e);

    });
  }

  Future<void> pickedImage(String location) async {
    image = await picker.pickImage(
        source: ImageSource.camera);
    if (image == null) {
    } else {

      compressedImage = await compressAndGetFile(image!,"start_survey_image");
      showUploadOption(location);
    }
  }

  showUploadOption(String location){
    showPopUpForImageUpload(context,
        compressedImage!,
            (){
              updateSingBoardPhoto(location);
            });
  }

  updateSingBoardPhoto(String location)  {
    setState(() {
      isLoadingArea = true;
    });

    HTTPManager().updateSignBoardPhoto(UpdateSignBoardPhotoRequestModel(userLoc: location,id: widget.storeId,), compressedImage!).then((value) {
      setState(() {
        isLoadingArea = false;
      });
      showToastMessage(true, "image updated successfully");
    }).catchError((e) {
      setState(() {
        isLoadingArea = false;
      });
      showToastMessage(false, e.toString());
    });
  }
}
