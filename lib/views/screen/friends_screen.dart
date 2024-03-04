import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:runandearn/logic/bloc/friends_bloc/friends_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/invite_friends_screen.dart';
import 'package:runandearn/views/screen/leaderboard_screen.dart';
import 'package:shimmer/shimmer.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsBloc()..add(const OnGetFriendsData()),
      child: const _FriendsScreen(),
    );
  }
}

class _FriendsScreen extends StatelessWidget {
  const _FriendsScreen();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const NormText(title: "Friends"),
        actions: [
          OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider(
                              create: (context) =>
                                  FriendsBloc()..add(const OnGetFreindsStep()),
                              child: const LeaderBoardScreen(),
                            )));
              },
              style: ButtonStyle(
                side: MaterialStateBorderSide.resolveWith(
                    (states) => const BorderSide(color: Color(0xFFAFEA0D))),
              ),
              child: const Text(
                "LEADERBOARD",
                style: TextStyle(color: Color(0xFFAFEA0D), fontSize: 10),
              )),
          SizedBox(
            width: width * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyButton(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider(
                            create: (context) => FriendsBloc()
                              ..add(GetContactEvent())
                              ..add(OnGetAllFriends()),
                            child: const InviteFriendsScreen(),
                          )));
                },
                height: height * 0.04,
                width: width * 0.2,
                child: const MiniText(
                  title: "Invite",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
      body: BlocBuilder<FriendsBloc, FriendsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                        leading: Shimmer.fromColors(
                          enabled: true,
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: const CircleAvatar(
                            child: Text(""),
                          ),
                        ),
                        title: Shimmer.fromColors(
                          enabled: true,
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.015,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.007,
                              ),
                              Container(
                                height: height * 0.01,
                                width: width * 0.15,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Shimmer.fromColors(
                          enabled: true,
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: MyButton(
                              onTap: () {},
                              height: height * 0.035,
                              width: width * 0.2,
                              child: const MiniText(
                                title: "Requested",
                                color: Colors.black,
                              )),
                        )),
                  );
                });
          } else if (state.friendsRequest.isEmpty) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/svg/invite.svg"),
                SizedBox(
                  height: height * 0.07,
                ),
                const SubtitleText(
                  title: "Invite your friend",
                  color: Colors.white,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                const Text(
                  "You can earn upto ¢20 when you",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "invite a friends",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                MyButton(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) => FriendsBloc()
                                  ..add(GetContactEvent())
                                  ..add(OnGetAllFriends()),
                                child: const InviteFriendsScreen(),
                              )));
                    },
                    height: height * 0.07,
                    width: width * 0.8,
                    child: const NormText(
                      title: "Invite Friends",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<FriendsBloc>(context)
                    .add(const OnGetFriendsData());
              },
              child: ListView.builder(
                  itemCount: state.friendsRequest.length,
                  itemBuilder: (context, index) {
                    final firstChar =
                        state.friends[index].name?.substring(0, 1);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          ListTile(
                              leading: CircleAvatar(
                                child: Text(firstChar!),
                              ),
                              title:
                                  MiniText(title: state.friends[index].name!),
                              trailing: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (state.friendsRequest[index].isFriends ==
                                      "FriendStatus.sent") {
                                    return MyButton(
                                        onTap: () {
                                          BlocProvider.of<FriendsBloc>(context)
                                              .add(OnChangeFriendRequestStatus(
                                                  userId: state
                                                      .friendsRequest[index]
                                                      .uid!,
                                                  status:
                                                      "FriendStatus.nothing"));
                                          BlocProvider.of<FriendsBloc>(context).add(OnGetFriendsDataAfter());
                                        },
                                        height: height * 0.035,
                                        width: width * 0.3,
                                        child: const MiniText(
                                          title: "Requested",
                                          color: Colors.black,
                                        ));
                                  } else if (state
                                          .friendsRequest[index].isFriends ==
                                      "FriendStatus.request") {
                                    return SizedBox(
                                      width: width * 0.28,
                                      child: Row(
                                        children: [
                                          IconButton.outlined(
                                              onPressed: () {
                                                BlocProvider.of<FriendsBloc>(
                                                        context)
                                                    .add(OnChangeFriendRequestStatus(
                                                        userId: state
                                                            .friendsRequest[
                                                                index]
                                                            .uid!,
                                                        status:
                                                            "FriendStatus.accept"));
                                                BlocProvider.of<FriendsBloc>(
                                                        context)
                                                    .add(
                                                        OnGetFriendsDataAfter());
                                              },
                                              icon: const Icon(
                                                Icons.done,
                                                color: Color(0xFFAFEA0D),
                                              )),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          IconButton.outlined(
                                              onPressed: () {
                                                BlocProvider.of<FriendsBloc>(
                                                        context)
                                                    .add(OnChangeFriendRequestStatus(
                                                        userId: state
                                                            .friendsRequest[
                                                                index]
                                                            .uid!,
                                                        status:
                                                            "FriendStatus.denied"));
                                                BlocProvider.of<FriendsBloc>(
                                                        context)
                                                    .add(
                                                        OnGetFriendsDataAfter());
                                              },
                                              icon: const Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                    );
                                  } else if (state
                                          .friendsRequest[index].isFriends ==
                                      "FriendStatus.accept") {
                                    return MyButton(
                                        onTap: () {},
                                        height: height * 0.035,
                                        width: width * 0.3,
                                        child: const MiniText(
                                          title: "Friends",
                                          color: Colors.black,
                                        ));
                                  } else if (state
                                          .friendsRequest[index].isFriends ==
                                      "FriendStatus.denied") {
                                    return MyButton(
                                        onTap: () {},
                                        height: height * 0.035,
                                        width: width * 0.3,
                                        child: const MiniText(
                                          title: "Denieded",
                                          color: Colors.black,
                                        ));
                                  }else if (state
                                          .friendsRequest[index].isFriends ==
                                      "FriendStatus.nothing") {
                                    return MyButton(
                                        onTap: () {
                                          BlocProvider.of<FriendsBloc>(
                                                        context)
                                                    .add(OnChangeFriendRequestStatus(
                                                        userId: state
                                                            .friendsRequest[
                                                                index]
                                                            .uid!,
                                                        status:
                                                            "FriendStatus.sent"));
                                                BlocProvider.of<FriendsBloc>(
                                                        context)
                                                    .add(
                                                        OnGetFriendsDataAfter());
                                        },
                                        height: height * 0.035,
                                        width: width * 0.3,
                                        child: const MiniText(
                                          title: "Follow",
                                          color: Colors.black,
                                        ));
                                  }
                                  return const SizedBox();
                                },
                              )),
                          const Divider(
                            thickness: 1,
                            height: 0.01,
                            color: Colors.black26,
                          )
                        ],
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
