import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:runandearn/logic/bloc/challenge_bloc/challenge_bloc.dart';
import 'package:runandearn/models/challenge_model.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({super.key, required this.challengeModel});
  final ChallengeModel challengeModel;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const SubtitleText(
          title: "Challenge Details",
          color: Colors.white,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left_sharp),
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF232323),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: double.infinity,
                  child: CachedNetworkImage(imageUrl:challengeModel.image!)),
              SizedBox(
                height: height * 0.02,
              ),
              NormText(
                title: challengeModel.name!,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                children: [
                  const NormText(title: "Prize  "),
                  SvgPicture.asset("assets/svg/coin.svg"),
                  NormText(title: "${challengeModel.prize}")
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              MiniText(
                title: "Challenge steps ${challengeModel.steps}",
              ),
              SizedBox(
                height: height * 0.01,
              ),
              MiniText(
                title: "Complete challenge within ${challengeModel.dayLimit} day",
              ),
              SizedBox(
                height: height * 0.03,
              ),
              MiniText(
                title: challengeModel.description!,
                color: Colors.grey,
              ),
              SizedBox(
                height: height * 0.08,
              ),
              Center(child: BlocBuilder<ChallengeBloc, ChallengeState>(
                builder: (context, state) {
                  return MyButton(
                      onTap: () {
                        state.isClaimReward
                            ? BlocProvider.of<ChallengeBloc>(context)
                                .add(OnRewardUser(uid: challengeModel.uid!))
                            : state.isChallengeAccepted ? null : BlocProvider.of<ChallengeBloc>(context).add(
                                OnAcceptChallenge(
                                    steps: challengeModel.steps!,
                                    prize: challengeModel.prize!,
                                    uid: challengeModel.uid!));
                      },
                      height: height * 0.07,
                      width: width * 0.8,
                      child: state.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : NormText(
                              title: state.isClaimReward
                                  ? state.isRewarded ? "Reward Claimed" : "Claim Reward"
                                  : state.isChallengeAccepted ? "Joined" : "Join Now",
                              color: Colors.black,
                              fontWeight: FontWeight.bold));
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
