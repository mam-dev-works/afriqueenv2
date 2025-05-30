//------------ main part of data fetched state-----------------

import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:afriqueen/common/constant/constant_strings.dart';
import 'package:afriqueen/common/widgets/divider.dart';
import 'package:afriqueen/features/home/widget/data_fetched_screen_widgets.dart';
import 'package:afriqueen/features/home/widget/home_widgets.dart';


import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeDataContent extends StatelessWidget {
  const HomeDataContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        //-------------------app bar-------------------
        HomeAppBar(),
        SliverAppBar(
          flexibleSpace: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mylist.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 0,
              childAspectRatio: 1.01,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                return AdvancedAvatar(
                  foregroundDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.floralWhite,
                    shape: BoxShape.circle,
                  ),
                  child: Image(
                    image: AssetImage(AppStrings.logoImage),
                    fit: BoxFit.cover,
                  ),
                  size: 75.r,
                  children: [
                    Positioned(
                      right: -0.4,
                      bottom: -0.4,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          padding: EdgeInsets.zero, // Important
                          constraints:
                              BoxConstraints(), // Remove default constraints
                          iconSize: 25.r,
                          color: AppColors.floralWhite,
                          onPressed: () => showModalBottomSheet(
                            constraints: BoxConstraints(
                              minWidth: double.maxFinite,
                            ),
                            backgroundColor: AppColors.floralWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8.r),
                            ),
                            context: context,
                            builder: (context) => Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10.h,
                              children: [
                                Text(
                                  'Add Story',
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(
                                        color: AppColors.primaryColor,
                                        fontSize: 25.sp,
                                      ),
                                ),
                                CustomDivider(),
                                SizedBox(height: 25.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 10.h,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo_outlined,
                                          size: 50.r,
                                        ),
                                        Text('Add Photo'),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 10.h,
                                      children: [
                                        Icon(
                                          HugeIcons.strokeRoundedVideo01,
                                          size: 50.r,
                                        ),
                                        Text('Add Video'),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25.h),
                              ],
                            ),
                          ),
                          icon: Icon(Icons.add),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return AdvancedAvatar(
                foregroundDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor, width: 2.5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.floralWhite,
                  shape: BoxShape.circle,
                ),
                image: AssetImage(mylist[index - 1]),

                size: 75.r,
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            //-----------User profile grid-------------------------
            child: UserImageGrid(),
          ),
        ),
      ],
    );
  }
}

List<String> mylist = [
  AppStrings.couple,
  AppStrings.couple,
  AppStrings.couple,
  AppStrings.couple,
  AppStrings.couple,
];
