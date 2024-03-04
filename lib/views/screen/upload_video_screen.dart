import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/community_bloc/community_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';
import 'package:video_player/video_player.dart';

class UploadVideoScreen extends StatelessWidget {
  const UploadVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final captionController = TextEditingController();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const SubtitleText(
          title: "Share video",
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF232323),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              BlocBuilder<CommunityBloc, CommunityState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      state.isLoading
                          ? null
                          : BlocProvider.of<CommunityBloc>(context)
                              .add(OnPickVideo());
                    },
                    child: Container(
                      width: width * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: BlocBuilder<CommunityBloc, CommunityState>(
                        builder: (context, state) {
                          if (state.video.path.isNotEmpty &&
                              !state.isUploaded) {
                            return AspectRatio(
                              aspectRatio: state.controller!.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  VideoPlayer(state.controller!),
                                  VideoProgressIndicator(state.controller!,
                                      allowScrubbing: true),
                                  BlocBuilder<CommunityBloc, CommunityState>(
                                    builder: (context, state) {
                                      return Positioned(
                                        right: 0,
                                        bottom: height*0.1,
                                        child: IconButton(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.black)),
                                            onPressed: () {
                                              BlocProvider.of<CommunityBloc>(
                                                      context)
                                                  .add(
                                                      const OnSpeakerChanged());
                                              state.controller!.setVolume(
                                                  state.isSpeakerOn ? 1 : 0);
                                            },
                                            icon: Icon(
                                              state.isSpeakerOn
                                                  ? Icons.volume_up_rounded
                                                  : Icons.volume_off,
                                              color: Colors.white,
                                            )),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    child: SizedBox(
                                      width: width*.9,
                                      child: MyTextField(
                                        title: "Caption",
                                        hintText: "Caption..",
                                        controller: captionController,
                                        onChange: (value) {
                                          BlocProvider.of<CommunityBloc>(context)
                                              .add(OnChangedCaption(value));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.2),
                            child: Center(
                              child: Icon(
                                Icons.video_camera_back_outlined,
                                color: Colors.white,
                                size: height * 0.07,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: height * 0.2,
              ),
              BlocBuilder<CommunityBloc, CommunityState>(
                builder: (context, state) {
                  return MyButton(
                      onTap: () {
                        state.isLoading
                            ? null
                            : BlocProvider.of<CommunityBloc>(context)
                                .add(UploadVideoEvent());
                      },
                      height: height * 0.07,
                      width: width * 0.8,
                      child: BlocConsumer<CommunityBloc, CommunityState>(
                        builder: (context, state) {
                          return state.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : const NormText(
                                  title: "Upload Video",
                                  color: Colors.black,
                                );
                        },
                        listener: (BuildContext context, CommunityState state) {
                          if (state.isUploaded) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    content:
                                        const NormText(title: "Video uploaded"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const MiniText(title: "Okay"))
                                    ],
                                  );
                                });
                            captionController.clear();
                          } else if (state.error.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    content: NormText(title: state.error),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const MiniText(title: "Okay"))
                                    ],
                                  );
                                });
                          }
                        },
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
