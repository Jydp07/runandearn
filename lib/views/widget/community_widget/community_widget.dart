import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:runandearn/logic/bloc/community_bloc/community_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class CommunityWidget extends StatefulWidget {
  const CommunityWidget({super.key});

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget> {
  @override
  void initState() {
    BlocProvider.of<CommunityBloc>(context).add(const OnGetCommunityData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state.isLoading || state.controller == null) {
            return const _CommunitySkaleton();
          } else if (state.error.isNotEmpty) {
            return Center(
              child: NormText(title: state.error),
            );
          } else if (state.communityData.isEmpty && state.fileInfo.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const NormText(
                    title: "Nothing to show",
                  ),
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<CommunityBloc>(context)
                            .add(const OnGetCommunityData());
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ))
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              backgroundColor: Colors.white,
              color: Colors.black,
              onRefresh: () async {
                BlocProvider.of<CommunityBloc>(context)
                    .add(const OnGetCommunityData());
              },
              child: PageView.builder(
                onPageChanged: (value) {
                  BlocProvider.of<CommunityBloc>(context)
                      .add(OnChangedReels(index: value));
                },
                scrollDirection: Axis.vertical,
                itemCount: state.communityData.length,
                itemBuilder: (context, index) {
                  final data = state.communityData[index];
                  final userdata = state.users[index];
                  final formatedDate = DateFormat("HH:mm,dd MMM yyyy")
                      .format(data.date!.toDate());
                  return SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onLongPress: () {
                        state.controller!.pause();
                      },
                      onLongPressEnd: (value) {
                        state.controller!.play();
                      },
                      child: state.controller != null
                          ? AspectRatio(
                              aspectRatio: state.controller != null
                                  ? state.controller!.value.aspectRatio
                                  : 0,
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    VideoPlayer(state.controller!),
                                    VideoProgressIndicator(
                                      state.controller!,
                                      allowScrubbing: true,
                                    ),
                                    Positioned(
                                      right: width * 0.03,
                                      bottom: height * 0.2,
                                      child: IconButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.black)),
                                          onPressed: () {
                                            BlocProvider.of<CommunityBloc>(
                                                    context)
                                                .add(const OnSpeakerChanged());
                                            state.controller!.setVolume(
                                                state.isSpeakerOn ? 1 : 0);
                                          },
                                          icon: Icon(
                                            state.isSpeakerOn
                                                ? Icons.volume_up_rounded
                                                : Icons.volume_off,
                                            color: Colors.white,
                                          )),
                                    ),
                                    Positioned(
                                      bottom: height * 0.02,
                                      left: width * 0.05,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            radius: height * 0.03,
                                            child: NormText(
                                                title: userdata.name
                                                        ?.substring(0, 1)
                                                        .toUpperCase() ??
                                                    ""),
                                          ),
                                          SizedBox(
                                            width: width * 0.03,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              NormText(
                                                  title: userdata.name ?? ""),
                                              data.caption != ""
                                                  ? MiniText(
                                                      title: data.caption!)
                                                  : const SizedBox(),
                                              Text(
                                                formatedDate,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: height * 0.01),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: height * 0.3,
                                      right: width * 0.04,
                                      child: Column(
                                        children: [
                                          LikeButton(
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            size: height * 0.04,
                                            likeBuilder: ((isLiked) {
                                              return isLiked
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                      size: height * 0.04,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .favorite_border_outlined,
                                                      size: height * 0.04,
                                                      color: Colors.white,
                                                    );
                                            }),
                                            countPostion: CountPostion.bottom,
                                            likeCount: 0,
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.comment,
                                                color: Colors.white,
                                                size: height * 0.035,
                                              )),
                                        ],
                                      ),
                                    )
                                  ]),
                            )
                          : const SizedBox(),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class _CommunitySkaleton extends StatelessWidget {
  const _CommunitySkaleton();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 1,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          child: GestureDetector(
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Positioned(
                right: width * 0.03,
                bottom: height * 0.2,
                child: IconButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.volume_off,
                      color: Colors.white,
                    )),
              ),
              Positioned(
                bottom: height * 0.02,
                left: width * 0.05,
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: height * 0.03,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            width: width * 0.4,
                            height: height * 0.02,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            width: width * 0.7,
                            height: height * 0.01,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: height * 0.3,
                right: width * 0.04,
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: height * 0.035,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.comment,
                          color: Colors.white,
                          size: height * 0.035,
                        )),
                  ],
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
