import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/step_bloc/stepcounter_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';
import 'package:runandearn/views/widget/home_widget.dart/circle_painter.dart';

class StepCountWidget extends StatefulWidget {
  const StepCountWidget({super.key});

  @override
  State<StepCountWidget> createState() => _StepCountWidgetState();
}

class _StepCountWidgetState extends State<StepCountWidget>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(seconds: 1);

  AnimationController? controller;
  Animation<double>? animation;
  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final goalController = TextEditingController();
    final targetCoinController = TextEditingController();
    return Column(
      children: [
        SizedBox(
          height: height * 0.025,
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<StepcounterBloc>(context)
                .add(const OnSetStepsEvent());
            context.read<StepcounterBloc>().add(const OnGetStepsEvent());
            //Modal sheet for update goal
            showModalBottomSheet(
              backgroundColor: Colors.black,
              context: context,
              builder: (_) {
                return BlocProvider(
                  create: (context) => StepcounterBloc(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          BlocBuilder<StepcounterBloc, StepcounterState>(
                            builder: (context, state) {
                              return MyTextField(
                                title: "Enter Goal",
                                prefix: FontAwesomeIcons.personWalking,
                                controller: goalController,
                                textInputType: TextInputType.number,
                                erroMsg: state.goal < 1000
                                    ? "Minimum goal 1000"
                                    : null,
                              );
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          BlocBuilder<StepcounterBloc, StepcounterState>(
                            builder: (context, state) {
                              return MyTextField(
                                title: "Enter Coin target",
                                prefix: FontAwesomeIcons.coins,
                                controller: targetCoinController,
                                textInputType: TextInputType.number,
                                erroMsg: state.goal < 500
                                    ? "Minimum Coin target 500"
                                    : null,
                              );
                            },
                          ),
                          SizedBox(
                            height: height * 0.07,
                          ),
                          BlocBuilder<StepcounterBloc, StepcounterState>(
                            builder: (context, state) {
                              if (state.goal < 1000 && state.targetCoin < 500) {
                                return const SizedBox();
                              }
                              return MyButton(
                                onTap: () {
                                  BlocProvider.of<StepcounterBloc>(context).add(
                                      OnGoalUpdate(
                                          goal: goalController.text != ""
                                              ? int.parse(goalController.text)
                                              : 1000,
                                          targetCoin:
                                              targetCoinController.text != ""
                                                  ? int.parse(
                                                      targetCoinController.text)
                                                  : 500));
                                  BlocProvider.of<StepcounterBloc>(context)
                                      .add(const OnGoalGet());
                                  Navigator.pop(context);
                                },
                                height: height * 0.07,
                                width: width * 0.7,
                                child: const NormText(
                                  title: "Set Goal",
                                  color: Colors.black,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).then(
              (value) {
                BlocProvider.of<StepcounterBloc>(context)
                  ..add(const OnGoalGet())
                  ..add(const OntakePermissionEvent())
                  ..add(OnGetWater())
                  ..add(const OnGetStepsEvent());
              },
             );
          },
          child: Stack(
            children: [
              Center(
                child: CustomPaint(
                  size: Size(height * 0.3,
                      height * 0.35), 
                  painter: CirclePainter(
                    colors: [Colors.black, Colors.black, Colors.black],
                    paintingStyle: PaintingStyle.fill,
                  ),
                ),
              ),
              Center(
                child: CustomPaint(
                  size: Size(height * 0.3,
                      height * 0.35), 
                  painter: CirclePainter(
                    colors: [
                      Colors.orange,
                      Colors.orangeAccent,
                      const Color.fromARGB(255, 155, 209, 7),
                      const Color(0xFFAFEA0D),
                    ],
                    paintingStyle: PaintingStyle.stroke,
                  ),
                ),
              ),
              Center(
                child: CustomPaint(
                  size: Size(height * 0.24,
                      height * 0.35), 
                  painter: CirclePainter(
                    colors: [const Color(0xFF9A9C95), const Color(0xFF9A9C95)],
                    paintingStyle: PaintingStyle.stroke,
                  ),
                ),
              ),
              Positioned(
                top: height * 0.11,
                left: width * 0.2,
                right: width * 0.2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.personWalking,
                      color: Colors.white,
                      size: height * 0.03,
                    ),
                    const MiniText(title: "Today's Steps"),
                    BlocBuilder<StepcounterBloc, StepcounterState>(
                      builder: (context, state) {
                        animation =
                            Tween(begin: 0.0, end: state.step.toDouble())
                                .animate(controller!);
                        return Text(animation!.value.toStringAsFixed(0),
                            style: TextStyle(
                                color: const Color(0xFFAFEA0D),
                                fontSize: height * 0.04,
                                fontWeight: FontWeight.bold,
                                height: 1));
                      },
                    ),
                    BlocBuilder<StepcounterBloc, StepcounterState>(
                      builder: (context, state) {
                        return MiniText(
                          title: "Goal:${state.goal}",
                          fontWeight: FontWeight.bold,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.025,
                    ),
                    SizedBox(
                      height: height * 0.3,
                      width: height * 0.3,
                      child: BlocBuilder<StepcounterBloc, StepcounterState>(
                        builder: (context, state) {
                          animation =
                              Tween(begin: 0.0, end: state.coin.toDouble())
                                  .animate(controller!);
                          controller?.forward();
                          return CircularProgressIndicator(
                            value: state.coin.isNaN || state.targetCoin.isNaN
                                ? 0
                                : animation!.value.toDouble() /
                                    state.targetCoin,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                            strokeWidth: 20.0,
                            strokeCap: StrokeCap.round,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.055,
                    ),
                    SizedBox(
                      height: height * 0.24,
                      width: height * 0.24,
                      child: BlocBuilder<StepcounterBloc, StepcounterState>(
                        builder: (context, state) {
                          animation =
                              Tween(begin: 0.0, end: state.step.toDouble())
                                  .animate(controller!);
                          controller?.forward();
                          return CircularProgressIndicator(
                            value: state.goal.isNaN || state.step.isNaN
                                ? 0
                                : animation!.value.toDouble() / state.goal,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            strokeWidth: 20.0,
                            strokeCap: StrokeCap.round,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.04,
        ),
      ],
    );
  }
}
