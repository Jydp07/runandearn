import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/challenge_bloc/challenge_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/challenge_details_screen.dart';
import 'package:runandearn/views/screen/historyofchalleng_screen.dart';
import 'package:runandearn/views/widget/challenge_widget.dart/walking_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChallengeBloc()..add(const OnGetChallengeData()),
      child: const _ChallengeScreen(),
    );
  }
}

class _ChallengeScreen extends StatelessWidget {
  const _ChallengeScreen();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xFF232323),
        appBar: AppBar(
          title: const TitleText(title: "Challenges"),
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 4,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) => ChallengeBloc()
                                  ..add(const OnGetUserChallenge()),
                                child: const HistoryOfChallengeScreen(),
                              )));
                },
                icon: const Icon(
                  FontAwesomeIcons.newspaper,
                  color: Colors.white,
                ))
          ],
        ),
        body: BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (state.error.isNotEmpty) {
              return Center(
                child: NormText(title: state.error),
              );
            } else if (state.challengeData.isEmpty) {
              return const Center(
                child: NormText(title: "No challenges available"),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: state.challengeData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: height * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: width * 0.95,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => BlocProvider(
                                                        create: (context) =>
                                                            ChallengeBloc()
                                                              ..add(OnClaimReward(
                                                                  uid: state
                                                                      .challengeData[
                                                                          index]
                                                                      .uid!)),
                                                        child:
                                                            ChallengeDetailsScreen(
                                                          challengeModel: state
                                                                  .challengeData[
                                                              index],
                                                        ),
                                                      )));
                                        },
                                        child: SizedBox(
                                          height: height * 0.2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: state
                                                  .challengeData[index].image!,
                                                  placeholder: (context, url) => Image.memory(kTransparentImage),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: WalkingWidget(
                                        challengeData:
                                            state.challengeData[index],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const NormText(title: "Running Challenges"),
                    //     TextButton.icon(
                    //       onPressed: () {},
                    //       icon: const Icon(
                    //         Icons.group,
                    //         color: Colors.grey,
                    //       ),
                    //       label: const MiniText(title: "500 started",color: Colors.grey,),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(width: width * 0.95, child: const RunningWidget()),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const NormText(title: "Cycling Challenges"),
                    //     TextButton.icon(
                    //       onPressed: () {},
                    //       icon: const Icon(
                    //         Icons.group,
                    //         color: Colors.grey,
                    //       ),
                    //       label: const MiniText(title: "500 started",color: Colors.grey,),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(width: width * 0.95, child: const CyclingWidget()),
                  ],
                ),
              );
            }
          },
        ));
  }
}
