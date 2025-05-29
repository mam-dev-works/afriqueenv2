import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:afriqueen/features/profile/widget/profile_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

//---------------Main Container--------------------
class MainContainer extends StatelessWidget {
  const MainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite.w,
      decoration: BoxDecoration(
        color: AppColors.floralWhite,
        borderRadius: BorderRadius.circular(12.r),
        shape: BoxShape.rectangle,
        border: Border(
          top: BorderSide.none,
          left: BorderSide(color: AppColors.grey, width: 1.w),
          right: BorderSide(color: AppColors.grey, width: 1.w),
          bottom: BorderSide(color: AppColors.grey, width: 1.w),
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          //---------------User Profile Image--------------------
          ProfileImage(),
          //-----------Account age----------------------
          UserSeniority(),

          //---------------User Profile Details--------------------
          UserDetails(),

          //------------------------------ user interests------------------------------
          UserInterestsList(),
          SizedBox(height: 10.h),
          DiscriptionText(),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
