import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/friends_bloc/friends_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class ReferelScreen extends StatelessWidget {
  const ReferelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsBloc(),
      child: const _ReferelScreen(),
    );
  }
}

class _ReferelScreen extends StatelessWidget {
  const _ReferelScreen();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final referController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, "/Tab", (route) => false);
          }, child: const NormText(title: "Skip"))
        ],
      ),
      backgroundColor: const Color(0xFF232323),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const NormText(title: "Do you have referel code?"),
                SizedBox(
                  height: height * 0.05,
                ),
                SizedBox(
                  height: height * 0.08,
                  width: width * 0.95,
                  child: MyTextField(
                    title: "Enter referel code",
                    prefix: Icons.qr_code,
                    controller: referController,
                  ),
                ),
                SizedBox(
                  height: height * 0.3,
                ),
                BlocBuilder<FriendsBloc, FriendsState>(
                  builder: (context, state) {
                    return MyButton(
                        onTap: () {
                          BlocProvider.of<FriendsBloc>(context).add(
                              OnGetReferelCode(referCode: referController.text.toString()));
                          Navigator.pushNamedAndRemoveUntil(context, '/Tab',(route)=>false);
                        },
                        height: height * 0.07,
                        width: width * 0.8,
                        child: const Text("Get Started"));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
