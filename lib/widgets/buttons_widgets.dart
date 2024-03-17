import 'package:flutter/material.dart';

import '../utills/app_colors_new.dart';

class NormalButton extends StatefulWidget {
  const NormalButton({super.key,required this.buttonName,required this.onTap});
  final String buttonName;
  final Function onTap;
  @override
  State<NormalButton> createState() => _NormalButtonState();
}

class _NormalButtonState extends State<NormalButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: AppColors.primaryColor,
        child: SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child:  Center(
            child: Text(widget.buttonName,style:const TextStyle(color: AppColors.white),),
          ),
        ),
      ),
    );
  }
}

class NextPreviousButtons extends StatefulWidget {
  const NextPreviousButtons({super.key,required this.buttonNextName,required this.nextOnTap,required this.buttonPrevName,required this.prevOnTap,required this.isNextVisible,required this.isPreviousVisible});
  final String buttonNextName;
  final Function nextOnTap;

  final String buttonPrevName;
  final Function prevOnTap;
  final bool isNextVisible;
  final bool isPreviousVisible;

  @override
  State<NextPreviousButtons> createState() => _NextPreviousButtonsState();
}

class _NextPreviousButtonsState extends State<NextPreviousButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Visibility(
            visible: widget.isPreviousVisible,
            child: InkWell(
              onTap: () {
                widget.prevOnTap();
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: AppColors.primaryColor,
                child: SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child:  Center(
                    child: Text(widget.buttonPrevName,style:const TextStyle(color: AppColors.white),),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 40,),
        Expanded(
          child: Visibility(
            visible: widget.isNextVisible,
            child: InkWell(
              onTap: () {
                widget.nextOnTap();
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: AppColors.primaryColor,
                child: SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child:  Center(
                    child: Text(widget.buttonNextName,style:const TextStyle(color: AppColors.white),),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

