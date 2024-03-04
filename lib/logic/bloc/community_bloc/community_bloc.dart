import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runandearn/models/community_model.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc()
      : super(CommunityState(
          isVideoPicked: false,
          video: File(""),
          description: "",
          isLoading: false,
          error: '',
          isSpeakerOn: true,
          isUploaded: false,
          communityData: const [],
          isPlaying: false,
          users: const [],
          fileInfo: const [],
          onThisPage: false,
        )) {
    on<CommunityEvent>((event, emit) {});
    on<OnChangedCaption>(_onChangedCaption);
    on<OnPickVideo>(_onPickedVideo);
    on<UploadVideoEvent>(_onUploadVideo);
    on<OnSpeakerChanged>(_speakedChanged);
    on<OnGetCommunityData>(_onGetCommunityData);
    on<OnPlayPauseVideo>(_onPlayPauseVideo);
    on<OnChangedReels>(_onChangedReels);
    on<OnThisPage>(
      (event, emit) {
        emit(state.copyWith(onThisPage: event.onthispage));
      },
    );
  }

  final db = DatabaseRepositoryImpl();
  _onPickedVideo(OnPickVideo event, Emitter<CommunityState> emit) async {
    try {
      emit(state.copyWith(isUploaded: false));
      VideoPlayerController? controller;
      final videoPicker = ImagePicker();
      final video = await videoPicker.pickVideo(source: ImageSource.gallery);
      if (video!.path.isNotEmpty) {
        final selectedVideo = File(video.path);
        emit(state.copyWith(video: selectedVideo));
        controller = VideoPlayerController.file(File(state.video.path))
          ..addListener(() {})
          ..setLooping(true)
          ..initialize().then((value) => controller?.play());
        emit(state.copyWith(controller: controller));
      } else {
        emit(state.copyWith(error: "Please Pick Video"));
      }
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }

  _onChangedCaption(OnChangedCaption event, Emitter<CommunityState> emit) {
    emit(state.copyWith(description: event.description));
  }

  _speakedChanged(OnSpeakerChanged event, Emitter<CommunityState> emit) {
    emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));
  }

  _onPlayPauseVideo(OnPlayPauseVideo event, Emitter<CommunityState> emit) {
    emit(state.copyWith(isPlaying: event.isPlaying));
  }

  _onUploadVideo(UploadVideoEvent event, Emitter<CommunityState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("community_video")
          .child("${state.video.path}.mp4");
      final compressVideo = await VideoCompress.compressVideo(state.video.path,
          quality: VideoQuality.LowQuality,
          deleteOrigin: false,
          includeAudio: true);
      await storageRef.putFile(File(compressVideo!.path!));
      final getVideoUrl = await storageRef.getDownloadURL();
      final communityModel = CommunityModel();
      await db.uploadVideo(communityModel.copyWith(
          video: getVideoUrl, caption: state.description));
      emit(state.copyWith(isUploaded: true));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  VideoPlayerController? controller;
  _onChangedReels(OnChangedReels event, Emitter<CommunityState> emit) async {
    try {
      log("message");
      final fileInfo = await DefaultCacheManager()
          .getFileFromCache(state.communityData[event.index].video!);
      if (fileInfo == null) {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(state.communityData[event.index].video!),
        )
          ..addListener(() {})
          ..setLooping(true)
          ..initialize().then((value) async {
            controller!.play();
            controller!.setVolume(0);
            await DefaultCacheManager()
                .getSingleFile(state.communityData[event.index].video!)
                .then((value) => log("Download video"));
          });
      } else {
        controller = VideoPlayerController.file(File(fileInfo.file.path))
          ..addListener(() {})
          ..setLooping(true)
          ..initialize().then((value) {
            controller!.play();
            controller!.setVolume(0);
          });
      }
      emit(state.copyWith(controller: controller));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }

  _onGetCommunityData(
      OnGetCommunityData event, Emitter<CommunityState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final userModel = UserModel();
      final data = await db.retrieveVideo();
      List<UserModel> userDetail = [];
      for (var data in data) {
        final uploadedBy = await db
            .retrieveUserDataByUid(userModel.copyWith(uid: data.userId));
        userDetail.add(uploadedBy);
      }
      add(OnChangedReels(onThisPage: event.onThisPage));
      emit(state.copyWith(
          communityData: data, users: userDetail, controller: controller));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
      log(ex.toString());
    } finally {
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }

  @override
  Future<void> close() async {
    await controller?.dispose();
    await state.controller?.dispose();
    return super.close();
  }
}
