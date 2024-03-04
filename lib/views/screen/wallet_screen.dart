import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:runandearn/logic/bloc/coin_bloc/coin_bloc.dart';
import 'package:runandearn/logic/bloc/friends_bloc/friends_bloc.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/reward_order_history.dart';
import 'package:runandearn/views/widget/invite_widget/invite_reward_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left_rounded),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          title: const SubtitleText(
            title: "Wallet",
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF232323),
        body: BlocProvider(
          create: (context) => FriendsBloc(),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              const InviteRewardWidget(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                child: Card(
                  color: Colors.black,
                  child: ListTile(
                    title: const MiniText(title: "Your balance"),
                    trailing: SizedBox(
                      width: width * 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset("assets/svg/coin.svg"),
                          BlocBuilder<CoinBloc, CoinState>(
                            builder: (context, state) {
                              return state.coin != 0 ? _Balance(state.coin) : const SizedBox();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
                child: Card(
                  color: Colors.black,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) =>
                                  ShoppingBloc()..add(OnGetUserShoppingData()),
                              child: const RewardOrederHistory(),
                            ),
                          ));
                    },
                    title: const MiniText(title: "Order History"),
                    trailing: const Icon(
                      Icons.chevron_right_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Balance extends StatefulWidget {
  const _Balance(this.coin);
  final int coin;
  @override
  State<_Balance> createState() => _BalanceState();
}

class _BalanceState extends State<_Balance> with SingleTickerProviderStateMixin{
  static const Duration _duration = Duration(seconds: 2);
  
  AnimationController? controller;
  Animation<double>? animation;
  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        setState(() {});
      });
    animation = Tween(
            begin: 0.0,
            end: double.parse(widget.coin.toString()))
        .animate(controller!);
    controller?.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MiniText(title: animation!.value.toStringAsFixed(1));
  }
}
