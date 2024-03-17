
import 'package:carlsberg/UI_Screen/survey/survey_screen3.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/response/survey_question_list_response_model.dart';
import '../../utills/app_colors_new.dart';
import '../../utills/user_constants.dart';
import '../../widgets/buttons_widgets.dart';
class SurveyScreen2 extends StatefulWidget {
  const SurveyScreen2({super.key,required this.surveyQuestionList,required this.storeId,required this.surveyName});

  final List<SurveyQuestionListItem> surveyQuestionList;
  final String storeId;
  final String surveyName;

  @override
  State<SurveyScreen2> createState() => _SurveyScreen2State();
}

class _SurveyScreen2State extends State<SurveyScreen2> {

  int groupValue = -1;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;

  bool isLoadingArea = false;

  String userId = "";
  String name = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userId = sharedPreferences.getString(UserConstants().userId)!;
      name = sharedPreferences.getString(UserConstants().userName)!;
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
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Text(widget.surveyName,overflow: TextOverflow.ellipsis,style: const TextStyle(fontWeight: FontWeight.bold),)),
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
                      Text("3: ${widget.surveyQuestionList[2].question}"),
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
                      if(groupValue == 0)
                        Column(
                          children: [
                            CheckboxListTile(
                              title: const Text("Holeston Single Door"),
                              value: _isChecked1,
                              activeColor: AppColors.primaryColor,
                              onChanged: (value){
                                 setState(() {
                                   _isChecked1 = value!;
                                 });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text("Holeston Single Door"),
                              value: _isChecked2,
                              activeColor: AppColors.primaryColor,
                              onChanged: (value){
                                setState(() {
                                  _isChecked2 = value!;
                                });
                              },
                            ),CheckboxListTile(
                              title: const Text("Moussy Single Door"),
                              value: _isChecked3,
                              activeColor: AppColors.primaryColor,
                              onChanged: (value){
                                setState(() {
                                  _isChecked3 = value!;
                                });
                              },
                            ),

                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                NextPreviousButtons(
                  isPreviousVisible: true,
                  isNextVisible: true,
                  buttonNextName: 'Next',buttonPrevName: "Previous",nextOnTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SurveyScreen3(storeId: widget.storeId,surveyQuestionList: widget.surveyQuestionList,surveyName: widget.surveyName,)));
                },prevOnTap: (){
                  Navigator.of(context).pop();
                },),
              ],
            ),
          ),
          if(isLoadingArea)
            const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),)
        ],
      ),
    );
  }
}
