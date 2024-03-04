import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/friends_bloc/friends_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:shimmer/shimmer.dart';

class FromContact extends StatelessWidget {
  const FromContact({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<FriendsBloc, FriendsState>(
              builder: (context, state) {
                if (state.friends.isEmpty) {
                  return const SizedBox();
                }
                return NormText(
                    title: "From your contact (${state.friends.length})");
              },
            ),
            BlocBuilder<FriendsBloc, FriendsState>(
              builder: (context, state) {
                if (state.friends.isEmpty) {
                  return const SizedBox();
                }
                return TextButton.icon(
                  onPressed: () {},
                  label: const MiniText(
                    title: "View All",
                    color: Colors.grey,
                  ),
                  icon: const Icon(Icons.chevron_right_sharp),
                );
              },
            ),
          ],
        ),
        BlocBuilder<FriendsBloc, FriendsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return SizedBox(
                height: height * 0.2,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (contaxt, index) {
                        return Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: height * 0.05,
                              child: const TitleText(title: ""),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                  width: width * 0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const MiniText(title: "")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: height * 0.03,
                                width: width * 0.23,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    side: MaterialStateBorderSide.resolveWith(
                                        (states) => const BorderSide(
                                            color: Color(0xFFAFEA0D))),
                                  ),
                                  child: const Text(
                                    "Follow",
                                    style: TextStyle(
                                        color: Color(0xFFAFEA0D), fontSize: 12),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                ),
              );
            } else if (state.error.isNotEmpty) {
              return Center(
                child: MiniText(title: state.error),
              );
            } else if (state.friends.isEmpty) {
              return const SizedBox();
            } else {
              return SizedBox(
                height: height * 0.2,
                child: ListView.builder(
                    itemCount: state.friends.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (contaxt, index) {
                      final firstChar = state.friends[index].name
                          ?.substring(0, 1)
                          .toUpperCase();
                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: height * 0.05,
                            // foregroundImage:
                            //     state.contact[index].photoOrThumbnail != null
                            //         ? MemoryImage(
                            //             state.contact[index].photoOrThumbnail!)
                            //         : null,
                            child: TitleText(title: firstChar ?? ""),
                          ),
                          MiniText(title: state.friends[index].name ?? ""),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: height * 0.03,
                              width: width * 0.23,
                              child: OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<FriendsBloc>(context).add(
                                      OnSentInviteEvent(
                                          state.friends[index].uid!));
                                  BlocProvider.of<FriendsBloc>(context)
                                      .add(OnGetAllFriends());
                                  BlocProvider.of<FriendsBloc>(context)
                                      .add(GetContactEvent());
                                },
                                style: ButtonStyle(
                                  side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                          color: Color(0xFFAFEA0D))),
                                ),
                                child: const Text(
                                  "Follow",
                                  style: TextStyle(
                                      color: Color(0xFFAFEA0D), fontSize: 12),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              );
            }
          },
        )
      ],
    );
  }
}
