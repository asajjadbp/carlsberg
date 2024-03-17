import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../utills/app_colors_new.dart';

showPopUpForImageUpload(
    BuildContext context,
    XFile imageFile,
    Function onTap) {
  bool isLoading = false;
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Picked Image"),
    content:
    StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: IgnorePointer(
          ignoring: isLoading,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                    child: Image.file(File(imageFile.path))),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          // isGoalsTabActive = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor)),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.redColor,
                          size: 40,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onTap();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor)),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }),
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}