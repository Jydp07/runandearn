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
import 'package:runandearn/views/screen/forget_password_screen.dart';
import 'package:runandearn/views/widget/registration_widget.dart/continuewith_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  _signUp(context) {
    Navigator.pushReplacementNamed(context, '/SignUp');
  }

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
                  builder: (context) =>
                      ErrorDialog(errorMessage: state.errorMessage));
            } else if (state.isFormValid && !state.isLoading) {
              context.read<AuthenticationBloc>().add(AuthenticationStarted());
              context.read<FormBloc>().add(const FormSucceeded());
            } else if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter valid details")));
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            final databaseRepository = DatabaseRepositoryImpl();
            UserModel userModel =
                await databaseRepository.retrieveUserExtraData(UserModel());
            if (state is AuthenticationSuccess) {
              if (userModel.isExtraData ?? false) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/Tab", (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/SignUpExtra", (Route<dynamic> route) => false);
              }
            } else if (state is AuthenticationGoogleSuccess) {
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
          height: double.infinity,
          width: double.infinity,
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.03),
                        child: GestureDetector(
                            onLongPress: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/AdminLogin', (route) => false);
                            },
                            child: const TitleText(title: "Welcome back..."))),
                    BlocBuilder<FormBloc, FormsValidate>(
                      builder: (context, state) {
                        return MyTextField(
                          title: "Email",
                          prefix: Icons.email,
                          hintText: "Email",
                          erroMsg:
                              state.isEmailValid ? null : "Enter valid email",
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
                            state.isPasswordValid
                                ? null
                                : "Enter valid password");
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.02),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen()));
                              },
                              child: const NormText(
                                  title: "Forgot your password?")),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.14,
                    ),
                    BlocBuilder<FormBloc, FormsValidate>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: !state.isFormValid
                              ? () {
                                  context.read<FormBloc>().add(
                                      const FormSubmittedSignUp(
                                          value: Status.signIn));
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
                                  if (state.isLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    );
                                  }
                                  return Text(
                                    "Login",
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
                        const NormText(title: "New here?"),
                        TextButton(
                          onPressed: () {
                            _signUp(context);
                          },
                          child: const LinkText(title: "SignUp"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    const ContinueWithWidget()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField(this.title, this.error);
  final String title;
  final String? error;
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
            obscureText: state.isVisible,
            onChanged: (value) {
              BlocProvider.of<FormBloc>(context).add(PasswordChanged(value));
            },
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
              errorText: error,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Icon(
                  Icons.lock,
                  size: height * 0.038,
                  color: Colors.grey,
                ),
              ),
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
          ),
        );
      },
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String? errorMessage;
  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
