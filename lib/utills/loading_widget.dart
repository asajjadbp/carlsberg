import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'app_colors_new.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Center(child:  SpinKitPulsingGrid(
      color: AppColors.primaryColor,
      duration: Duration(milliseconds: 600),
    ));
  }
}
