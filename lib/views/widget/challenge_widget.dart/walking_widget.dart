import 'package:flutter/material.dart';
import 'package:runandearn/models/challenge_model.dart';
import 'package:runandearn/views/common/text.dart';

class WalkingWidget extends StatelessWidget {
  const WalkingWidget({super.key, required this.challengeData});
  final ChallengeModel challengeData;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            MiniText(title: challengeData.name!,color: Colors.grey),
            const MiniText(
              title: "Challenge",
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Column(
          children: [
            MiniText(title: challengeData.prize.toString(),color: Colors.grey),
            const MiniText(
              title: "Prize",
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Column(
          children: [
            MiniText(title: challengeData.steps.toString(),color: Colors.grey,),
            const MiniText(
              title: "Steps",
              fontWeight: FontWeight.bold,
            ),
          ],
        )
      ],
    );
  }
}
