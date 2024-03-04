import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/repository/authentication_repository.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FormBloc(AuthenticationRepositoryImpl(), DatabaseRepositoryImpl()),
      child: const _ForgetPasswordScreen(),
    );
  }
}

class _ForgetPasswordScreen extends StatelessWidget {
  const _ForgetPasswordScreen();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_left_sharp,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
        title: const SubtitleText(
          title: "Reset Password",
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF232323),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const NormText(title: "Enter email to reset password"),
                SizedBox(
                  height: height * 0.05,
                ),
                BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    return MyTextField(
                      title: "Enter email",
                      prefix: Icons.email,
                      erroMsg: state.isEmailValid ? null : "Enter proper email",
                      onChange: (value) {
                        BlocProvider.of<FormBloc>(context)
                            .add(EmailChanged(value));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.3,
                ),
                BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    return MyButton(
                        onTap: () {
                          BlocProvider.of<FormBloc>(context).add(
                              const FormSubmittedSignUp(
                                  value: Status.forgetPassword));
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  content: NormText(
                                    title:
                                       state.errorMessage != "" ? state.errorMessage :"You will get an email to reset password",
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const NormText(title: "Okay"))
                                  ],
                                );
                              });
                        },
                        height: height * 0.07,
                        width: width * 0.8,
                        child: const Text("Reset Password"));
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
