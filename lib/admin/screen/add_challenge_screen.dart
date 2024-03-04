import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/challenge_bloc/challenge_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class AddChallengeScreen extends StatelessWidget {
  const AddChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const NormText(
          title: "Add Challenges",
        ),
      ),
      backgroundColor: const Color(0xFF232323),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              BlocBuilder<ChallengeBloc, ChallengeState>(
                builder: (context, state) {
                  return MyTextField(
                    title: "Challenge Name",
                    onChange: (value) {
                      BlocProvider.of<ChallengeBloc>(context)
                          .add(OnNameChanged(name: value));
                    },
                    erroMsg:
                        state.isNamevalid ? null : "Enter valid challenge name",
                  );
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              BlocBuilder<ChallengeBloc, ChallengeState>(
                builder: (context, state) {
                  return MyTextField(
                    title: "Challenge Money",
                    textInputType: TextInputType.number,
                    onChange: (value) {
                      BlocProvider.of<ChallengeBloc>(context).add(
                          OnPriceChanged(
                              price: value == "" ? 0 : double.parse(value)));
                    },
                    erroMsg:
                        state.isPriceValid ? null : "Enter valid prize money",
                  );
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              BlocBuilder<ChallengeBloc, ChallengeState>(
                builder: (context, state) {
                  return MyTextField(
                    title: "Challenge Steps",
                    textInputType: TextInputType.number,
                    onChange: (value) {
                      BlocProvider.of<ChallengeBloc>(context).add(
                          OnStepsChanges(
                              steps: value == "" ? 0 : int.parse(value)));
                    },
                    erroMsg:
                        state.isStepsValid ? null : "Enter steps more 1000",
                  );
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              BlocBuilder<ChallengeBloc, ChallengeState>(
                builder: (context, state) {
                  return MyTextField(
                    title: "Challenge Description",
                    onChange: (value) {
                      BlocProvider.of<ChallengeBloc>(context)
                          .add(OnDescriptionChanged(description: value));
                    },
                    erroMsg: state.isDescriptionValid
                        ? null
                        : "Enter valid description",
                  );
                },
              ),
              SizedBox(height: height*0.02,),
              BlocBuilder<ChallengeBloc, ChallengeState>(
                builder: (context, state) {
                  return MyTextField(
                    textInputType: TextInputType.number,
                    title: "Challenge Limit in day",
                    onChange: (value) {
                      BlocProvider.of<ChallengeBloc>(context)
                          .add(OnTimeLimitChanged(dayLimit:value!=''? int.parse(value) : 1));
                    },
                  );
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              BlocBuilder<ChallengeBloc, ChallengeState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<ChallengeBloc>(context)
                          .add(const OnImageChanged());
                    },
                    child: Container(
                      height: height * 0.3,
                      width: width * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: BlocBuilder<ChallengeBloc, ChallengeState>(
                        builder: (context, state) {
                          if (state.image.path.isNotEmpty) {
                            return Image.file(
                              state.image,
                              fit: BoxFit.contain,
                            );
                          }
                          return Center(
                            child: state.error == ""
                                ? Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                    size: height * 0.05,
                                  )
                                : MiniText(
                                    title: state.error,
                                    color: Colors.red,
                                  ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: height * 0.08,
              ),
              BlocConsumer<ChallengeBloc, ChallengeState>(
                listener: (context, state) {
                  if (state.isSubmitSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: MiniText(title: "Data Added"),
                    ));
                    Navigator.pop(context);
                  } else if (!state.isDataValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: MiniText(title: state.error),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return MyButton(
                      onTap: () {
                        state.isLoading ? null : BlocProvider.of<ChallengeBloc>(context)
                            .add(OnSubmitData());
                      },
                      height: height * 0.07,
                      width: width * 0.8,
                      child: state.isLoading ? const CircularProgressIndicator(color: Colors.black,) : const NormText(
                        title: "Add Challenge",
                        color: Colors.black,
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
