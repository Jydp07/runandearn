part of 'shopping_bloc.dart';

class ShoppingState extends Equatable {
  const ShoppingState(
      {required this.userAddress,
      required this.error,
      required this.buySuccess,
      required this.isLoading,
      required this.shoppingData,
      required this.orderStatus,
      required this.userData,
      required this.isCancel,
      required this.userUid,
      required this.isAddressValid});
  final String error;
  final bool buySuccess;
  final bool isLoading;
  final bool isAddressValid;
  final bool isCancel;
  final String userUid;
  final List<ShoppingModel> orderStatus;
  final List<dynamic> userAddress;
  final List<UserModel> userData;
  final List<ShoppingModel> shoppingData;

  ShoppingState copyWith({
    String? error,
    bool? buySuccess,
    bool? isLoading,
    bool? isAddressValid,
    String? userUid,
    bool? isCancel,
    List<dynamic>? userAddress,
    List<ShoppingModel>? orderStatus,
    List<ShoppingModel>? shoppingData,
    List<UserModel>? userData,
  }) {
    return ShoppingState(
        error: error ?? this.error,
        userAddress: userAddress ?? this.userAddress,
        buySuccess: buySuccess ?? this.buySuccess,
        orderStatus: orderStatus ?? this.orderStatus,
        isLoading: isLoading ?? this.isLoading,
        userData: userData ?? this.userData,
        userUid: userUid ?? this.userUid,
        isCancel: isCancel ?? this.isCancel,
        isAddressValid: isAddressValid ?? this.isAddressValid,
        shoppingData: shoppingData ?? this.shoppingData);
  }

  @override
  List<Object> get props => [
        error,
        buySuccess,
        isLoading,
        isAddressValid,
        shoppingData,
        orderStatus,
        userAddress,
        userData,
        userUid,
        isCancel
      ];
}
