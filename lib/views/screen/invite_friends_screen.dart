import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/friends_bloc/friends_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/widget/invite_widget/all_friend_widget.dart';
import 'package:runandearn/views/widget/invite_widget/invite_fromcontact_widget.dart';
import 'package:runandearn/views/widget/invite_widget/invite_reward_widget.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final searchController = TextEditingController();
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.isSearching
              ? AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left_outlined,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  title: SizedBox(
                      //height: height * 0.05,
                      child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      BlocProvider.of<FriendsBloc>(context)
                          .add(OnSearchFriends(name: value, isSearching: true));
                      log(state.searchFriend.toString());
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: height * 0.024,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              BlocProvider.of<FriendsBloc>(context).add(
                                  const OnSearchFriends(
                                      name: "", isSearching: false));
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ))),
                    style: const TextStyle(color: Colors.white),
                  )),
                )
              : AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: const SubtitleText(
                    title: "Invite Friends",
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<FriendsBloc>(context).add(
                              OnSearchFriends(
                                  name: searchController.text,
                                  isSearching: true));
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        )),
                  ],
                ),
          backgroundColor: const Color(0xFF232323),
          body: state.isSearching
              ? ListView.builder(
              itemCount: state.searchFriend.length,
              itemBuilder: ((context, index) {
                final user = state.searchFriend[index];
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
                                BlocProvider.of<FriendsBloc>(context)
                                    .add(OnGetAllFriends());
                                BlocProvider.of<FriendsBloc>(context)
                                    .add(GetContactEvent());
                              },
                              height: height * 0.035,
                              width: width * 0.2,
                              child: const MiniText(
                                title: "Follow",
                                color: Colors.black,
                              ))),
                      Divider(
                        thickness: 1,
                        color: Colors.black26,
                        height: height * 0.01,
                      )
                    ],
                  ),
                );
              }),
                              )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NormText(title: "Get Started"),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      const InviteRewardWidget(),
                      const FromContact(),
                      const NormText(title: "Users"),
                      const Expanded(child: AllFriendsWidget())
                    ],
                  ),
                ),
        );
      },
    );
  }
}
