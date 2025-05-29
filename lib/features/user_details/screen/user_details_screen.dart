// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:afriqueen/common/widgets/seniority.dart';
import 'package:afriqueen/features/user_details/widgets/user_details_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:afriqueen/common/constant/constant_colors.dart';

import 'package:afriqueen/features/home/model/home_model.dart';

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen({super.key, required this.data});
  final HomeModel data;
  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _isScrollingUp = false;
  double _previousOffset = 0;

  @override
  Widget build(BuildContext context) {
    final date = Seniority.formatJoinedTime(widget.data.createdDate);
    final hasValidUrl =
        widget.data.imgURL.isNotEmpty &&
        Uri.tryParse(widget.data.imgURL)?.hasAbsolutePath == true;
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final currentOffset = notification.metrics.pixels;

            setState(() {
              _isScrollingUp = currentOffset < _previousOffset;
              _previousOffset = currentOffset;
            });
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            //----------------------AppBar------------------------------
            UserDetailsAppBar(
              isScrollingUp: _isScrollingUp,
              name: widget.data.pseudo,
            ),
            SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //---------------container------------------
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border(
                          left: BorderSide(color: AppColors.grey, width: 1.w),
                          right: BorderSide(color: AppColors.grey, width: 1.w),
                          bottom: BorderSide(color: AppColors.grey, width: 1.w),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.h,
                        children: [
                          //------------Image and status---------------------------
                          StackWidget(hasValidUrl: hasValidUrl, widget: widget),
                          SizedBox(height: 10.h),
                          //-------------age of account-----------------------
                          CreatedDate(date: date),
                          //-----------------RowList of Button------------------------
                          ButtonList(mode: widget.data,),
                          //------User  Details like name , age city------------------------
                          UserDetails(widget: widget),
                         
                          // Interests grid-----------------------
                          Interests(widget: widget),
                          SizedBox(height: 10),
                          //---------User discription-----------------------
                          Discription(widget: widget),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

