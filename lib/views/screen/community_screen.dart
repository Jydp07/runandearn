import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/community_bloc/community_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/upload_video_screen.dart';
import 'package:runandearn/views/widget/community_widget/community_widget.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const SubtitleText(
            title: "Community",
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider(
                          create: (context) => CommunityBloc(),
                          child: const UploadVideoScreen(),
                        )));
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        backgroundColor: const Color(0xFF232323),
        body: BlocProvider(
          create: (context) => CommunityBloc(),
          child: const CommunityWidget(),
        ),
      ),
    );
  }
}
