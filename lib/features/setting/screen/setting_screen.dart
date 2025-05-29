import 'package:afriqueen/common/widgets/divider.dart';
import 'package:afriqueen/features/setting/widget/setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //--------------------------------- app Bar---------------------------
          SettingAppBar(),
          // -------------Body--------------------------
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                //---------------------Logout-------------------------
                LogoutListTile(),
                //-------------divider----------------
                CustomDivider(),
                //----------------------Notification ----------------------------
                NotificationListTile(),
                //-------------divider----------------
                CustomDivider(),
                //------------------Privacy Settings------------------------------
                PrivacyListTile(),
                //-------------divider----------------
                CustomDivider(),
                //-------------------Help center-----------------------
                HelpListTile(),
                //-------------divider----------------
                CustomDivider(),
                //-----------------Change Language--------------------
                LanguageListTile(),
                //-------------divider----------------
                CustomDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
