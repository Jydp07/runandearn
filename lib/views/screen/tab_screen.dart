import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/coin_bloc/coin_bloc.dart';
import 'package:runandearn/views/screen/home_screen.dart';
import 'package:runandearn/views/widget/persitent_bar.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CoinBloc(),
          ),
        ],
        child: const GnavBar(),
      ),
      body: const HomeScreen(),
    ));
  }
}
