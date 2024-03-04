import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String? applicationLink;

  ApplicationModel({this.applicationLink});

  ApplicationModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String,dynamic>?> doc)
  :applicationLink = doc.data()?['appLink'];
}
