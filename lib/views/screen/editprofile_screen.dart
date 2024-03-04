import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/databse_bloc/database_bloc.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';
import 'package:runandearn/views/screen/myprofile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const NormText(
          title: "Edit Profile",
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.chevron_left_outlined,
              color: Colors.white,
            )),
      ),
      backgroundColor: const Color(0xFF232323),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<DatabaseBloc, DatabaseState>(
            builder: (context, state) {
              if (state is DatabaseSuccess) {
                nameController.text = state.userData.name!;
                numberController.text = state.userData.number ?? "";
                heightController.text = state.userExtraData.height!.toString();
                weightController.text = state.userExtraData.weight!.toString();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    MyTextField(
                      title: "Name",
                      controller: nameController,
                      prefix: Icons.person,
                      hintText: "Name",
                      erroMsg: nameController.text.isNotEmpty
                          ? null
                          : "Enter valid name",
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    MyTextField(
                      title: "Number",
                      controller: numberController,
                      prefix: Icons.phone,
                      hintText: "Number",
                      erroMsg: numberController.text.length != 10
                          ? null
                          : "Enter valid Number",
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    MyTextField(
                      title: "Height",
                      controller: heightController,
                      prefix: Icons.height,
                      hintText: "Height",
                      erroMsg: heightController.text.isNotEmpty
                          ? null
                          : "Enter valid Height",
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    MyTextField(
                      title: "Weight",
                      controller: weightController,
                      prefix: Icons.monitor_weight,
                      hintText: "Weight",
                      erroMsg: weightController.text.isNotEmpty
                          ? null
                          : "Enter valid Weight",
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: height * 0.08,
                    ),
                    MyButton(
                        onTap: () {
                          final userHeight =
                              double.parse(heightController.text);
                          final userWeight =
                              double.parse(weightController.text);
                          BlocProvider.of<DatabaseBloc>(context).add(
                              UpdateUserData(
                                  name: nameController.text,
                                  number: numberController.text,
                                  height: userHeight,
                                  weight: userWeight));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                        create: (context) => DatabaseBloc(
                                            DatabaseRepositoryImpl())
                                          ..add(const DatabaseFetched()),
                                        child: const MyProfile(),
                                      )));
                        },
                        height: height * 0.08,
                        width: width * 0.9,
                        child: const NormText(
                          title: "Update",
                          color: Colors.black,
                        ))
                  ],
                );
              }
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }
}


