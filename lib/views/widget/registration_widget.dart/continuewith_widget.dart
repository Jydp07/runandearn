import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/auth_bloc/authentication_bloc.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/views/common/text.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const NormText(
          title: "Or continue with",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: BlocBuilder<FormBloc, FormsValidate>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.read<AuthenticationBloc>().add(AuthenticationGoogleStarted());
                  BlocProvider.of<FormBloc>(context).add(const FormSubmittedSignUp(value: Status.signInWithGoogle));
                },
                child: SizedBox(
                  height: height*0.08,
                  width: width*0.9,
                  child: Card(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                            ),
                            SizedBox(width: width*0.02,),
                            const NormText(title: "Continue with google")
                          ],
                        ),
                      )),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
