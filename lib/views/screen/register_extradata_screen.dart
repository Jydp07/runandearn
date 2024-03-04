import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/databse_bloc/database_bloc.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/widget/registration_widget.dart/dob_widget.dart';
import 'package:runandearn/views/widget/registration_widget.dart/gender_widget.dart';
import 'package:runandearn/views/widget/registration_widget.dart/height_widget.dart';
import 'package:runandearn/views/widget/registration_widget.dart/weight_widget.dart';

class RegisterExtraDataScreen extends StatelessWidget {
  const RegisterExtraDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsValidate>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"))
                        ],
                        content: Text(state.errorMessage),
                      ));
            } else if (state.isFormValid && !state.isLoading) {
              context.read<DatabaseBloc>().add(const DatabaseUpdate());
              context.read<FormBloc>().add(const FormSucceeded());
            } else if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill proper details")));
            }
          },
        ),
        BlocListener<DatabaseBloc, DatabaseState>(
          listener: (context, state) {
            if (state is DatabaseUpdateSuccess) {
              if (state.isReferedOnce ?? false) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/Tab", (route) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, "/Refer", (route) => false);
              }
            }
          },
        )
      ],
      child: Scaffold(
        body: Container(
          color: Colors.black87,
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const SubtitleText(
                    title: "Let's complete your profile",
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const MiniText(
                    title: "It will hepl us to know more about you!",
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: BlocBuilder<FormBloc, FormsValidate>(
                      builder: (context, state) {
                        if (!state.isGenderValid) {
                          return const NormText(
                            title: "Choose gender",
                            color: Colors.red,
                          );
                        } else if (!state.isDOBValid) {
                          return const NormText(
                            title: "Enter DOB",
                            color: Colors.red,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  const GenderWidget(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const DOB(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const WeightWidget(),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const HeightWidget(),
                  SizedBox(
                    height: height * 0.27,
                  ),
                  BlocBuilder<FormBloc, FormsValidate>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: !state.isFormValid
                            ? () async {
                                context.read<FormBloc>().add(
                                    const FormSubmittedSignUp(
                                        value: Status.signUpExtra));
                                FocusScope.of(context).unfocus();
                              }
                            : null,
                        child: Container(
                          height: height * 0.08,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: const Color(0xFFAFEA0D),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFAFEA0D).withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0,
                                      height *
                                          0.01), // You can adjust the offset as needed
                                ),
                              ]),
                          child: Center(
                            child: BlocBuilder<FormBloc, FormsValidate>(
                              builder: (context, state) {
                                if (state.isLoading) {
                                  return const CircularProgressIndicator(
                                    color: Colors.black,
                                  );
                                }
                                return Text(
                                  "Next",
                                  style: TextStyle(
                                      color: const Color(0xFF151515),
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.025),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
