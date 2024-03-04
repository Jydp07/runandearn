import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runandearn/models/challenge_model.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  ChallengeBloc()
      : super(ChallengeState(
            isNamevalid: true,
            isPhotoValid: true,
            isDataValid: false,
            isPriceValid: true,
            isLoading: false,
            isDescriptionValid: true,
            error: "",
            name: "",
            prize: 0,
            dayLimit: 1,
            image: File(""),
            isSubmitSuccess: false,
            description: "",
            isDeleteSuccess: false,
            challengeData: const [],
            isStepsValid: true,
            steps: 0,
            isClaimReward: false,
            isRewarded: false,
            isChallengeAccepted: false)) {
    on<OnNameChanged>(_onNameValid);
    on<OnPriceChanged>(_onPriceValid);
    on<OnImageChanged>(_onImageValid);
    on<OnDescriptionChanged>(_onDescriptionValid);
    on<OnSubmitData>(_onSetShoppingData);
    on<OnDeleteChallenge>(_onDeleteChallenge);
    on<OnGetChallengeData>(_onGetChallengeData);
    on<OnStepsChanges>(_onStepsValid);
    on<OnTimeLimitChanged>(_onTimitLimitValid);
    on<OnAcceptChallenge>(_onAcceptChallenge);
    on<OnGetUserChallenge>(_onGetUserChallengeData);
    on<OnClaimReward>(_onClaimReward);
    on<OnRewardUser>(_onRewardUser);
  }

  bool _isNameValid(String name) {
    return name.isNotEmpty;
  }

  bool _isPriceValid(double price) {
    return price > 0;
  }

  bool _isImageValid(File image) {
    return image.path.isNotEmpty;
  }

  bool _isDescriptionValid(String description) {
    return description.length > 100;
  }

  bool _isStepsValid(int steps) {
    return steps > 1000;
  }

  _onNameValid(OnNameChanged event, Emitter<ChallengeState> emit) {
    emit(state.copyWith(
        isDataValid: true,
        name: event.name,
        isNamevalid: _isNameValid(event.name)));
  }

  _onPriceValid(OnPriceChanged event, Emitter<ChallengeState> emit) {
    emit(state.copyWith(
        isDataValid: true,
        prize: event.price,
        isPriceValid: _isPriceValid(event.price)));
  }

  _onImageValid(OnImageChanged event, Emitter<ChallengeState> emit) async {
    PermissionStatus permission = await Permission.photos.request();
    if (permission == PermissionStatus.denied) {
      await Permission.photos.request();
      if (permission == PermissionStatus.granted) {
        return;
      }
    }
    final ImagePicker picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final selectedImage = File(file.path);
      emit(state.copyWith(
          isDataValid: true,
          image: selectedImage,
          isPhotoValid: _isImageValid(selectedImage)));
    } else {
      emit(state.copyWith(error: "Please Pick Image"));
    }
  }

  _onStepsValid(OnStepsChanges event, Emitter<ChallengeState> emit) {
    emit(state.copyWith(
        isDataValid: true,
        steps: event.steps,
        isStepsValid: _isStepsValid(event.steps)));
  }

  _onDescriptionValid(
      OnDescriptionChanged event, Emitter<ChallengeState> emit) {
    emit(state.copyWith(
        isDataValid: true,
        description: event.description,
        isDescriptionValid: _isDescriptionValid(event.description)));
  }

  _onTimitLimitValid(OnTimeLimitChanged event, Emitter<ChallengeState> emit) {
    emit(state.copyWith(
      isDataValid: true,
      dayLimit: event.dayLimit,
    ));
  }

  final db = DatabaseRepositoryImpl();
  _onSetShoppingData(OnSubmitData event, Emitter<ChallengeState> emit) async {
    emit(state.copyWith(
        isDataValid: _isNameValid(state.name) &&
            _isPriceValid(state.prize) &&
            _isImageValid(state.image) &&
            _isStepsValid(state.steps) &&
            _isDescriptionValid(state.description)));
    if (state.isDataValid) {
      emit(state.copyWith(isLoading: true));
      try {
        final challenge = ChallengeModel();
        final storageRefImage = FirebaseStorage.instance
            .ref()
            .child("challenge_image")
            .child('${state.image.path}.jpg');

        await storageRefImage.putFile(state.image);

        final getImageUrl = await storageRefImage.getDownloadURL();

        await db.addChallenge(challenge.copyWith(
            name: state.name,
            prize: state.prize,
            steps: state.steps,
            image: getImageUrl,
            description: state.description,
            dayLimit: state.dayLimit));
      } catch (ex) {
        emit(state.copyWith(error: ex.toString(), isDataValid: false));
      } finally {
        emit(state.copyWith(isLoading: false));
      }
      emit(state.copyWith(isSubmitSuccess: true));
    } else {
      emit(state.copyWith(error: "Fill proper data"));
    }
  }

  _onAcceptChallenge(
      OnAcceptChallenge event, Emitter<ChallengeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final challengeModel = ChallengeModel();
      final limit = await db
          .retrieveSingleChallenges(challengeModel.copyWith(uid: event.uid));
      log(limit.dayLimit.toString());
      final isRewarded = await db.retrieveUserSingleChallenges(
          challengeModel.copyWith(uid: event.uid));
      log(isRewarded.date.toString());
      await db.acceptChallenge(challengeModel.copyWith(
          prize: event.prize,
          steps: event.steps,
          uid: event.uid,
          dayLimit: limit.dayLimit,
          date: isRewarded.date));
      await db.updateUserSingleChallenges(challengeModel.copyWith(
          uid: event.uid,
          isChallengeAccepted: true,
          isRewarded: false,
          dayLimit: limit.dayLimit,
          date: isRewarded.date));
      final challengeData = await db.retrieveUserSingleChallenges(
          challengeModel.copyWith(uid: event.uid));
      emit(state.copyWith(
          isChallengeAccepted: challengeData.isChallengeAccepted));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _onClaimReward(OnClaimReward event, Emitter<ChallengeState> emit) async {
    try {
      final challengeModel = ChallengeModel();
      final isRewarded = await db.retrieveUserSingleChallenges(
          challengeModel.copyWith(uid: event.uid));
      emit(state.copyWith(
          isRewarded: isRewarded.isRewarded,
          isChallengeAccepted: isRewarded.isChallengeAccepted));
      final limit = await db
          .retrieveSingleChallenges(challengeModel.copyWith(uid: event.uid));
      final userSteps = await db.retrieveChallengeSteps(challengeModel.copyWith(
          dayLimit: limit.dayLimit, date: isRewarded.date));
      int challengeStep = 0;
      for (var userstep in userSteps) {
        challengeStep += userstep.steps!;
      }
      if (challengeStep > isRewarded.steps!) {
        emit(state.copyWith(isClaimReward: true));
      }
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _onRewardUser(OnRewardUser event, Emitter<ChallengeState> emit) async {
    final userCoins = await db.retrieveUserCoins(UserModel());
    final challengeModel = ChallengeModel();
    final challenge = await db
        .retrieveUserSingleChallenges(challengeModel.copyWith(uid: event.uid));
    final userModel = UserModel();
    emit(state.copyWith(isRewarded: challenge.isRewarded));
    if (state.isClaimReward && !state.isRewarded) {
      await db.saveUserCoins(
          userModel.copyWith(coin: userCoins.coin! + challenge.prize!.toInt()));
      await db.updateUserSingleChallenges(challengeModel.copyWith(
          uid: event.uid, isRewarded: true, isChallengeAccepted: true));
    }
  }

  _onDeleteChallenge(
      OnDeleteChallenge event, Emitter<ChallengeState> emit) async {
    try {
      final challengeModel = ChallengeModel();
      await db.deleteChallenge(challengeModel.copyWith(uid: event.uid));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
    emit(state.copyWith(isDeleteSuccess: true));
  }

  _onGetChallengeData(
      OnGetChallengeData event, Emitter<ChallengeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await db.retrieveChallenges();
      emit(state.copyWith(challengeData: data));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _onGetUserChallengeData(
      OnGetUserChallenge event, Emitter<ChallengeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final challengeModel = ChallengeModel();
      final data = await db.retrieveUserChallenges(ChallengeModel());
      List<ChallengeModel> userChallenge = [];
      for (var element in data) {
        final challenge = await db.retrieveSingleChallenges(
            challengeModel.copyWith(uid: element.uid?.substring(0, 20)));
        userChallenge.add(challenge);
      }
      emit(state.copyWith(challengeData: userChallenge));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  // _onDeleteHistory(OnDeleteHistory event, Emitter<ChallengeState> emit){

  // }
}
