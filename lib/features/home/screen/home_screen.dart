import 'package:afriqueen/common/widgets/circular_indicator.dart';
import 'package:afriqueen/features/home/bloc/home_bloc.dart';
import 'package:afriqueen/features/home/bloc/home_event.dart';
import 'package:afriqueen/features/home/bloc/home_state.dart';
import 'package:afriqueen/features/home/screen/data_fetched_screen.dart';
import 'package:afriqueen/features/home/screen/error_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchAllExceptCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        //----------Loading--------------------
        if (state is Loading) {
          return CustomCircularIndicator();
        } else if (state is Error) {
          //----------------- Get Error--------------------
          return HomeErrorContent();
        } else {
          //---------------After Data Fetched--------------------
          return HomeDataContent();
        }
      },
    );
  }
}
