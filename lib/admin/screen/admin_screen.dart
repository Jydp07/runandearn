import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/admin/screen/add_challenge_screen.dart';
import 'package:runandearn/admin/screen/add_shopping_data_screen.dart';
import 'package:runandearn/admin/screen/modify_challenge_screen.dart';
import 'package:runandearn/admin/screen/modify_shopping_screen.dart';
import 'package:runandearn/admin/screen/reward_orders_screen.dart';
import 'package:runandearn/logic/bloc/auth_bloc/authentication_bloc.dart';
import 'package:runandearn/logic/bloc/challenge_bloc/challenge_bloc.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/logic/bloc/shoppingform_bloc/shoppingform_bloc.dart';
import 'package:runandearn/logic/cubit/visibility_cubit/visibility_cubit_cubit.dart';
import 'package:runandearn/repository/authentication_repository.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/login_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const SubtitleText(
            title: "Admin Home",
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF232323),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(
              parent: BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.normal)),
          child: Column(children: [
            SizedBox(
              height: height * 0.02,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider(
                              create: (context) => ShoppingformBloc(),
                              child: const AddShoppingDataScreen(),
                            )));
              },
              leading: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              trailing: const NormText(title: "Add Shopping Data"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider(
                              create: (context) => ChallengeBloc(),
                              child: const AddChallengeScreen(),
                            )));
              },
              leading: const Icon(
                Icons.add_box_outlined,
                color: Colors.white,
              ),
              trailing: const NormText(title: "Add Challenge Data"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BlocProvider(
                          create: (context) =>
                              ShoppingBloc()..add(const OnGetShoppingData()),
                          child: const ModifyShoppingData(),
                        )));
              },
              leading: const Icon(
                Icons.change_circle_outlined,
                color: Colors.white,
              ),
              trailing: const NormText(title: "Modify Shopping Data"),
            ),

            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider(
                              create: (context) => ChallengeBloc()..add(const OnGetChallengeData()),
                              child: const ModifyChallengeScreen(),
                            )));
              },
              leading: const Icon(
                Icons.change_circle,
                color: Colors.white,
              ),
              trailing: const NormText(title: "Modify challenge data"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider(
                              create: (context) => ShoppingBloc()
                                ..add(OnGetAllUserShoppingData()),
                              child: const RewardOrdersScreen(),
                            )));
              },
              leading: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              trailing: const NormText(title: "Reward Oreders"),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => BlocProvider(
                        create: (context) =>
                            AuthenticationBloc(AuthenticationRepositoryImpl()),
                        child: const _LogOutDialog()));
              },
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              trailing: const NormText(title: "LogOut"),
            )
          ]),
        ),
      ),
    );
  }
}

class _LogOutDialog extends StatelessWidget {
  const _LogOutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const NormText(
        title: "Are you sure?",
        color: Colors.black,
      ),
      actions: [
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return TextButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationSignedOut());
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => VisibilityCubit(),
                                  ),
                                  BlocProvider(
                                    create: (context) => FormBloc(
                                        AuthenticationRepositoryImpl(),
                                        DatabaseRepositoryImpl()),
                                  ),
                                  BlocProvider(
                                    create: (context) => AuthenticationBloc(
                                        AuthenticationRepositoryImpl()),
                                  ),
                                ],
                                child: const LoginScreen(),
                              )));
                },
                child:
                    const Text("Yes", style: TextStyle(color: Colors.black)));
          },
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }
}
