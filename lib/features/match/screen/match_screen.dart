import 'package:afriqueen/common/widgets/circular_indicator.dart';
import 'package:afriqueen/features/match/bloc/match_bloc.dart';
import 'package:afriqueen/features/match/bloc/match_state.dart';
import 'package:afriqueen/features/match/screen/match_card_screen.dart';
import 'package:afriqueen/features/match/screen/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(builder: (context, state) {
      return switch (state) {
        // ----------Initial state ----------------
        Loading() => CustomCircularIndicator(),
        //----------------------Error Occure------------------------------
        Error() => ErrorWhileFetching(),
        MatchDataEmpty() => ErrorWhileFetching(),
        //----------------------Swipe card------------------------------
        _ => MatchCardScreen(),
      };
    });
  }
}
