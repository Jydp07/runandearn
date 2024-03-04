import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  String? uid;
  bool? isVerified;
  final String? email;
  final String? name;
  String? password;
  final bool? isReferedOnce;
  final String? isFriends;
  final String? number;
  final String? referelCode;
  final String? contactList; 
  final bool? isExtraData;
  final String? gender;
  final String? dateTime;
  final String? dob;
  final List<dynamic>? address;
  final String? friends;
  final double? height;
  final double? weight;
  final int? steps;
  final int? goal;
  final int? water;
  final int? coin;
  UserModel(   
      {this.gender,
      this.dob,
      this.height,
      this.weight,
      this.uid,
      this.email,
      this.name,
      this.steps,
      this.coin, 
      this.address,
      this.isFriends,
      this.referelCode,
      this.goal,
      this.dateTime,
      this.contactList,
      this.friends,
      this.number,
      this.isReferedOnce,
      this.password,
      this.isVerified,
      this.water,
      this.isExtraData = false});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'gender': gender,
      'dob': dob,
      'height': height,
      'weight': weight,
      'steps':steps,
      'number':number,
      'friends':friends,
      'isVerified': isVerified,
      'isFriends':isFriends,
      'referelCode':referelCode,
      'contactList':contactList,
      'goal':goal,
      'address':address,
      "day":dateTime,
      'isReferedOnce':isReferedOnce,
      'isExtraData': isExtraData,
      'coin':coin,
      "water":water
    };
  }

  UserModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>?> doc,
  )   : uid = doc.id,
        email = doc.data()?["email"],
        name = doc.data()?["name"],
        gender = doc.data()?["gender"],
        dob = doc.data()?["dob"],
        height = doc.data()?["height"],
        weight = doc.data()?["weight"],
        steps = doc.data()?['steps'],
        coin = doc.data()?['coin'],
        number = doc.data()?['number'],
        goal = doc.data()?['goal'],
        isFriends = doc.data()?['isFriends'],
        contactList = doc.data()?['contactList'],
        friends = doc.data()?['friends'],
        dateTime = doc.data()?['day'],
        address = doc.data()?['address'],
        referelCode = doc.data()?['referelCode'],
        isVerified = doc.data()?["isVerified"],
        isReferedOnce = doc.data()?['isReferedOnce'],
        water = doc.data()?["water"],
        isExtraData = doc.data()?["isExtraData"];

  UserModel copyWith(
      {bool? isVerified,
      String? uid,
      String? email,
      String? password,
      String? name,
      String? friends,
      String? gender,
      String? dob,
      int? steps,
      int? coin,
      int? goal,
      int? water,
      List<dynamic>? address,
      String? dateTime,
      bool? isReferedOnce,
      String? isFriends,
      String? referelCode,
      String? contactList, 
      String? number,
      bool? isExtraData,
      double? height,
      double? weight}) {
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        password: password ?? this.password,
        gender: gender ?? this.gender,
        dob: dob ?? this.dob,
        address: address ?? this.address,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        steps: steps ?? this.steps,
        isFriends: isFriends ?? isFriends,
        contactList: contactList ?? this.contactList,
        coin: coin ?? this.coin,
        isReferedOnce: isReferedOnce ?? this.isReferedOnce,
        friends: friends ?? this.friends,
        goal: goal ?? this.goal,
        dateTime: dateTime ?? this.dateTime,
        number: number ?? this.number,
        water:water ?? this.water,
        referelCode: referelCode ?? this.referelCode,
        isVerified: isVerified ?? this.isVerified,
        isExtraData: isExtraData ?? this.isExtraData);
  }
}
