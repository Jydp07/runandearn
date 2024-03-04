import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/friends_bloc/friends_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:shimmer/shimmer.dart';

class AllFriendsWidget extends StatelessWidget {
  const AllFriendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const _AllFriendsSkelaton();
        } else if (state.error.isNotEmpty) {
          return Center(
            child: NormText(title: state.error),
          );
        } else if (state.friendsRequest.isEmpty) {
          return const SizedBox();
        } else {
          return ListView.builder(
            itemCount: state.friendsRequest.length,
            itemBuilder: ((context, index) {
              final user = state.friendsRequest[index];
              final firstChar = user.name?.substring(0, 1);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    ListTile(
                        leading: CircleAvatar(
                          child: Text(firstChar ?? ""),
                        ),
                        title: MiniText(title: user.name ?? ""),
                        trailing: MyButton(
                            onTap: () {
                              BlocProvider.of<FriendsBloc>(context).add(
                                  OnSentInviteEvent(
                                      state.friendsRequest[index].uid!));
                              BlocProvider.of<FriendsBloc>(context).add(OnGetAllFriends());
                              BlocProvider.of<FriendsBloc>(context).add(GetContactEvent());
                            },
                            height: height * 0.035,
                            width: width * 0.2,
                            child: const MiniText(
                              title: "Follow",
                              color: Colors.black,
                            ))),
                            Divider(thickness: 1,color: Colors.black26,height: height*0.01,)
                  ],
                ),
              );
            }),
          );
        }
      },
    );
  }
}

class _AllFriendsSkelaton extends StatelessWidget {
  const _AllFriendsSkelaton();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              color: Colors.black,
              shadowColor: Colors.black45,
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
            ),
          );
        });
  }
}
