import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/reward_order_history.dart';
import 'package:runandearn/views/widget/reward_widget/shoping_widget.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingBloc()..add(const OnGetShoppingData()),
      child: const _RewardScreen(),
    );
  }
}

class _RewardScreen extends StatelessWidget {
  const _RewardScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const TitleText(title: "Rewards"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) =>
                          ShoppingBloc()..add(OnGetUserShoppingData()),
                      child: const RewardOrederHistory(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ))
        ],
      ),
      body:
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Divider(
          thickness: 1,
        ),
        Expanded(child: ShoppingWidget())
      ]),
    );
  }
}
