import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:carlsberg/utills/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/response/survey_list_for_dynamic_screen_model.dart';
import '../../Network/http_manager.dart';
import '../../utills/alert_dialogue.dart';
import '../../utills/app_colors_new.dart';
import '../../utills/user_constants.dart';
import '../../widgets/alert_dialogue.dart';
import '../../widgets/buttons_widgets.dart';
import '../../widgets/iamge_compression.dart';
import '../../widgets/toast_message_show.dart';

class SurveyDynamicScreen extends StatefulWidget {
  const SurveyDynamicScreen({super.key,required this.storeId,required this.surveyName});

  final String surveyName;
  final String storeId;

  @override
  State<SurveyDynamicScreen> createState() => _SurveyDynamicScreenState();
}

class _SurveyDynamicScreenState extends State<SurveyDynamicScreen> {

  List<SurveyAllQuestionsListItem> surveyQuestionList = <SurveyAllQuestionsListItem>[];
  int index = 0;
  int detailsIndex = 0;
  List controllerListDynamic = [];
  List controllerListDynamicCopy = [];
  List <List<String>> stringList = [];

  TextEditingController controller = TextEditingController();

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;

  bool isLoading = true;
  bool isLoadingArea = false;

  bool isError = false;
  String errorText = "";

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

    HTTPManager().surveyQuestionListV1().then((value) {
      setState(() {
        surveyQuestionList = value.data!;

        isError = false;
        errorText = "";

        for(int i = 0; i < surveyQuestionList.length; i++) {
          stringList.add([]);

          if(surveyQuestionList[i].answerType == "number") {
            controllerListDynamic.add(TextEditingController());
          } else if(surveyQuestionList[i].answerType == "radio") {

            List controllerListForCheckbox = [];
            List controllerListForRadio = [];

            if(surveyQuestionList[i].detail!.isNotEmpty) {
              for(int j = 0; j < surveyQuestionList[i].detail!.length; j++) {
                controllerListForCheckbox.add(false);
              }
              controllerListForRadio.add(-1);
              controllerListForRadio.add(controllerListForCheckbox);

              controllerListDynamic.add(controllerListForRadio);
            } else {
              if(surveyQuestionList[i].showOtherOnValue != null) {
                controllerListForRadio.add(-1);
                controllerListForCheckbox.add(TextEditingController());
                controllerListForRadio.add(controllerListForCheckbox);
                controllerListDynamic.add(controllerListForRadio);
              } else {
            controllerListDynamic.add(-1);
          }
            }
          } else {
            List controllerListForCheckbox = [];
            List controllerListForRadio = [];
            if(surveyQuestionList[i].detail!.isNotEmpty) {
              for(int j = 0; j < surveyQuestionList[i].detail!.length; j++) {
                if(surveyQuestionList[i].detail![j].type == "checkbox" ) {
                  controllerListForCheckbox.add(false);
                } else {
                  controllerListForCheckbox.add(TextEditingController());
                }
              }
              controllerListForRadio.add(false);
              controllerListForRadio.add(controllerListForCheckbox);

              controllerListDynamic.add(controllerListForRadio);
            } else {
              controllerListDynamic.add(false);
            }
          }

        }

        controllerListDynamicCopy = controllerListDynamic;

        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
      });
      showToastMessage(false, e.toString());
    });
  }


  setRadioValue(String value,int index) {
    setState(() {
      surveyQuestionList[index].answer = value;
      surveyQuestionList[index].extraAnswer = "";
    });
    if(surveyQuestionList[index].detail!.isNotEmpty) {
      setState(() {
        controllerListDynamic[index][0] = value;
      });
    } else {
      if(surveyQuestionList[index].showOtherOnValue!=null) {
        setState(() {
          controllerListDynamic[index][0] = value;
        });
      } else {
        setState(() {
          controllerListDynamic[index] = value;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          color: AppColors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {Navigator.of(context).pop();},
        ),
        actions: [
          IconButton(onPressed: (){
            showLogoutAlertDialog(context);
          }, icon: const Icon(Icons.logout_rounded,color: AppColors.white,))
        ],
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Welcome $name", overflow: TextOverflow.ellipsis,style:const TextStyle(color: AppColors.white),),
      ),
      body: isLoading ?
      const LoaderWidget() : isError ? Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(errorText,style: const TextStyle(color: AppColors.redColor,fontSize: 20),),
            InkWell(
              onTap: () {
                getQuestionList();
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor)
                ),
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: const Text("Reload",style: TextStyle(color: AppColors.primaryColor,fontSize: 20),),
              ),
            )
          ],),
      )
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
                  // const SizedBox(height: 5,),
                  // NormalButton(buttonName: "Take Sign Board Photo",
                  //   onTap: (){
                  //     _getCurrentPositionAndImage();
                  //   },),
                  const SizedBox(height: 20,),

                  if(surveyQuestionList[index].answerType == "radio")
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
                          Text("${index + 1}: ${surveyQuestionList[index].question} ${surveyQuestionList[index].arQuestion}"),
                          InkWell(
                            onTap: (){
                                setRadioValue("Yes",index);
                            },
                            child: Row(
                              children: [
                                Radio<String>(
                                    hoverColor: AppColors.primaryColor,
                                    value: "Yes",
                                    groupValue:surveyQuestionList[index].detail!.isNotEmpty || surveyQuestionList[index].showOtherOnValue!=null ? controllerListDynamic[index][0].toString() : controllerListDynamic[index].toString(),
                                    onChanged: (value) {

                                      setRadioValue("Yes",index);
                                    }
                                ),
                                const Text("Yes"),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setRadioValue("No",index);
                            },
                            child: Row(
                              children: [
                                Radio<String>(
                                    hoverColor: AppColors.primaryColor,
                                    value: "No",
                                    groupValue:surveyQuestionList[index].detail!.isNotEmpty || surveyQuestionList[index].showOtherOnValue!=null ? controllerListDynamic[index][0].toString() : controllerListDynamic[index].toString(),
                                    onChanged: (value) {
                                      setRadioValue("No",index);
                                    }
                                ),
                                const Text("No"),
                              ],
                            ),
                          ),
                          if(surveyQuestionList[index].showOtherOnValue != null)
                          if(surveyQuestionList[index].showOtherOnValue == controllerListDynamic[index][0])
                            surveyQuestionList[index].detail!.isNotEmpty ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: surveyQuestionList[index].detail!.length,
                                shrinkWrap: true,
                                itemBuilder: (context,index1){
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text(surveyQuestionList[index].detail![index1].title!),
                                          value: controllerListDynamic[index][1][index1],
                                          activeColor: AppColors.primaryColor,
                                          onChanged: (value){

                                            setState(() {
                                              surveyQuestionList[index].extraAnswer = "";
                                              controllerListDynamic[index][1][index1] = value!;
                                              if(controllerListDynamic[index][1][index1]) {
                                                stringList[index].add(surveyQuestionList[index].detail![index1].title!);
                                              } else {
                                                stringList[index].remove(surveyQuestionList[index].detail![index1].title!);
                                              }
                                              print(stringList);
                                              surveyQuestionList[index].extraAnswer = stringList[index].toString().replaceAll("]", "").replaceAll("[", "");
                                            });
                                          },
                                        ),
                                      ),
                                      surveyQuestionList[index].detail![index1].isImage == "Y" && controllerListDynamic[index][1][index1] ?
                                        InkWell(
                                          onTap: () {
                                            pickedImage(index,index1);
                                          },
                                          child: const Icon(Icons.camera_alt,color: AppColors.primaryColor,),
                                        ) :  Image.asset("assets/icons/camera_slash.png",height: 25,width: 25,)
                                    ],
                                  );
                                }) : TextFormField(
                              keyboardType: TextInputType.text,
                              initialValue: surveyQuestionList[index].extraAnswer,
                              onChanged: (value) {
                                setState(() {
                                  surveyQuestionList[index].extraAnswer = value;
                                });

                              },
                              decoration: InputDecoration(
                                labelText: "Add Something here",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  if(surveyQuestionList[index].answerType == "checkbox")
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(3)
                      ),
                      child: Column(
                        children: [
                          Text("${index + 1}: ${surveyQuestionList[index].question} ${surveyQuestionList[index].arQuestion}"),
                          const SizedBox(height: 5,),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                              itemCount: surveyQuestionList[index].detail!.length,
                              shrinkWrap: true,
                              itemBuilder: (context,index1){
                            return surveyQuestionList[index].detail![index1].type == "text" ? TextFormField(
                              controller: controllerListDynamic[index][1][index1],
                              onChanged: (value) {

                                  surveyQuestionList[index].extraAnswer = value;

                                setState(() {

                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Other",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ) : CheckboxListTile(
                              title: Text(surveyQuestionList[index].detail![index1].title!),
                              value: controllerListDynamic[index][1][index1],
                              activeColor: AppColors.primaryColor,
                              onChanged: (value){
                                setState(() {
                                  controllerListDynamic[index][1][index1] = value!;
                                  if(controllerListDynamic[index][1][index1]) {
                                    stringList[index].add(surveyQuestionList[index].detail![index1].title!);
                                  } else {
                                    stringList[index].remove(surveyQuestionList[index].detail![index1].title!);
                                  }

                                    surveyQuestionList[index].answer = stringList[index].toString().replaceAll("]", "").replaceAll("[", "");

                                });
                              },
                            );
                          })
                        ],
                      ),
                    ),
                  if(surveyQuestionList[index].answerType == "number")
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(3)
                    ),
                    child: Column(
                      children: [
                        Text("${index + 1}: ${surveyQuestionList[index].question} ${surveyQuestionList[index].arQuestion}"),
                        const SizedBox(height: 5,),
                        TextFormField(
                          controller: controllerListDynamic[index],
                          onTapOutside: (event) => FocusScope.of(context).unfocus(),
                          onChanged: (value){
                            setState(() {
                              surveyQuestionList[index].answer = value;
                            });
                          },

                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter number here",
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) ,
                  const SizedBox(
                    height: 20,
                  ),
                  NextPreviousButtons(
                    buttonNextName: 'Next',
                    buttonPrevName: "Previous",
                    isNextVisible: index < surveyQuestionList.length - 1,
                    isPreviousVisible: index > 0,
                    nextOnTap: (){
                      log(jsonEncode(surveyQuestionList[index]));
                    if(index < surveyQuestionList.length - 1) {

                                  if (surveyQuestionList[index].answerType == "radio") {
                                    if (surveyQuestionList[index].answer!.isEmpty) {
                                      showToastMessage(false, "Please select an option please");
                                    } else {
                                      if (surveyQuestionList[index].answer! == surveyQuestionList[index].showOtherOnValue) {
                                        if (surveyQuestionList[index].extraAnswer!.isEmpty) {
                                          if (surveyQuestionList[index].detail!.isEmpty) {
                                            showToastMessage(false, "Enter your answer please");
                                          } else {
                                            showToastMessage(false, "Please select an option please");
                                          }
                                        } else {

                                          log(jsonEncode(surveyQuestionList[index]));
                                          if(surveyQuestionList[index].extraAnswer!.isNotEmpty && surveyQuestionList[index].detail!.isNotEmpty) {

                                            bool image1 = true;
                                            bool image2 = true;
                                            bool image3 = true;

                                            final splitExtraAnswer = surveyQuestionList[index].extraAnswer;
                                            final splitExtraAnswerList = splitExtraAnswer!.split(',');

                                            for(int i = 0; i<splitExtraAnswerList.length; i++) {
                                              for(int j = 0; j<surveyQuestionList[index].detail!.length; j++) {
                                                if(splitExtraAnswerList[i].trim() == surveyQuestionList[index].detail![j].title) {
                                                  if(surveyQuestionList[index].detail![j].isImage == "Y") {
                                                    if(surveyQuestionList[index].detail![j].imageName == "") {
                                                      if(j == 0) {
                                                        setState(() {
                                                          image1 = false;
                                                        });
                                                      } else if(j == 1) {
                                                        setState(() {
                                                          image2 = false;
                                                        });
                                                      } else  if(j == 2) {
                                                        setState(() {
                                                          image3 = false;
                                                        });

                                                      }
                                                    } else {
                                                      setState(() {
                                                        image1 = true;
                                                        image2 = true;
                                                        image3 = true;
                                                      });
                                                    }
                                                  }
                                                  if(detailsIndex< surveyQuestionList[index].detail!.length-1) {
                                                    setState(() {
                                                      detailsIndex = detailsIndex + 1;
                                                    });
                                                  }
                                                }
                                              }

                                            }

                                            if(!image1) {
                                              showToastMessage(false, "Please upload photo for option1");
                                            } else if(!image2) {
                                              showToastMessage(false, "Please upload photo for option2");
                                            } else if(!image3) {
                                              showToastMessage(false, "Please upload photo for option3");
                                            } else {
                                              setState(() {
                                                if (index < surveyQuestionList.length - 1) {
                                                  index = index + 1;
                                                }
                                              });
                                            }


                                          } else {
                                            setState(() {
                                              if (index < surveyQuestionList.length - 1) {
                                                index = index + 1;
                                              }
                                            });
                                          }

                                        }
                                      } else {
                                        if (index < surveyQuestionList.length - 1) {
                                          index = index + 1;
                                        }

                                      }
                                    }
                                  } else if (surveyQuestionList[index].answerType == "checkbox") {
                                    if (surveyQuestionList[index].answer!.isEmpty) {
                                      showToastMessage(false, "Please select an option please");
                                    } else {
                                      if (index < surveyQuestionList.length - 1) {
                                        index = index + 1;
                                      }
                                    }
                                  } else {
                                    if (surveyQuestionList[index].answer!.isEmpty) {
                                      showToastMessage(false, "Please enter any number please");
                                    } else {
                                      if (index < surveyQuestionList.length - 1) {
                                        index = index + 1;
                                      }
                                    }
                                  }
                                } else {
                      // if(surveyQuestionList[index].answer!.isNotEmpty || surveyQuestionList[index].extraAnswer!.isNotEmpty ) {
                      //   Timer(
                      //       const Duration(seconds: 3),
                      //           () {
                      //
                      //       });
                      // } else {
                      //   showToastMessage(false,
                      //       "Please select an option or write something in field");
                      // }
                    }
                                setState(() {});
                  },prevOnTap: (){
                    setState(() {
                      if(index > 0) {
                        index = index - 1;
                      }
                    });

                  },),
                  if(index == surveyQuestionList.length - 1)
                    const SizedBox(height: 20,),
                  if(index == surveyQuestionList.length - 1)
                    NormalButton(buttonName: "Finish Survey", onTap: (){
                      if(index == surveyQuestionList.length - 1) {
                        if(surveyQuestionList[index].answer!.isEmpty && surveyQuestionList[index].extraAnswer!.isEmpty) {
                          showToastMessage(false, "Please select an option os add something in text field");
                        } else {
                          showFinishVisitAlertDialog(context,index,(){_finishSurvey();});
                        }
                      }
                      // showFinishVisitAlertDialog(context,index,(){_finishSurvey();});
                    })
                ],
              ),
            ),
          ),
          if(isLoadingArea)
            const LoaderWidget()
        ],
      ),
    );
  }

  _finishSurvey() {
    setState(() {
      isLoadingArea = true;
    });
    SurveyAllQuestionsList surveyAllQuestionsList1 = SurveyAllQuestionsList(storeId:widget.storeId,msg: "This is answer",status: true,data: surveyQuestionList);
    // var response = jsonEncode(surveyAllQuestionsList1);
    // log(response);

    HTTPManager().saveSurveyAnswers(surveyAllQuestionsList1).then((value) {

      showToastMessage(true, "Survey Answers uploaded!");
      setState(() {
        isLoadingArea = false;
      });
      Navigator.of(context).pop();
    }).catchError((e) {
      showToastMessage(false, e.toString());
      setState(() {
        isLoadingArea = false;
      });
    });
  }

  Future<void> pickedImage(int index,int secondaryIndex) async {

    image = await picker.pickImage(
        source: ImageSource.camera);
    if (image == null) {
    } else {
      compressedImage = await compressAndGetFile(image!,surveyQuestionList[index].detail![secondaryIndex].title!);

      showUploadOption(index,secondaryIndex);
    }
  }

  showUploadOption(int index,int secondaryIndex){
    showPopUpForImageUpload(context,
        compressedImage!,
            (){
          uploadImageOption(index,secondaryIndex);
        });
  }

  uploadImageOption(int index,int secondaryIndex) {
    setState(() {
      isLoadingArea = true;
    });
    HTTPManager().uploadPhotoOnOptions(compressedImage!).then((value) {

      showToastMessage(true, "Image Uploaded successfully");

      setState(() {
        surveyQuestionList[index].detail![secondaryIndex].imageName = value["data"][0]['image'];

        print(secondaryIndex);

        isLoadingArea = false;
      });
    }).catchError((e){

      showToastMessage(false, e.toString());
      setState(() {
        isLoadingArea = false;
      });
    });
  }

}
