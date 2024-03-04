// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/auth_bloc/authentication_bloc.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/logic/cubit/visibility_cubit/visibility_cubit_cubit.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';
import 'package:runandearn/views/widget/registration_widget.dart/continuewith_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  _signIn(context) {
    Navigator.pushReplacementNamed(context, "/SignIn");
  }

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();
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
                              onPressed: () => state.errorMessage
                                      .contains("Please Verify your email")
                                  ? Navigator.pushNamedAndRemoveUntil(
                                      context, "/SignUpExtra", (route) => false)
                                  : Navigator.of(context).pop(),
                              child: const Text("Ok"))
                        ],
                        content: Text(state.errorMessage),
                      ));
            } else if (state.isFormValid && !state.isLoading) {
              context.read<AuthenticationBloc>().add(AuthenticationStarted());
              context.read<FormBloc>().add(const FormSucceeded());
            } else if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill proper details")));
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            final databaseRepository = DatabaseRepositoryImpl();
            UserModel userModel =
                await databaseRepository.retrieveUserExtraData(UserModel());
            if (state is AuthenticationSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil("/SignUpExtra", (route) => false);
            }else if (state is AuthenticationGoogleSuccess) {
              if (userModel.isExtraData ?? false) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/Tab", (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/SignUpExtra", (Route<dynamic> route) => false);
              }
            }
          },
        ),
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
                const TitleText(title: "Create an account..."),
                SizedBox(
                  height: height * 0.03,
                ),
                BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    return MyTextField(
                      title: "Name",
                      controller: nameController,
                      prefix: Icons.person,
                      hintText: "Username",
                      erroMsg: state.isNameValid ? null : "Enter name",
                      onChange: (value) {
                        BlocProvider.of<FormBloc>(context)
                            .add(NameChanged(value));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    return MyTextField(
                      textInputType: TextInputType.phone,
                      title: "Number",
                      controller: numberController,
                      prefix: Icons.phone,
                      hintText: "Mobile",
                      erroMsg: state.isNumberValid ? null : "Enter 10 digit Number",
                      onChange: (value) {
                        BlocProvider.of<FormBloc>(context)
                            .add(NumberChanged(value));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    return MyTextField(
                      title: "Email",
                      controller: emailController,
                      hintText: "Email",
                      prefix: Icons.email_rounded,
                      erroMsg: state.isEmailValid ? null : "Enter valid email",
                      onChange: (value) {
                        BlocProvider.of<FormBloc>(context)
                            .add(EmailChanged(value));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    return _PasswordTextField(
                      "Password",
                      controller: passwordController,
                      errorMsg:
                          state.isPasswordValid ? null : "Enter valid password",
                      onChange: (value) {
                        BlocProvider.of<FormBloc>(context)
                            .add(PasswordChanged(value));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    return _PasswordTextField(
                      "Repassword",
                      controller: repasswordController,
                      errorMsg:
                          state.isPasswordMatch ? null : "Password not match",
                      onChange: (value) {
                        BlocProvider.of<FormBloc>(context).add(
                            RepasswordChanged(passwordController.text, value));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: !state.isFormValid 
                          ? () {context.read<FormBloc>().add(
                              const FormSubmittedSignUp(value: Status.signUp));
                              FocusScope.of(context).unfocus();
                              }
                          : null,
                      child: Container(
                        height: height * 0.08,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                            color: const Color(0xFFAFEA0D),
                            borderRadius: BorderRadius.circular(30),
                            ),
                        child: Center(
                          child: BlocBuilder<FormBloc, FormsValidate>(
                            builder: (context, state) {
                              if(state.isLoading){
                                return const Center(child: CircularProgressIndicator(color: Colors.black,),);
                              }
                              return Text(
                                "Create an account",
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
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const NormText(title: "Already have an account? "),
                    TextButton(
                        onPressed: () {
                          _signIn(context);
                        },
                        child: const LinkText(title: "SignIn"))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  child: const Divider(thickness: 1, color: Color(0xFF363635)),
                ),
                const ContinueWithWidget()
              ],
            ),
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    numberController.dispose();
    passwordController.dispose();
    repasswordController.dispose();
    super.dispose();
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField(this.title,
      {this.errorMsg, this.controller, this.onChange});
  final String title;
  final String? errorMsg;
  final TextEditingController? controller;
  final ValueChanged? onChange;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<VisibilityCubit, VisibilityCubitState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            controller: controller,
            obscureText: state.isVisible,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: title,
              label: Padding(
                padding: EdgeInsets.only(left: width * 0.06),
                child: NormText(
                  title: title,
                  color: Colors.grey,
                ),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Icon(
                  Icons.lock,
                  size: height * 0.038,
                  color: Colors.grey,
                ),
              ),
              errorText: errorMsg,
              prefixIconConstraints: BoxConstraints.tight(const Size(25, 25)),
              constraints: BoxConstraints(
                  maxWidth: width > 600 ? width * 0.4 : width * 0.95),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: height * 0.02,
              ),
              prefix: SizedBox(
                width: width * 0.05,
              ),
              suffixIcon: GestureDetector(
                child: state.isVisible
                    ? const Icon(
                        FontAwesomeIcons.eye,
                        color: Colors.grey,
                      )
                    : const Icon(
                        FontAwesomeIcons.eyeSlash,
                        color: Colors.grey,
                      ),
                onTap: () {
                  BlocProvider.of<VisibilityCubit>(context).changeVisibility();
                },
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            onChanged: onChange,
          ),
        );
      },
    );
  }
}
