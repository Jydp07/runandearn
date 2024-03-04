import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/step_bloc/stepcounter_bloc.dart';
import 'package:runandearn/views/common/text.dart';

class DataWidget extends StatelessWidget {
  const DataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<StepcounterBloc, StepcounterState>(
                builder: (context, state) {
                  return TitleText(
                    title: state.calories.toStringAsFixed(1),
                  );
                },
              ),
              const MiniText(
                title: "Calories",
                color: Color(0xFF9A9C95),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<StepcounterBloc, StepcounterState>(
                builder: (context, state) {
                  int hours = state.time ~/ 3600;
                  int minutes = (state.time % 3600) ~/ 60;
                  return TitleText(
                    title: "${hours}h ${minutes}m",
                  );
                },
              ),
              const MiniText(
                title: "Active Time",
                color: Color(0xFF9A9C95),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<StepcounterBloc, StepcounterState>(
                builder: (context, state) {
                  return TitleText(
                    title: state.kilometer.toStringAsFixed(1),
                  );
                },
              ),
              const MiniText(
                title: "Km",
                color: Color(0xFF9A9C95),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
