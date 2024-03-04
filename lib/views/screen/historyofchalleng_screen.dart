import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:runandearn/logic/bloc/challenge_bloc/challenge_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/challenge_details_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class HistoryOfChallengeScreen extends StatelessWidget {
  const HistoryOfChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const SubtitleText(
          title: "History",
          color: Colors.white,
        ),
        backgroundColor: Colors.black45,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_left_sharp,
              color: Colors.white,
            )),
      ),
      backgroundColor: const Color.fromARGB(255, 50, 44, 44),
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
              child: NormText(title: "Nothing to show"),
            );
          } else {
            return ListView.builder(
              itemCount: state.challengeData.length,
              itemBuilder: (context, index) {
                final data = state.challengeData;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: height * 0.005),
                  child: Container(
                    height: height * 0.09,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12)),
                    child: data[index].image != null
                        ? ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                            create: (context) => ChallengeBloc()
                                              ..add(OnClaimReward(
                                                  uid: state
                                                      .challengeData[index]
                                                      .uid!)),
                                            child: ChallengeDetailsScreen(
                                                challengeModel:
                                                    state.challengeData[index]),
                                          )));
                            },
                            contentPadding: EdgeInsets.symmetric(
                                vertical: height * 0.003,
                                horizontal: width * 0.04),
                            leading: FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: CachedNetworkImageProvider(
                                data[index].image!,
                              ),
                              fit: BoxFit.fill,
                            ),
                            title: NormText(title: data[index].name!),
                            subtitle: Row(
                              children: [
                                const MiniText(title: "Prize money "),
                                SvgPicture.asset("assets/svg/coin.svg"),
                                MiniText(title: "${data[index].prize}")
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MiniText(
                                  title: data[index].steps.toString(),
                                ),
                                Text(
                                  "Time limit ${data[index].dayLimit} day",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.01),
                                )
                              ],
                            ),
                          )
                        : const ListTile(
                            leading: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            title: NormText(title: "Challenge not available"),
                          ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
