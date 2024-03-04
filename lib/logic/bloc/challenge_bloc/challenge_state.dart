part of 'challenge_bloc.dart';

class ChallengeState extends Equatable {
  const ChallengeState(
      {required this.isNamevalid,
      required this.isPhotoValid,
      required this.isDataValid,
      required this.isPriceValid,
      required this.isLoading,
      required this.isClaimReward,
      required this.isDescriptionValid,
      required this.error,
      required this.name,
      required this.prize,
      required this.isStepsValid,
      required this.steps,
      required this.challengeData,
      required this.image,
      required this.isChallengeAccepted,
      required this.isRewarded,
      required this.isDeleteSuccess,
      required this.dayLimit,
      required this.isSubmitSuccess,
      required this.description});
  final bool isNamevalid;
  final bool isPhotoValid;
  final bool isDataValid;
  final bool isPriceValid;
  final bool isLoading;
  final bool isSubmitSuccess;
  final bool isStepsValid;
  final bool isDescriptionValid;
  final bool isClaimReward;
  final bool isChallengeAccepted;
  final String error;
  final String name;
  final double prize;
  final int steps;
  final int dayLimit;
  final bool isDeleteSuccess;
  final File image;
  final bool isRewarded;
  final String description;
  final List<ChallengeModel> challengeData;

  ChallengeState copyWith({
    bool? isPriceValid,
    bool? isNamevalid,
    bool? isPhotoValid,
    bool? isDataValid,
    bool? isDescriptionValid,
    bool? isStepsValid,
    bool? isRewarded,
    String? name,
    double? prize,
    int? dayLimit,
    bool? isChallengeAccepted,
    int? steps,
    bool? isLoading,
    String? error,
    bool? isClaimReward,
    bool? isSubmitSuccess,
    bool? isDeleteSuccess,
    File? image,
    String? description,
    List<ChallengeModel>? challengeData
  }) {
    return ChallengeState(
      isPriceValid: isPriceValid ?? this.isPriceValid,
      isNamevalid: isNamevalid ?? this.isNamevalid,
      isPhotoValid: isPhotoValid ?? this.isPhotoValid,
      name: name ?? this.name,
      isClaimReward: isClaimReward ?? this.isClaimReward,
      prize: prize ?? this.prize,
      isRewarded:isRewarded ?? this.isRewarded,
      isLoading: isLoading ?? this.isLoading,
      challengeData: challengeData ?? this.challengeData,
      error: error ?? this.error,
      isDataValid: isDataValid ?? this.isDataValid,
      image: image ?? this.image,
      dayLimit: dayLimit ?? this.dayLimit,
      isChallengeAccepted:isChallengeAccepted ?? this.isChallengeAccepted,
      isStepsValid: isStepsValid ?? this.isStepsValid,
      steps: steps ?? this.steps,
      isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
      description: description ?? this.description,
      isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
      isDeleteSuccess: isDeleteSuccess ?? this.isDeleteSuccess
    );
  }

  @override
  List<Object> get props => [
        name,
        prize,
        description,
        image,
        isPriceValid,
        isStepsValid,
        isNamevalid,
        isDescriptionValid,
        isPhotoValid,
        isLoading,
        error,
        steps,
        isSubmitSuccess,
        isDataValid,
        isClaimReward,
        isDeleteSuccess,
        challengeData,
        isRewarded,
        dayLimit,
        isChallengeAccepted
      ];
}
