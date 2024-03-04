// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';

class SpalashScreen extends StatefulWidget {
  const SpalashScreen({super.key});

  @override
  State<SpalashScreen> createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final databaseRepository = DatabaseRepositoryImpl();
          UserModel userModel =
              await databaseRepository.retrieveUserExtraData(UserModel());
          if (userModel.isExtraData ?? false) {
            if (userModel.email == "dwellamultimedia@gmail.com") {
              Navigator.pushNamedAndRemoveUntil(context, "/AdminScreen", (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/Tab", (route) => false);
            }
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, "/SignUpExtra", (route) => false);
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, "/SignIn", (route) => false);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black87,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: SvgPicture.asset("assets/svg/logo.svg"),
      ),
    ));
  }
}
