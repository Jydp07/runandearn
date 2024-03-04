part of 'coin_bloc.dart';

class CoinState extends Equatable {
  const CoinState({required this.coin});
  final int coin;

  CoinState copyWith({
    int? coin,
  }) {
    return CoinState(coin: coin ?? this.coin);
  }

  @override
  List<Object> get props => [coin];
}
