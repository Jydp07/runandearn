import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/friends_bloc/friends_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';

class InviteRewardWidget extends StatelessWidget {
  const InviteRewardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        children: [
          Container(
            //height: height*0.1,
            width: width * 0.9,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white,width: 0.08)
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(height * 0.04),
                  child: const Center(
                    child: TitleText(
                      title: "20",
                    ),
                  ),
                ),
                const VerticalDivider(
                  thickness: 1,
                  color: Colors.white,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MiniText(title: "Invite your friends & Get Reward"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0),
                      child: MyButton(
                        onTap: () {
                          BlocProvider.of<FriendsBloc>(context).add(const OnReferFriend());
                        },
                        height: height * 0.04,
                        width: width * 0.4,
                        child: const Text(
                          "Invite",
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
