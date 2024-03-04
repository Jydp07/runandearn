import 'package:cloud_firestore/cloud_firestore.dart';

//enum ShoppingStatus { pending, cancel, delivered, dispatch }

class ChallengeModel {
  ChallengeModel({this.dayLimit, 
      this.challengeId,
      this.date,
      this.name,
      this.prize,
      this.image,
      this.description,
      this.steps,
      this.isRewarded,
      this.isChallengeAccepted,
      this.uid});
  String? uid;
  final String? challengeId;
  final String? name;
  final double? prize;
  final String? image;
  final String? description;
  final int? steps;
  final bool? isChallengeAccepted;
  final String? date;
  final bool? isRewarded;
  final int? dayLimit;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'prize': prize,
      'image': image,
      'description': description,
      'date_time': date,
      'steps': steps,
      'isRewarded': isRewarded,
      'challengeId': challengeId,
      "isChallengeAccepted":isChallengeAccepted,
      "dayLimit":dayLimit
    };
  }

  ChallengeModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>?> doc)
      : uid = doc.id,
        name = doc.data()?['name'],
        prize = doc.data()?['prize'],
        image = doc.data()?['image'],
        description = doc.data()?['description'],
        steps = doc.data()?['steps'],
        challengeId = doc.data()?['challengeId'],
        isRewarded = doc.data()?['isRewarded'],
        isChallengeAccepted = doc.data()?['isChallengeAccepted'],
        dayLimit = doc.data()?['dayLimit'],
        date = doc.data()?['date_time'];

  ChallengeModel copyWith(
      {String? uid,
      String? name,
      double? prize,
      String? image,
      String? description,
      String? date,
      int? steps,
      int? dayLimit,
      bool? isChallengeAccepted,
      bool? isRewarded,
      String? challengeId}) {
    return ChallengeModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      prize: prize ?? this.prize,
      date: date ?? this.date,
      challengeId: challengeId ?? this.challengeId,
      image: image ?? this.image,
      dayLimit: dayLimit ?? this.dayLimit,
      steps: steps ?? this.steps,
      isChallengeAccepted:isChallengeAccepted ?? this.isChallengeAccepted,
      isRewarded: isRewarded ?? this.isRewarded,
      description: description ?? this.description,
    );
  }
}
