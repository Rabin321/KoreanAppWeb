import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';

class EcoButton extends StatelessWidget {
  String? title;
  bool? isLoginButton;
  VoidCallback? onPress;
  bool? isLoading;

  EcoButton(
      {Key? key,
      this.title,
      this.isLoading = false,
      this.isLoginButton = false,
      this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 10.h,
        margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
        // width: 55.w,
        decoration: BoxDecoration(
          // color: isLoginButton == false ? Colors.white : Colors.black,
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isLoginButton == false ? Colors.black : Colors.black),
        ),
        child: Stack(
          children: [
            Visibility(
              visible: isLoading! ? false : true,
              child: Center(
                child: Text(
                  // "buttonn",
                  title ?? "button",
                  style: const TextStyle(
                      color: AppColors.white,
                      // isLoginButton == false ? Colors.black : Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
            Visibility(
              visible: isLoading!,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
