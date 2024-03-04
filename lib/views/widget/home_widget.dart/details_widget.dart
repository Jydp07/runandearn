import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/step_bloc/stepcounter_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/monthly_step_screen.dart';
import 'package:runandearn/views/screen/weekly_step_screen.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () {},
                child: const NormText(
                  title: "Day",
                  color: Colors.grey,
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) => StepcounterBloc()..add(const OnGetLastSevenDayStep()),
                                child: const WeeklyStepScreen(),
                              )));
                },
                child: const NormText(
                  title: "Week",
                  color: Colors.grey,
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) => StepcounterBloc()..add(const OnGetLastMonthStep()),
                                child: const MonthlyStepScreen(),
                              )));
                },
                child: const NormText(
                  title: "Month",
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}
