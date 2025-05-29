import 'package:afriqueen/common/widgets/steps.dart';

import 'package:afriqueen/features/create_profile/widget/discription_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscriptionScreen extends StatelessWidget {
  DiscriptionScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.h,
                children: [
                  //---------------Stepper to show in which step they are in profile creation------------------------
                  const CustomSteps(currentStep: 6),
                  //-------------Title Text-----------------------
                  const DiscriptionTitle(),
                  //------------------Body text-------------------------
                  const DiscriptionBody(),

                  SizedBox(height: 20.h),

                  //------------------------Textfield for user input for discription------------------------
                  const TextFieldForDiscription(),
                  //------------Next Button--------------------------------------
                  SizedBox(height: 40.h),
                  DiscriptionNextButton(formKey: _formKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
