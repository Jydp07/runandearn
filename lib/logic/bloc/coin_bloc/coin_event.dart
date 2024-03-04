part of 'coin_bloc.dart';

sealed class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class CoinIcreament extends CoinEvent{
  const CoinIcreament(this.steps);
  final int steps;
  @override
  List<Object> get props => [steps];
}

class CoinGet extends CoinEvent{
  const CoinGet();
  @override
  List<Object> get props => [];
}
