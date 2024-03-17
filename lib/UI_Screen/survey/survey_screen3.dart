
import 'package:carlsberg/UI_Screen/survey/survey_screen4.dart';
import 'package:carlsberg/utills/app_colors_new.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/response/survey_question_list_response_model.dart';
import '../../utills/user_constants.dart';
import '../../widgets/buttons_widgets.dart';

class SurveyScreen3 extends StatefulWidget {
  const SurveyScreen3({super.key,required this.surveyQuestionList,required this.storeId,required this.surveyName});

  final List<SurveyQuestionListItem> surveyQuestionList;
  final String storeId;
  final String surveyName;

  @override
  State<SurveyScreen3> createState() => _SurveyScreen3State();
}

class _SurveyScreen3State extends State<SurveyScreen3> {

  bool isLoadingArea = false;

  bool _isChecked1 = false;
  bool _isChecked2 = false;

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

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
                              Text("4: ${widget.surveyQuestionList[3].question}"),
                                CheckboxListTile(
                                  title: const Text("Binzagr Sales rep"),
                                  value: _isChecked1,
                                  activeColor: AppColors.primaryColor,
                                  onChanged: (value){
                                    setState(() {
                                      _isChecked1 = value!;
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text("Discount shops"),
                                  value: _isChecked2,
                                  activeColor: AppColors.primaryColor,
                                  onChanged: (value){
                                    setState(() {
                                      _isChecked2 = value!;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),

                        // const Text("6: Did you find a chillers inside the store?"),
                        // const SizedBox(height: 5,),
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   decoration: InputDecoration(
                        //     labelText: "Enter number here...",
                        //     fillColor: Colors.white,
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       borderSide: const BorderSide(
                        //         color: AppColors.primaryColor,
                        //       ),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       borderSide: const BorderSide(
                        //         color: AppColors.primaryColor,
                        //         width: 1.0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 10,),
                        //
                        // const Text("7: Did you find a chillers inside the store?"),
                        // const SizedBox(height: 5,),
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   decoration: InputDecoration(
                        //     labelText: "Enter number here...",
                        //     fillColor: Colors.white,
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       borderSide: const BorderSide(
                        //         color: AppColors.primaryColor,
                        //       ),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       borderSide: const BorderSide(
                        //         color: AppColors.primaryColor,
                        //         width: 1.0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 10,),
                        //
                        // const Text("8: Did you find a chillers inside the store?"),
                        // const SizedBox(height: 5,),
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   decoration: InputDecoration(
                        //     labelText: "Enter number here...",
                        //     fillColor: Colors.white,
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       borderSide: const BorderSide(
                        //         color: AppColors.primaryColor,
                        //       ),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       borderSide: const BorderSide(
                        //         color: AppColors.primaryColor,
                        //         width: 1.0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 5,),

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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SurveyScreen4(storeId: widget.storeId,surveyQuestionList: widget.surveyQuestionList,surveyName: widget.surveyName,)));
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
}
