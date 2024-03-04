import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:runandearn/models/application_model.dart';
import 'package:runandearn/models/challenge_model.dart';
import 'package:runandearn/models/community_model.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final dateTime = DateFormat("EE, dd MMM yyyy").format(DateTime.now());
  final dateTimeTwo = DateFormat("HH:mm, dd MMM yy").format(DateTime.now());
  addUserData(UserModel userData) async {
    await _db.collection("Users").doc(userData.uid).set(userData.toMap());
  }

  final user = FirebaseAuth.instance.currentUser?.uid;
  Future<UserModel> retrieveUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(user).get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<UserModel> retrieveUserDataByUid(UserModel userModel) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(userModel.uid).get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<UserModel> retrieveUserExtraData(UserModel? userModel) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("UsersExtraData")
        .doc(userModel?.uid ?? user)
        .get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<List<UserModel>> retrieveAllUserData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<UserModel>> retrieveLastSevenDaysData() async {
    List<UserModel> resultList = [];
    for (int i = 6; i >= 0; i--) {
      final lastSevenDays = DateTime.now().subtract(Duration(days: i));
      final dateTimeLastSevenDays =
          DateFormat("EE, dd MMM yyyy").format(lastSevenDays);
      final snapshot = await _db
          .collection("Steps")
          .doc(user)
          .collection(dateTimeLastSevenDays)
          .get();
      resultList.addAll(snapshot.docs
          .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot)));
    }
    return resultList;
  }

  Future<List<UserModel>> retrieveLastMonthData() async {
    List<UserModel> resultList = [];
    for (int i = 30; i >= 0; i--) {
      final lastMonth = DateTime.now().subtract(Duration(days: i));
      final dateTimeLastSevenDays =
          DateFormat("EE, dd MMM yyyy").format(lastMonth);
      final snapshot = await _db
          .collection("Steps")
          .doc(user)
          .collection(dateTimeLastSevenDays)
          .get();
      resultList.addAll(snapshot.docs
          .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot)));
    }
    return resultList;
  }

  Future<List<UserModel>> retrieveFriendsData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("friends").doc(user).collection("friend").get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<String> retrieveUserName(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(user.uid).get();
    return snapshot.data()!["name"];
  }

  updateUserProfileData(UserModel userData) async {
    await _db
        .collection("Users")
        .doc(userData.uid)
        .update({"name": userData.name, "number": userData.number});

    await _db.collection("UsersExtraData").doc(userData.uid).update({
      "height": userData.height,
      "weight": userData.weight,
    });
  }

  updateUserData(UserModel userData) async {
    await _db.collection("UsersExtraData").doc(userData.uid).set({
      "gender": userData.gender,
      "dob": userData.dob,
      "height": userData.height,
      "weight": userData.weight,
      "isExtraData": userData.isExtraData
    });
  }

  saveContact(UserModel userData) async {
    await _db
        .collection("contacts")
        .doc(user)
        .collection("contact")
        .doc(user)
        .set({
      "contactList": userData.contactList,
    });
  }

  saveShoppingData(ShoppingModel shoppingModel) async {
    await _db.collection("shopping").doc().set(shoppingModel.toMap());
  }

  Future<List<ShoppingModel>> retrieveShoppingData() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection("shopping").get();
    return data.docs
        .map((docSnapshot) => ShoppingModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<ShoppingModel> retrieveSingleShoppingData(
      ShoppingModel shoppingModel) async {
    final data = await _db.collection("shopping").doc(shoppingModel.uid).get();
    return ShoppingModel.fromDocumentSnapshot(data);
  }

  saveFriends(UserModel userData) async {
    await _db
        .collection("friends")
        .doc(userData.uid)
        .collection("friend")
        .doc(userData.friends)
        .set({"isFriends": userData.isFriends});
  }

  saveUserSteps(UserModel userData) async {
    await _db
        .collection("Steps")
        .doc(userData.uid)
        .collection(dateTime)
        .doc(userData.uid)
        .set({"steps": userData.steps, "day": dateTime});
  }

  saveReferelCode(UserModel userData) async {
    await _db
        .collection("Users")
        .doc(user)
        .update({"referelCode": userData.referelCode});
  }

  saveUserCoins(UserModel userData) async {
    await _db.collection("Coins").doc(userData.uid ?? user).set({
      'coin': userData.coin,
    });
  }

  saveIfReferenced(UserModel userData) async {
    await _db
        .collection("ReferenceOnce")
        .doc(user)
        .set({"isReferedOnce": userData.isReferedOnce});
  }

  saveUserGoalAndTargetCoin(UserModel userData) async {
    await _db.collection("GoalsAndCoin").doc(user).set({
      'goal': userData.goal ?? 1000,
      'coin': userData.coin ?? 500,
    });
  }

  Future<UserModel> retrieveUserSteps() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Steps")
        .doc(user)
        .collection(dateTime)
        .doc(user)
        .get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<UserModel> retrieveUserStepsByUid(UserModel userModel) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Steps")
        .doc(userModel.uid)
        .collection(dateTime)
        .doc(userModel.uid)
        .get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<UserModel> retrieveIfReferedOnce() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("ReferenceOnce").doc(user).get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<UserModel> retrieveUserCoins(UserModel userModel) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Coins").doc(userModel.uid ?? user).get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<UserModel> retrieveUserGoalAndCoin() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("GoalsAndCoin").doc(user).get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  deleteShoppingData(ShoppingModel shoppingModel) async {
    await _db.collection("shopping").doc(shoppingModel.uid).delete();
  }

  updateShoppingData(ShoppingModel shoppingModel) async {
    await _db.collection("shopping").doc(shoppingModel.uid).update({
      'name': shoppingModel.name,
      'price': shoppingModel.price,
      'image': shoppingModel.image,
      'multipleImage': shoppingModel.multipleImage,
      'moreDescription': shoppingModel.moreDescription,
      'description': shoppingModel.description
    });
  }

  saveUserAddress(UserModel userData) async {
    await _db
        .collection("UsersExtraData")
        .doc(user)
        .update({"address": userData.address});
  }

  saveUserShopping(ShoppingModel shoppingModel) async {
    await _db
        .collection("usershopping")
        .doc(user)
        .collection("shopping")
        .doc()
        .set({
      'shopId': shoppingModel.shopId,
      'status': "${shoppingModel.shoppingStatus}",
      'date_time': DateTime.now()
    });
  }

  updateUserShopping(ShoppingModel shoppingModel) async {
    await _db
        .collection("usershopping")
        .doc(shoppingModel.uid)
        .collection("shopping")
        .doc(shoppingModel.shopId)
        .update({
      'status': "${shoppingModel.shoppingStatus}",
      'date_time': DateTime.now(),
    });
  }

  Future<List<ShoppingModel>> retrieveUserShopping() async {
    final snapshot = await _db
        .collection("usershopping")
        .doc(user)
        .collection("shopping")
        .orderBy("date_time", descending: true)
        .get();
    return snapshot.docs
        .map((data) => ShoppingModel.fromDocumentSnapshot(data))
        .toList();
  }

  Future<List<ShoppingModel>> retrieveAllUserShopping(
      UserModel userModel) async {
    final snapshot = await _db
        .collection("usershopping")
        .doc(userModel.uid)
        .collection("shopping")
        .orderBy("date_time")
        .get();
    return snapshot.docs
        .map((data) => ShoppingModel.fromDocumentSnapshot(data))
        .toList();
  }

  addChallenge(ChallengeModel challengeModel) async {
    await _db.collection("challenges").doc().set({
      'name': challengeModel.name,
      'prize': challengeModel.prize,
      'description': challengeModel.description,
      'image': challengeModel.image,
      'steps': challengeModel.steps,
      'date': dateTime,
      'dayLimit': challengeModel.dayLimit,
    });
  }

  Future<List<ChallengeModel>> retrieveChallenges() async {
    final snapshot = await _db.collection("challenges").get();
    return snapshot.docs
        .map((document) => ChallengeModel.fromDocumentSnapshot(document))
        .toList();
  }

  Future<ChallengeModel> retrieveSingleChallenges(
      ChallengeModel challengeModel) async {
    final snapshot =
        await _db.collection("challenges").doc(challengeModel.uid).get();
    return ChallengeModel.fromDocumentSnapshot(snapshot);
  }

  deleteChallenge(ChallengeModel challengeModel) async {
    await _db.collection("challenges").doc(challengeModel.uid).delete();
  }

  acceptChallenge(ChallengeModel challengeModel) async {
    for (int i = 0; i < challengeModel.dayLimit!; i++) {
      final format = DateFormat("EE, dd MMM yyyy", "en_US");
      final date = format.parse(challengeModel.date ?? dateTime);
      final challengeDays = date.add(Duration(days: i));
      log(challengeDays.toString());
      final dateTimeLastSevenDays =
          DateFormat("EE, dd MMM yyyy").format(challengeDays);
      log(dateTimeLastSevenDays);
      await _db
          .collection("user_challnege")
          .doc(user)
          .collection(dateTimeLastSevenDays)
          .doc(challengeModel.uid)
          .set({
        'steps': challengeModel.steps,
        "prize": challengeModel.prize,
        'isRewarded': false,
        "date_time": dateTime,
        "isChallengeAccepted": false
      });
    }
    await _db
        .collection("user_challnege")
        .doc(user)
        .collection("challenge")
        .doc("${challengeModel.uid}$dateTime")
        .set({
      'steps': challengeModel.steps,
      "prize": challengeModel.prize,
    });
  }

  Future<List<ChallengeModel>> retrieveUserChallenges(
      ChallengeModel challengeModel) async {
    final snapshot = await _db
        .collection("user_challnege")
        .doc(user)
        .collection("challenge")
        .get();
    return snapshot.docs
        .map((e) => ChallengeModel.fromDocumentSnapshot(e))
        .toList();
  }

  Future<ChallengeModel> retrieveUserSingleChallenges(
      ChallengeModel challengeModel) async {
    final snapshot = await _db
        .collection("user_challnege")
        .doc(user)
        .collection(dateTime)
        .doc(challengeModel.uid)
        .get();
    return ChallengeModel.fromDocumentSnapshot(snapshot);
  }

  updateUserSingleChallenges(ChallengeModel challengeModel) async {
    for (int i = 0; i < challengeModel.dayLimit!; i++) {
      final format = DateFormat("EE, dd MMM yyyy", "en_US");
      final date = format.parse(challengeModel.date ?? dateTime);
      final challengeDays = date.add(Duration(days: i));
      log(challengeDays.toString());
      final dateTimeLastSevenDays =
          DateFormat("EE, dd MMM yyyy").format(challengeDays);
      await _db
          .collection("user_challnege")
          .doc(user)
          .collection(dateTimeLastSevenDays)
          .doc(challengeModel.uid)
          .update({
        'isRewarded': challengeModel.isRewarded,
        "isChallengeAccepted": challengeModel.isChallengeAccepted
      });
    }
  }

  addWater(UserModel userModel) async {
    await _db
        .collection("water_task")
        .doc(user)
        .collection("water")
        .doc(dateTime)
        .set({
      "water": userModel.water,
    });
  }

  Future<UserModel> retrieveWater() async {
    final snapshot = await _db
        .collection("water_task")
        .doc(user)
        .collection("water")
        .doc(dateTime)
        .get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<List<UserModel>> retrieveChallengeSteps(
      ChallengeModel challengeModel) async {
    List<UserModel> resultList = [];
    for (int i = 0; i < challengeModel.dayLimit!; i++) {
      final format = DateFormat("EE, dd MMM yyyy", "en_US");
      final date = format.parse(challengeModel.date!);
      final challengeDays = date.add(Duration(days: i));
      log(challengeDays.toString());
      final dateTimeLastSevenDays =
          DateFormat("EE, dd MMM yyyy").format(challengeDays);
      final snapshot = await _db
          .collection("Steps")
          .doc(user)
          .collection(dateTimeLastSevenDays)
          .get();
      resultList.addAll(snapshot.docs
          .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot)));
    }
    return resultList;
  }

  Future<List<UserModel>> searchUser(UserModel userModel) async {
    final snapshot = await _db
        .collection("Users")
        .where("name", isGreaterThanOrEqualTo: userModel.name)
        .where("name", isLessThanOrEqualTo: userModel.name)
        .get();
    return snapshot.docs.map((e) => UserModel.fromDocumentSnapshot(e)).toList();
  }

  uploadVideo(CommunityModel communityModel) async {
    await _db.collection("community").doc().set({
      "video": communityModel.video,
      "caption": communityModel.caption,
      "userId": user,
      "date_time": DateTime.now()
    });
  }

  Future<List<CommunityModel>> retrieveVideo() async {
    final snapshot = await _db
        .collection("community")
        .orderBy("date_time", descending: true)
        .get();
    return snapshot.docs
        .map((e) => CommunityModel.fromDocumentSnapshot(e))
        .toList();
  }

  Future<ApplicationModel> retrieveApplicationLink() async {
    final snapshot = await _db.collection("application").doc("link").get();
    return ApplicationModel.fromDocumentSnapshot(snapshot);
  }
}
