// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/auth_bloc/authentication_bloc.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/logic/cubit/visibility_cubit/visibility_cubit_cubit.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
            if (state is AuthenticationSuccess) {
              Navigator.pushNamedAndRemoveUntil(context, "/AdminScreen", (route) => false);
            }
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF232323),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  const NormText(title: "Hey admin welcome"),
                  SizedBox(
                    height: height * 0.2,
                  ),
                  MyTextField(
                    title: "Admin Email",
                    prefix: Icons.email,
                    controller: emailController,
                    onChange: (value) {
                      BlocProvider.of<FormBloc>(context)
                          .add(EmailChanged(value));
                    },
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  _PasswordTextField("Enter Password", passwordController),
                  SizedBox(
                    height: height * 0.2,
                  ),
                  MyButton(
                      onTap: () {
                        BlocProvider.of<FormBloc>(context).add(
                            const FormSubmittedSignUp(value: Status.signIn));
                      },
                      height: height * 0.07,
                      width: width * 0.8,
                      child: const NormText(title: "LogIn"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField(this.title, this.controller);
  final String title;
  final TextEditingController? controller;
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
            controller: controller,
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
