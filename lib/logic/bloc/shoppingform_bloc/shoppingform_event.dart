part of 'shoppingform_bloc.dart';

sealed class ShoppingformEvent extends Equatable {
  const ShoppingformEvent();

  @override
  List<Object> get props => [];
}

class OnNameChanged extends ShoppingformEvent{
  const OnNameChanged({required this.name});

  final String name;
  @override
  List<Object> get props => [name];
}

class OnPriceChanged extends ShoppingformEvent{
  const OnPriceChanged({required this.price});

  final double price;
  @override
  List<Object> get props => [price];
}

class OnImageChanged extends ShoppingformEvent{
  const OnImageChanged();
  @override
  List<Object> get props => [];
}

class OnDescriptionChanged extends ShoppingformEvent{
  const OnDescriptionChanged({required this.description});

  final String description;
  @override
  List<Object> get props => [description];
}

class OnMultipleImageChanged extends ShoppingformEvent{
  const OnMultipleImageChanged();

  
  @override
  List<Object> get props => [];
}

class OnMoreDescriptionChanged extends ShoppingformEvent{
  const OnMoreDescriptionChanged({required this.moreDescription});

  final String moreDescription;
  @override
  List<Object> get props => [moreDescription];
}
class OnUpdateShoppingData extends ShoppingformEvent {
  const OnUpdateShoppingData(this.uid);
  final String uid;
  @override
  List<Object> get props => [uid];
}
class OnSubmitData extends ShoppingformEvent{
  @override
  List<Object> get props => [];
}
