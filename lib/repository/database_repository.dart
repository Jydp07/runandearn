import 'package:runandearn/models/application_model.dart';
import 'package:runandearn/models/challenge_model.dart';
import 'package:runandearn/models/community_model.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/services/database_services.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  DatabaseService service = DatabaseService();

  @override
  Future<void> saveUserData(UserModel user) {
    return service.addUserData(user);
  }

  @override
  Future<UserModel> retrieveUserData() {
    return service.retrieveUserData();
  }

  @override
  Future<UserModel> retrieveUserExtraData(UserModel? userModel) {
    return service.retrieveUserExtraData(userModel);
  }

  @override
  Future<UserModel> retrieveUserDataByUid(UserModel userModel) {
    return service.retrieveUserDataByUid(userModel);
  }

  @override
  Future<List<UserModel>> retrieveAllUserData() {
    return service.retrieveAllUserData();
  }

  @override
  Future<List<UserModel>> retrieveFriendsData() {
    return service.retrieveFriendsData();
  }

  @override
  Future<void> saveUserSteps(UserModel userData) {
    return service.saveUserSteps(userData);
  }

  @override
  Future<void> saveFriends(UserModel userData) {
    return service.saveFriends(userData);
  }

  @override
  Future<UserModel> retrieveUserSteps() {
    return service.retrieveUserSteps();
  }

  @override
  Future<void> saveUserCoins(UserModel userData) {
    return service.saveUserCoins(userData);
  }

  @override
  Future<void> saveUserGoal(UserModel userData) {
    return service.saveUserGoalAndTargetCoin(userData);
  }

  @override
  Future<void> saveReferelCode(UserModel userData) {
    return service.saveReferelCode(userData);
  }

  @override
  Future<void> saveIfReferenced(UserModel userData) {
    return service.saveIfReferenced(userData);
  }

  @override
  Future<void> saveContact(UserModel userData) {
    return service.saveContact(userData);
  }

  @override
  Future<UserModel> retrieveUserCoins(UserModel userModel) {
    return service.retrieveUserCoins(userModel);
  }

  @override
  Future<UserModel> retrieveIfReferedOnce() {
    return service.retrieveIfReferedOnce();
  }

  @override
  Future<UserModel> retrieveUserGoal() {
    return service.retrieveUserGoalAndCoin();
  }

  @override
  Future<void> updateUserdata(UserModel user) {
    return service.updateUserData(user);
  }

  @override
  Future<void> updateUserProfiledata(UserModel user) {
    return service.updateUserProfileData(user);
  }

  @override
  Future<List<UserModel>> retrieveLastSevenDaysData() {
    return service.retrieveLastSevenDaysData();
  }

  @override
  Future<List<UserModel>> retrieveLastMonthData() {
    return service.retrieveLastMonthData();
  }

  @override
  Future<UserModel> retrieveUserStepsByUid(UserModel userModel) {
    return service.retrieveUserStepsByUid(userModel);
  }

  @override
  Future<void> saveShoppingData(ShoppingModel shoppingModel) {
    return service.saveShoppingData(shoppingModel);
  }

  @override
  Future<List<ShoppingModel>> retrieveShoppingData() {
    return service.retrieveShoppingData();
  }

  @override
  Future<void> deleteShoppingData(ShoppingModel shoppingModel) {
    return service.deleteShoppingData(shoppingModel);
  }

  @override
  Future<void> updateShoppingData(ShoppingModel shoppingModel) {
    return service.updateShoppingData(shoppingModel);
  }

  @override
  Future<ShoppingModel> retrieveSingleShoppingData(
      ShoppingModel shoppingModel) {
    return service.retrieveSingleShoppingData(shoppingModel);
  }

  @override
  Future<void> saveUserAddress(UserModel userData) {
    return service.saveUserAddress(userData);
  }

  @override
  Future<List<ShoppingModel>> retrieveUserShopping() {
    return service.retrieveUserShopping();
  }

  @override
  Future<void> saveUserShopping(ShoppingModel shoppingModel) {
    return service.saveUserShopping(shoppingModel);
  }

  @override
  Future<void> updateUserShopping(ShoppingModel shoppingModel) {
    return service.updateUserShopping(shoppingModel);
  }

  @override
  Future<List<ShoppingModel>> retrieveAllUserShopping(UserModel userModel) {
    return service.retrieveAllUserShopping(userModel);
  }

  @override
  Future<void> addChallenge(ChallengeModel challengeModel) {
    return service.addChallenge(challengeModel);
  }

  @override
  Future<List<ChallengeModel>> retrieveChallenges() {
    return service.retrieveChallenges();
  }

  @override
  Future<void> deleteChallenge(ChallengeModel challengeModel) {
    return service.deleteChallenge(challengeModel);
  }

  @override
  Future<void> acceptChallenge(ChallengeModel challengeModel) {
    return service.acceptChallenge(challengeModel);
  }

  @override
  Future<List<ChallengeModel>> retrieveUserChallenges(
      ChallengeModel challengeModel) {
    return service.retrieveUserChallenges(challengeModel);
  }

  @override
  Future<ChallengeModel> retrieveSingleChallenges(
      ChallengeModel challengeModel) {
    return service.retrieveSingleChallenges(challengeModel);
  }

  @override
  Future<ChallengeModel> retrieveUserSingleChallenges(
      ChallengeModel challengeModel) {
    return service.retrieveUserSingleChallenges(challengeModel);
  }

  @override
  Future<void> updateUserSingleChallenges(ChallengeModel challengeModel) {
    return service.updateUserSingleChallenges(challengeModel);
  }

  @override
  Future<void> addWater(UserModel userModel) {
    return service.addWater(userModel);
  }

  @override
  Future<UserModel> retrieveWater() {
    return service.retrieveWater();
  }
  
  @override
  Future<List<UserModel>> retrieveChallengeSteps(ChallengeModel challengeModel) {
    return service.retrieveChallengeSteps(challengeModel);
  }
  
  @override
  Future<List<UserModel>> searchUser(UserModel userModel) {
    return service.searchUser(userModel);
  }
  
  @override
  Future<void> uploadVideo(CommunityModel communityModel) {
    return service.uploadVideo(communityModel);
  }
  
  @override
  Future<List<CommunityModel>> retrieveVideo() {
    return service.retrieveVideo();
  }
  
  @override
  Future<ApplicationModel> retrieveApplicationLink() {
    return service.retrieveApplicationLink();
  }
}

abstract class DatabaseRepository {
  Future<void> saveUserData(UserModel user);
  Future<void> updateUserdata(UserModel user);
  Future<void> updateUserProfiledata(UserModel user);
  Future<UserModel> retrieveUserData();
  Future<UserModel> retrieveUserExtraData(UserModel? userModel);
  Future<UserModel> retrieveUserDataByUid(UserModel userModel);
  Future<List<UserModel>> retrieveFriendsData();
  Future<List<UserModel>> retrieveAllUserData();
  Future<List<ShoppingModel>> retrieveAllUserShopping(UserModel userModel);
  Future<void> saveUserGoal(UserModel user);
  Future<void> updateUserShopping(ShoppingModel shoppingModel);
  Future<void> saveShoppingData(ShoppingModel shoppingModel);
  Future<void> saveUserShopping(ShoppingModel shoppingModel);
  Future<void> saveUserSteps(UserModel user);
  Future<void> saveFriends(UserModel user);
  Future<void> saveReferelCode(UserModel user);
  Future<UserModel> retrieveUserSteps();
  Future<UserModel> retrieveUserStepsByUid(UserModel userModel);
  Future<void> saveUserCoins(UserModel user);
  Future<void> saveUserAddress(UserModel userData);
  Future<void> saveIfReferenced(UserModel user);
  Future<void> saveContact(UserModel user);
  Future<void> deleteShoppingData(ShoppingModel shoppingModel);
  Future<void> updateShoppingData(ShoppingModel shoppingModel);
  Future<List<ShoppingModel>> retrieveUserShopping();
  Future<UserModel> retrieveUserCoins(UserModel userModel);
  Future<UserModel> retrieveIfReferedOnce();
  Future<UserModel> retrieveUserGoal();
  Future<List<UserModel>> retrieveLastSevenDaysData();
  Future<List<UserModel>> retrieveLastMonthData();
  Future<List<ShoppingModel>> retrieveShoppingData();
  Future<ShoppingModel> retrieveSingleShoppingData(ShoppingModel shoppingModel);
  Future<void> addChallenge(ChallengeModel challengeModel);
  Future<List<ChallengeModel>> retrieveChallenges();
  Future<void> deleteChallenge(ChallengeModel challengeModel);
  Future<void> acceptChallenge(ChallengeModel challengeModel);
  Future<List<ChallengeModel>> retrieveUserChallenges(
      ChallengeModel challengeModel);
  Future<ChallengeModel> retrieveSingleChallenges(
      ChallengeModel challengeModel);
  Future<ChallengeModel> retrieveUserSingleChallenges(
      ChallengeModel challengeModel);
  Future<void> updateUserSingleChallenges(ChallengeModel challengeModel);
  Future<void> addWater(UserModel userModel);
  Future<UserModel> retrieveWater();
  Future<List<UserModel>> retrieveChallengeSteps(ChallengeModel challengeModel);
  Future<List<UserModel>> searchUser(UserModel userModel);
   Future<void> uploadVideo(CommunityModel communityModel);
   Future<List<CommunityModel>> retrieveVideo();
   Future<ApplicationModel> retrieveApplicationLink();
}
