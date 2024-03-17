// ignore_for_file: avoid_print

import 'package:carlsberg/Model/request/city_area_request_model.dart';
import 'package:carlsberg/Model/request/start_survey_request_model.dart';
import 'package:carlsberg/utills/alert_dialogue.dart';
import 'package:carlsberg/widgets/toast_message_show.dart';
import 'package:carlsberg/Model/response/city_list_response_model.dart';
import 'package:carlsberg/Model/response/stores_list_response_model.dart';
import 'package:carlsberg/Network/http_manager.dart';
import 'package:carlsberg/utills/app_colors_new.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request/store_list_request_model.dart';
import '../../Model/request/update_sign_board_photo.dart';
import '../../Model/response/city_area_response_model.dart';
import '../../utills/loading_widget.dart';
import '../../utills/user_constants.dart';
import '../../widgets/alert_dialogue.dart';
import '../../widgets/buttons_widgets.dart';
import '../../widgets/handle_location_permission.dart';
import '../../widgets/iamge_compression.dart';
import '../survey/survey_dynamic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  Position? _currentPosition;

  List <CityListItem> cityList = <CityListItem>[];
  List <CityAreaListItem> cityAreaList = <CityAreaListItem>[];
  List <StoresListItem> storesList = <StoresListItem>[];

  late CityListItem cityListItem;
   CityAreaListItem cityAreaListItem = CityAreaListItem(area: "Select Area");

  late SingleValueDropDownController _cityValueDropDownController;
  late SingleValueDropDownController _valueDropDownController;

  bool isLoading = true;
  bool isLoadingArea = false;
  bool isError = false;
  String errorText = "";

  bool isStoreLoaded = false;

  String userId = "";
  String name = "";

  @override
  void initState() {
    // TODO: implement initState
    _valueDropDownController = SingleValueDropDownController();
    _cityValueDropDownController = SingleValueDropDownController();
    setState(() {
      cityAreaList.insert(0,  cityAreaListItem);
    });
    getUserData();
    getCityList();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userId = sharedPreferences.getString(UserConstants().userId)!;
      name = sharedPreferences.getString(UserConstants().userName)!;
    });

  }

  getCityList(){
    setState(() {
      isLoading = true;
    });

    HTTPManager().cityList().then((value) {

      setState(() {

        isError = false;
        errorText = "";

        cityList = value.data!;

        cityList.insert(0,  CityListItem(city: "Select City"));

        _valueDropDownController.dropDownValue = DropDownValueModel(name: cityList[0].city!, value: cityList);

        cityListItem = cityList[0];

        isLoading = false;
      });

    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
      });
      print(e.toString());
    });
  }

  getCityAreaList(String city){
    setState(() {
      isLoadingArea = true;
    });

    HTTPManager().cityAreaList(CityAreaRequestModel(city: city)).then((value) {

      setState(() {

        isError = false;
        errorText = "";

        cityAreaList = value.data!;

        cityAreaList.insert(0,  cityAreaListItem);

        _valueDropDownController.dropDownValue = DropDownValueModel(name: cityAreaList[0].area!, value: cityAreaList);

        isLoadingArea = false;
      });

    }).catchError((e) {
      setState(() {
        isLoadingArea = false;
      });
      print(e.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _valueDropDownController.dispose();
    _cityValueDropDownController.dispose();
    super.dispose();
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
        actions: [
          IconButton(
              onPressed: (){
                showLogoutAlertDialog(context);
          }, icon: const Icon(Icons.logout_rounded,color: AppColors.white,))
        ],
      ),
      body: isLoading ?
      const LoaderWidget()
          : isError ? Container(
        alignment: Alignment.center,
            child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              Text(errorText,style: const TextStyle(color: AppColors.redColor,fontSize: 20),),
              InkWell(
                onTap: () {
                  getCityList();
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
          ) : Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor)
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropDownTextField(
                          textFieldDecoration:const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Select any city",
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                          listPadding: ListPadding(top: 20),
                          clearOption: false,
                          enableSearch: true,
                          controller: _cityValueDropDownController,
                          dropDownList: cityList.map<DropDownValueModel>((CityListItem value) {
                            return DropDownValueModel(
                                value: value,
                                name: value.city!
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              cityListItem = _cityValueDropDownController.dropDownValue!.value;

                              storesList.clear();
                              if(cityAreaList.length>2) {
                                cityAreaList.removeRange(
                                    1, cityAreaList.length);
                              }
                              _valueDropDownController.clearDropDown();
                              cityAreaListItem = cityAreaList[0];

                              if(cityListItem.city != "Select City" ) {
                                getCityAreaList(cityListItem.city!);
                              }
                            });
                          })),
                ),
                const SizedBox(height: 5,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropDownTextField(
                      //listSpace: 20,
                      textFieldDecoration:const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select any area",
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      clearOption: false,
                      // initialValue: _timezoneValue,
                      listPadding: ListPadding(top: 20),
                      enableSearch: true,
                      controller: _valueDropDownController,
                      dropDownList: cityAreaList.map<DropDownValueModel>((CityAreaListItem value) {
                        return DropDownValueModel(
                            value: value,
                            name: value.area!
                        );
                      }).toList(),
                      onChanged: (val) {
                        //print("Value Selected");
                        setState(() {
                          cityAreaListItem = _valueDropDownController.dropDownValue!.value;
                          //  print(_timezoneValue);
                        });
                      },
                    ),
                    // child: DropdownButton<CityAreaListItem>(
                    //     value: cityAreaListItem,
                    //     isExpanded: true,
                    //     items: cityAreaList.map((CityAreaListItem items) {
                    //       return DropdownMenuItem(
                    //         value: items,
                    //         child: Text(items.area!,overflow: TextOverflow.ellipsis,),
                    //       );
                    //     }).toList(),
                    //     onChanged: (value) {
                    //       setState(() {
                    //         cityAreaListItem = value!;
                    //       });

                  ),
                ),
                const SizedBox(height: 5,),
                NormalButton(buttonName: "Load Stores",
                  onTap: () {
                  if(cityListItem.city == "Select City") {
                    showToastMessage(false, "Please Select City from list");
                  } else if(cityAreaListItem.area == "Select Area") {
                    showToastMessage(false, "Please Select Area from list");
                  } else {
                    _getCurrentPositionAndImage();
                  }
                  },),
                const Divider(color: AppColors.primaryColor,),
                const SizedBox(height: 20,),
                Expanded(
                    child:  !isStoreLoaded ? Container() : storesList.isEmpty ? const Center(child: Text("Stores not available in this area"),) : ListView.builder(
                        itemCount: storesList.length,
                        itemBuilder: (context,index) {
                          return Column(
                            children: [
                              Table(
                                  columnWidths: const <int, TableColumnWidth>{
                                    0: IntrinsicColumnWidth(),
                                    1: FlexColumnWidth(),
                                  },
                                  border: TableBorder.all(),
                                  // Allows to add a border decoration around your table
                                  children: [
                                    TableRow(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.all(5),
                                              child: const Text('Store Name')),
                                          Container(
                                              margin: const EdgeInsets.all(5),
                                              child:  Text(storesList[index].storeName!)),
                                        ]),
                                    TableRow(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.all(5),
                                              child: const Text('City')),
                                          Container(
                                              margin: const EdgeInsets.all(5),
                                              child:  Text(storesList[index].city!)),
                                        ]),
                                    TableRow(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.all(5),
                                              child: const Text('Area')),
                                          Container(
                                              margin: const EdgeInsets.all(5),
                                              child:  Text(storesList[index].area!)),
                                        ]),
                                    TableRow(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.all(5),
                                              child: const Text('Location')),
                                          Container(
                                              margin: const EdgeInsets.all(5),
                                              child:  Text(storesList[index].location!)),
                                        ]),
                                  ]
                              ),
                              const SizedBox(height: 5,),
                              NormalButton(buttonName:storesList[index].visitStatus == 0 ? "Start Survey" : "Resume Survey",
                                onTap: () {
                                if(storesList[index].visitStatus == 0) {
                                  showSurveyAlertDialog(context, index, () {
                                    pickedImage(index);
                                  });
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SurveyDynamicScreen(storeId:storesList[index].id.toString(),surveyName: storesList[index].storeName!,))).then((value) {
                                    String location = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
                                    loadStoreList(location);
                                  });
                                }
                                },),
                              const SizedBox(height: 20,),
                            ],
                          );
                        })

                ),
              ],
            ),
          ),
          if(isLoadingArea)
            const LoaderWidget()
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

      print("Current Position");
      print(location);

      loadStoreList(location);

      // pickedImage(journeyResponseListItem,_currentPosition,index);
    }).catchError((e) {
      debugPrint(e);

    });
  }

  loadStoreList(String location) {
    setState(() {
      isLoadingArea = true;
      isStoreLoaded = true;
    });

    HTTPManager().storesList(StoresListRequestModel(city: cityListItem.city,area: cityAreaListItem.area,location: location)).then((value) {

      setState(() {

        storesList = value.data!;

        isLoadingArea = false;
      });

      if(storesList.isEmpty) {
        showToastMessage(true, "No Stores found in this location");
      } else {
        showToastMessage(true, "Available stores in this area");
      }

    }).catchError((e) {
      print(e.toString());
      setState(() {
        isLoadingArea = false;
      });
      showToastMessage(false, e.toString());
    });
  }

  Future<void> pickedImage(int index) async {

    image = await picker.pickImage(
        source: ImageSource.camera);
    if (image == null) {
    } else {
      String location = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
      compressedImage = await compressAndGetFile(image!,"start_survey_image");
      showUploadOption(index,location);
    }
  }

  showUploadOption(int index,String location){
    showPopUpForImageUpload(context,
        compressedImage!,
            (){
          updateSingBoardPhoto(index,location);
        });
  }

  updateSingBoardPhoto(int index,String location)  {
    setState(() {
      isLoadingArea = true;
    });

    HTTPManager().updateSignBoardPhoto(UpdateSignBoardPhotoRequestModel(userLoc: location,id: storesList[index].id.toString(),), compressedImage!).then((value) {
      setState(() {
        isLoadingArea = false;
      });

      startSurvey(index);
      showToastMessage(true, "Image updated successfully");

    }).catchError((e) {
      setState(() {
        isLoadingArea = false;
      });
      showToastMessage(false, e.toString());
    });
  }

  startSurvey(int index){
    setState(() {
      isLoadingArea = true;
    });
    print(userId);
    HTTPManager().startSurvey(StartSurveyRequestModel(id: storesList[index].id.toString(),userId: userId)).then((value) {
      setState(() {
        isLoadingArea = false;
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SurveyDynamicScreen(storeId:storesList[index].id.toString(),surveyName: storesList[index].storeName!,))).then((value) {
        String location = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
        loadStoreList(location);
      });
      showToastMessage(true, "Survey Started Successfully");
    }).catchError((e) {
      setState(() {
        isLoadingArea = false;
      });
      showToastMessage(false, e.toString());
    });
  }

}

