import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/step_bloc/stepcounter_bloc.dart';
import 'package:runandearn/views/common/text.dart';

class WeeklyStepScreen extends StatelessWidget {
  const WeeklyStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const SubtitleText(
          title: "Last 7 Days Steps",
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
            )),
      ),
      backgroundColor: const Color(0xFF232323),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.5,
            width: double.infinity,
            child: BlocBuilder<StepcounterBloc, StepcounterState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white,),
                  );
                } else if (state.error.isNotEmpty) {
                  return Center(
                    child: MiniText(title: state.error),
                  );
                }else if(state.lastSevenDaysStep.isEmpty){
                  return const Center(child: NormText(title: "You haven't any data"),);
                }
                return BarChart(
                  swapAnimationDuration: const Duration(milliseconds: 150),
                  swapAnimationCurve: Curves.linear,
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return MiniText(
                                title: state.lastSevenDaysStep[value.toInt()]
                                        .dateTime
                                        ?.substring(0, 3) ??
                                    "");
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    // borderData: FlBorderData(show: true),
                    barGroups: List.generate(
                      state.lastSevenDaysStep.length,
                      (index) => BarChartGroupData(x: index, barRods: [
                        BarChartRodData(
                          toY: state.lastSevenDaysStep[index].steps!.toDouble(),
                          color: Colors.white,
                          width: width * 0.07,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        )
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
