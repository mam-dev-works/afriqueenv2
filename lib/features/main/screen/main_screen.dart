import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:afriqueen/common/localization/enums/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },

            child: Text("Log out"),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.floralWhite,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: GNav(
              rippleColor: AppColors.grey.withValues(alpha: 0.2),
              hoverColor: AppColors.grey.withValues(alpha: 0.2),
              gap: 8.w,
              activeColor: AppColors.primaryColor,
              iconSize: 24.r,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.grey.withValues(alpha: 0.2),
              color: Colors.black,
              tabs: [
                GButton(
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  gap: 5.w,
                  icon: LineIcons.home,
                  text: EnumLocale.home.name.tr,
                ),
                GButton(
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  gap: 5.w,
                  icon: LineIcons.heart,
                  text: EnumLocale.likes.name.tr,
                ),
                GButton(
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  gap: 5.w,
                  icon: LineIcons.search,
                  text: EnumLocale.search.name.tr,
                ),
                GButton(
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  gap: 5.w,
                  icon: LineIcons.user,
                  text: EnumLocale.profile.name.tr,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
