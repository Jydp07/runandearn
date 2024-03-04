import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  ShoppingBloc()
      : super(const ShoppingState(
            userUid: "",
            error: "",
            buySuccess: false,
            shoppingData: [],
            isLoading: false,
            isAddressValid: false,
            orderStatus: [],
            userAddress: [],
            userData: [],
            isCancel: false)) {
    on<ShoppingEvent>((event, emit) {});
    on<OnBuy>(_onBuy);
    on<OnBuySuccess>(_onBuySuccess);
    on<OnGetShoppingData>(_onGetData);
    on<OnDeleteShoppingData>(_onDeleteData);
    on<OnSetUserAddressToBuy>(_onSetUserAddress);
    on<OnGetUserAdress>(_onGetUserAddress);
    on<OnSetUserShoppingData>(_onSetUserShoppingData);
    on<OnGetUserShoppingData>(_onGetUserShoppingdata);
    on<OnBuyCancel>(_onBuyCancel);
    on<OnChangeOrderStatus>(_onChangeOrderStatus);
    on<OnGetAllUserShoppingData>(_allUserShoppingData);
  }
  final db = DatabaseRepositoryImpl();

  _onBuy(OnBuy event, Emitter<ShoppingState> emit) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final user = UserModel();
    final userCoin = await db.retrieveUserCoins(user.copyWith(uid: uid));
    if (userCoin.coin! >= event.price) {
      emit(state.copyWith(buySuccess: true));
    }
  }

  _onBuySuccess(OnBuySuccess event, Emitter<ShoppingState> emit) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final user = UserModel();
    final userCoin = await db.retrieveUserCoins(user.copyWith(uid: uid));
    await db.saveUserCoins(
        user.copyWith(coin: userCoin.coin! - event.price.toInt()));
  }

  _onBuyCancel(OnBuyCancel event, Emitter<ShoppingState> emit) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final user = UserModel();
    final userCoin = await db.retrieveUserCoins(user.copyWith(uid: uid));
    await db.saveUserCoins(
        user.copyWith(coin: userCoin.coin! + event.price.toInt()));
  }

  _onSetUserAddress(OnSetUserAddressToBuy event, Emitter<ShoppingState> emit) {
    if (event.address.isEmpty) {
      emit(state.copyWith(isAddressValid: false));
    } else {
      event.address.every((element) {
        if (element == "") {
          emit(state.copyWith(isAddressValid: false));
          return false;
        }
        emit(state.copyWith(isAddressValid: true));
        return true;
      });

      if (state.isAddressValid) {
        final userData = UserModel();
        db.saveUserAddress(userData.copyWith(address: event.address));
      }
    }
  }

  _onChangeOrderStatus(
      OnChangeOrderStatus event, Emitter<ShoppingState> emit) async {
    final shoppingModel = ShoppingModel();
    await db.updateUserShopping(shoppingModel.copyWith(
        uid: event.uid, shoppingStatus: event.status, shopId: event.shopId));
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final user = UserModel();
    final userCoin = await db.retrieveUserCoins(user.copyWith(uid: uid));
    if (event.status == 'ShoppingStatus.cancel') {
      await db.saveUserCoins(
          user.copyWith(coin: userCoin.coin! + event.price.toInt()));
    }

    emit(state.copyWith(isCancel: true));
  }

  _onGetData(OnGetShoppingData event, Emitter<ShoppingState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<ShoppingModel> data = await db.retrieveShoppingData();
      emit(state.copyWith(shoppingData: data));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _allUserShoppingData(
      OnGetAllUserShoppingData event, Emitter<ShoppingState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final users = await db.retrieveAllUserData();
      List<ShoppingModel> userShopping = [];
      List<ShoppingModel> orderStatus = [];
      List<UserModel> userData = [];
      for (var user in users) {
        final shoppingData = await db.retrieveAllUserShopping(user);
        final userAddress = await db.retrieveUserExtraData(user);
        final shoppingModel = ShoppingModel();
        for (var element in shoppingData) {
          final data = await db.retrieveSingleShoppingData(
              shoppingModel.copyWith(uid: element.shopId));
          orderStatus.add(element);
          userShopping.add(data);
          userData.add(userAddress);
        }
      }
      emit(state.copyWith(
          shoppingData: userShopping,
          orderStatus: orderStatus,
          userData: userData));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _onGetUserAddress(OnGetUserAdress event, Emitter<ShoppingState> emit) async {
    final userModel = UserModel();
    final usersData = await db.retrieveUserExtraData(userModel);
    emit(state.copyWith(userAddress: usersData.address));
  }

  _onSetUserShoppingData(
      OnSetUserShoppingData event, Emitter<ShoppingState> emit) async {
    final shoppingModel = ShoppingModel();
    await db.saveUserShopping(shoppingModel.copyWith(
        shopId: event.shoppingId, shoppingStatus: event.shoppingStatus));
  }

  _onGetUserShoppingdata(
      OnGetUserShoppingData event, Emitter<ShoppingState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = FirebaseAuth.instance.currentUser?.uid;
      final shoppingData = await db.retrieveUserShopping();
      final shoppingModel = ShoppingModel();
      List<ShoppingModel> userShopping = [];
      List<ShoppingModel> orderStatus = [];
      for (var element in shoppingData) {
        final data = await db.retrieveSingleShoppingData(
            shoppingModel.copyWith(uid: element.shopId));
        orderStatus.add(element);
        userShopping.add(data);
      }
      emit(state.copyWith(
          shoppingData: userShopping, orderStatus: orderStatus, userUid: user));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _onDeleteData(OnDeleteShoppingData event, Emitter<ShoppingState> emit) async {
    try {
      final shoppingModel = ShoppingModel();
      await db.deleteShoppingData(shoppingModel.copyWith(uid: event.dataId));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }
}
