import 'package:afriqueen/common/widgets/circular_indicator.dart';
import 'package:afriqueen/features/home/bloc/home_bloc.dart';
import 'package:afriqueen/features/home/bloc/home_event.dart';
import 'package:afriqueen/features/home/bloc/home_state.dart';
import 'package:afriqueen/features/home/screen/data_fetched_screen.dart';
import 'package:afriqueen/features/home/screen/error_home_screen.dart';
import 'package:afriqueen/features/main/repository/home_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HomeRepository(),
      child: BlocProvider(
        create: (context) =>
            HomeBloc(repo: context.read<HomeRepository>())
              ..add(FetchAllExceptCurrentUser()),
        child: BlocBuilder<HomeBloc, HomeState>(
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
        ),
      ),
    );
  }
}
