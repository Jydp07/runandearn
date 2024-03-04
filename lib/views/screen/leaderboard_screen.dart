import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/friends_bloc/friends_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:shimmer/shimmer.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left_rounded),
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        title: const SubtitleText(
          title: "Leaderboard",
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF232323),
      body: BlocBuilder<FriendsBloc, FriendsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color: Colors.black,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: ListTile(
                          title: Container(
                            height: height * 0.025,
                            width: width * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          subtitle: Container(
                            height: height*0.015,
                            width: width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.grey,borderRadius: BorderRadius.circular(10)),
                          ),
                          contentPadding: EdgeInsets.all(height * 0.01),
                          leading: CircleAvatar(
                              radius: height * 0.03, child: const Text("")),
                        ),
                      ),
                    ),
                  );
                });
          } else if (state.error.isNotEmpty) {
            return Center(
              child: MiniText(title: state.error),
            );
          } else if (state.friends.isEmpty) {
            return const Center(
              child: MiniText(title: "You haven't friends yet"),
            );
          } else {
            return ListView.builder(
                itemCount: state.friends.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color: Colors.black,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(height * 0.01),
                        leading: CircleAvatar(
                          radius: height * 0.03,
                          child: Text("${index + 1}"),
                        ),
                        title: NormText(title: state.friends[index].name!),
                        subtitle: MiniText(
                            title:
                                "${state.friendsRequest[index].steps?.toString() ?? "0"} steps today"),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
