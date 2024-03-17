import 'package:carlsberg/utills/user_session.dart';
import 'package:flutter/material.dart';

import '../UI_Screen/login/login_screen.dart';

showSurveyAlertDialog(BuildContext context,int index,Function onTap) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed:  () {
      onTap();
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Survey"),
    content: const Text("Would you like to start your survey?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


showFinishVisitAlertDialog(BuildContext context,int index,Function onTap) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("No"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Yes"),
    onPressed:  () {
      onTap();
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Survey"),
    content: const Text("Are you sure you want to finish this survey?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLogoutAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("No"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Yes"),
    onPressed:  () {
      Navigator.of(context).pop();
      UserSessionState().clearUserSession();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()), (route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Logout"),
    content: const Text("Are you sure you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}