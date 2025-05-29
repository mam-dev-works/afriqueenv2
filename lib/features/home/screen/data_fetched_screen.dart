//------------ main part of data fetched state-----------------

import 'package:afriqueen/features/home/widget/data_fetched_screen_widgets.dart';
import 'package:afriqueen/features/home/widget/home_widgets.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDataContent extends StatelessWidget {
  const HomeDataContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        //-------------------app bar-------------------
        HomeAppBar(),
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
