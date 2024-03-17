

import 'package:carlsberg/utills/user_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionState {

  late SharedPreferences _sharedPreferences;

  setUserSession(bool isLoggedIn,String userId,String userName,String userEmail) async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setBool(UserConstants().userLoggedIn,isLoggedIn);
    _sharedPreferences.setString(UserConstants().userId,userId);
    _sharedPreferences.setString(UserConstants().userName,userName);
    _sharedPreferences.setString(UserConstants().userEmail,userEmail);

  }

  clearUserSession() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setBool(UserConstants().userLoggedIn,false);
    _sharedPreferences.remove(UserConstants().userId);
    _sharedPreferences.remove(UserConstants().userName);
    _sharedPreferences.remove(UserConstants().userEmail);

  }
}