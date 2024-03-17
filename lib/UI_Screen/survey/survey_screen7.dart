
import 'dart:async';

import 'package:carlsberg/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/response/survey_question_list_response_model.dart';
import '../../utills/app_colors_new.dart';
import '../../utills/user_constants.dart';
import '../../widgets/buttons_widgets.dart';
import '../home/home_screen.dart';

class SurveyScreen7 extends StatefulWidget {
  const SurveyScreen7({super.key,required this.surveyQuestionList,required this.storeId,required this.surveyName});

  final List<SurveyQuestionListItem> surveyQuestionList;
  final String storeId;
  final String surveyName;

  @override
  State<SurveyScreen7> createState() => _SurveyScreen7State();
}

class _SurveyScreen7State extends State<SurveyScreen7> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();

  bool isLoadingArea = false;

  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;

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
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.white,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Welcome Kaleem",style: TextStyle(color: AppColors.white),),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("8: ${widget.surveyQuestionList[7].question}"),
                          const SizedBox(height: 5,),
                          CheckboxListTile(
                            title: const Text("Expensive"),
                            value: _isChecked1,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value){
                              setState(() {
                                _isChecked1 = value!;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("No Frequent Visit"),
                            value: _isChecked2,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value){
                              setState(() {
                                _isChecked2 = value!;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text("Other"),
                            value: _isChecked3,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value){
                              setState(() {
                                _isChecked3 = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 5,),
                          if(_isChecked3)
                            TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: "Type here...",
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
                  ),
                  const SizedBox(height: 20,),
                  NormalButton(buttonName: "Finish", onTap: (){
                    setState(() {
                      isLoadingArea = true;
                    });
                    Timer(
                        const Duration(seconds: 3),
                            () {
                              showToastMessage(true, "Survey uploaded successfully");
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const HomeScreen()), (route) => false);
                            });
                  })
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

  uploadQuestion() {
    if(_formKey.currentState!.validate()) {

    }
  }
}
