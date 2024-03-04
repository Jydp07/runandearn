import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:runandearn/logic/bloc/community_bloc/community_bloc.dart';
import 'package:runandearn/models/community_model.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.url, required this.data, required this.userdata, required this.fileInfo,
  });
  final String url;
  final CommunityModel data;
  final UserModel userdata;
  final FileInfo? fileInfo;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? controller;
  @override
  void initState(){
    if (widget.fileInfo == null) {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      )
        ..addListener(() {})
        ..setLooping(true)
        ..initialize().then((value) async {
          await DefaultCacheManager()
              .getSingleFile(widget.url)
              .then((value) => log("Download video"));
          controller!.play();
        });
    } else {
      controller = VideoPlayerController.file(File(widget.fileInfo!.file.path))
        ..addListener(() {})
        ..setLooping(true)
        ..initialize().then((value) => controller!.play());
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat("HH:mm,dd MMM yyyy")
                      .format(widget.data.date!.toDate());
     final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
      return GestureDetector(
        onTapDown: (_) {
          Timer(const Duration(seconds: 1), () {
            controller!.pause();
          });
        },
        onTapUp: (_) {
          controller!.play();
        },
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            VideoPlayer(controller!),
            VideoProgressIndicator(
              controller!,
              allowScrubbing: true,
            ),
            Positioned(
              right: width * 0.03,
              bottom: height * 0.2,
              child: IconButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black)),
                  onPressed: () {
                    BlocProvider.of<CommunityBloc>(context)
                        .add(const OnSpeakerChanged());
                    state.controller!.setVolume(state.isSpeakerOn ? 1 : 0);
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
                        title:
                            widget.userdata.name?.substring(0, 1).toUpperCase() ?? ""),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormText(title: widget.userdata.name ?? ""),
                      widget.data.caption != ""
                          ? MiniText(title: widget.data.caption!)
                          : const SizedBox(),
                      Text(
                        formatedDate,
                        style: TextStyle(
                            color: Colors.grey, fontSize: height * 0.01),
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
    });
  }
}
