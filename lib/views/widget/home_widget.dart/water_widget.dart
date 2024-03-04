import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/step_bloc/stepcounter_bloc.dart';
import 'package:runandearn/services/notification_service.dart';
import 'package:runandearn/views/common/text.dart';

class WaterWidget extends StatefulWidget {
  const WaterWidget({super.key});

  @override
  State<WaterWidget> createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<WaterWidget> {
  @override
  void initState() {
    NotificationService.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TitleText(title: "Water task"),
                    BlocBuilder<StepcounterBloc, StepcounterState>(
                      builder: (context, state) {
                        if (state.water == 8) {
                          return OutlinedButton(
                              onPressed: () {},
                              child: const MiniText(title: "Complete"));
                        }
                        return IconButton.outlined(
                            onPressed: () async {
                              BlocProvider.of<StepcounterBloc>(context)
                                  .add(OnSetWater());
                              // BlocProvider.of<StepcounterBloc>(context)
                              //     .add(OnGetWater());
                              if (state.water < 8) {
                                NotificationService.showNotification(
                                  id: 101,
                                  title: "Drink 1 glass water",
                                  body:
                                      "You have to drink 8 glass of water per day and ${8 - (state.water + 1)} glass water is remaining.",
                                  dateTime: DateTime.now().add(
                                    const Duration(hours: 1),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ));
                      },
                    )
                  ],
                ),
                const MiniText(
                  title: "Your water task is almost complete",
                  color: Colors.grey,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                BlocBuilder<StepcounterBloc, StepcounterState>(
                  builder: (context, state) {
                    return LinearProgressIndicator(
                      color: const Color(0xFFAFEA0D),
                      value: state.water / 8,
                      semanticsValue: "8",
                      borderRadius: BorderRadius.circular(8),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
