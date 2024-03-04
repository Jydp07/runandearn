import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  CommunityModel({this.uid, this.video, this.caption,this.date,this.userId});
  String? uid;
  String? userId;
  String? video;
  String? caption;
  Timestamp? date;
  Map<String, dynamic> toMap() {
    return {"video": video, "caption": caption};
  }

  CommunityModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>?> doc)
      : uid = doc.id,
      date = doc.data()?['date_time'],
        video = doc.data()?['video'],
        userId = doc.data()?["userId"],
        caption = doc.data()?['caption'];

  CommunityModel copyWith({
    String? uid,
    String? video,
    String? userId,
    Timestamp? date,
    String? caption,
  }) {
    return CommunityModel(
        uid: uid ?? this.uid,
        userId: userId ?? this.userId,
        video: video ?? this.video,
        date: date ?? this.date,
        caption: caption ?? this.caption);
  }
}
