import 'package:afriqueen/common/widgets/circular_indicator.dart';
import 'package:afriqueen/features/profile/bloc/profile_bloc.dart';
import 'package:afriqueen/features/profile/bloc/profile_event.dart';
import 'package:afriqueen/features/profile/bloc/profile_state.dart';
import 'package:afriqueen/features/profile/screen/error_screen.dart';
import 'package:afriqueen/features/profile/screen/fetch_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        //----------Loading--------------------
        if (state is Loading) {
          return CustomCircularIndicator();
        } else if (state is Error) {
          //----------------- Get Error--------------------
          return ProfileErrorContent();
        } else {
          //---------------After Data Fetched--------------------
          return ProfileDataContent();
        }
      },
    );
  }
}
