part of 'shopping_bloc.dart';

sealed class ShoppingEvent extends Equatable {
  const ShoppingEvent();

  @override
  List<Object> get props => [];
}

class OnBuy extends ShoppingEvent {
  const OnBuy({required this.price});
  final double price;
  @override
  List<Object> get props => [price];
}

class OnBuySuccess extends ShoppingEvent{
  const OnBuySuccess({required this.price});
  final double price;
  @override
  List<Object> get props => [price];
}
class OnBuyCancel extends ShoppingEvent{
  const OnBuyCancel({required this.price});
  final double price;
  @override
  List<Object> get props => [price];
}
class OnGetShoppingData extends ShoppingEvent {
  const OnGetShoppingData();
  @override
  List<Object> get props => [];
}

class OnDeleteShoppingData extends ShoppingEvent {
  const OnDeleteShoppingData({required this.dataId});
  final String dataId;
  @override
  List<Object> get props => [dataId];
}

class OnSetUserAddressToBuy extends ShoppingEvent{
  const OnSetUserAddressToBuy({required this.address});
  final List<String> address;

  @override
  List<Object> get props => [address];
}

class OnGetUserAdress extends ShoppingEvent{
  @override
  List<Object> get props => [];
}

class OnGetUserShoppingData extends ShoppingEvent{
  @override
  List<Object> get props => [];
}

class OnGetAllUserShoppingData extends ShoppingEvent{
  @override
  List<Object> get props => [];
}

class OnSetUserShoppingData extends ShoppingEvent{
  const OnSetUserShoppingData({required this.shoppingId, required this.shoppingStatus});
  final String shoppingStatus;
  final String shoppingId;
  @override
  List<Object> get props => [shoppingStatus,shoppingId];
}

class OnChangeOrderStatus extends ShoppingEvent{
  const OnChangeOrderStatus({required this.price, required this.shopId,required this.status,required this.uid});
  final String shopId;
  final double price;
  final String uid;
  final String status;
  @override
  List<Object> get props => [shopId,price,status,uid];
}