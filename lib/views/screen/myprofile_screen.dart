import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/auth_bloc/authentication_bloc.dart';
import 'package:runandearn/logic/bloc/databse_bloc/database_bloc.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/logic/cubit/visibility_cubit/visibility_cubit_cubit.dart';
import 'package:runandearn/repository/authentication_repository.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/editprofile_screen.dart';
import 'package:runandearn/views/screen/login_screen.dart';
import 'package:shimmer/shimmer.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const NormText(title: "My Profile"),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF232323),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<DatabaseBloc, DatabaseState>(
                builder: (context, state) {
                  if (state is DatabaseSuccess) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: NormText(
                              title: state.userData.name!,
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.mail),
                            title: NormText(
                              title: state.userData.email!,
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: NormText(
                              title: state.userData.number ?? "Update mobile",
                              color: Colors.black,
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: NormText(
                                    title: state.userExtraData.gender!,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  leading: const Icon(Icons.date_range),
                                  title: NormText(
                                    title: state.userExtraData.dob!,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: const Icon(Icons.height),
                                  title: NormText(
                                    title:
                                        state.userExtraData.height!.toString(),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  leading: const Icon(Icons.monitor_weight),
                                  title: NormText(
                                    title:
                                        state.userExtraData.weight!.toString(),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: _ProfileSkelaton());
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const NormText(
                        title: "Edit profile",
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) =>
                                          DatabaseBloc(DatabaseRepositoryImpl())
                                            ..add(const DatabaseFetched()),
                                      child: const EditProfileScreen(),
                                    )));
                      },
                    ),
                    const ListTile(
                      leading: Icon(Icons.help_outline),
                      title: NormText(
                        title: "Help and Support",
                        color: Colors.black,
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.message),
                      title: NormText(
                        title: "Contact Us",
                        color: Colors.black,
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.lock),
                      title: NormText(
                        title: "Privacy policy",
                        color: Colors.black,
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => BlocProvider(
                      create: (context) =>
                          AuthenticationBloc(AuthenticationRepositoryImpl()),
                      child: const _LogOutDialog(),
                    ));
          },
          leading: const Icon(
            Icons.logout_outlined,
            size: 26,
          ),
          title: const NormText(title: "LogOut",color: Colors.black,),
        ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSkelaton extends StatelessWidget {
  const _ProfileSkelaton();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Container(
                height: height * 0.03,
                width: width * 0.1,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.mail),
              title: Container(
                height: height * 0.03,
                width: width * 0.1,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: Container(
                height: height * 0.03,
                width: width * 0.1,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Row(
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Container(
                      height: height * 0.03,
                      width: width * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.date_range),
                    title: Container(
                      height: height * 0.03,
                      width: width * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.height),
                    title: Container(
                      height: height * 0.03,
                      width: width * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.monitor_weight),
                    title: Container(
                      height: height * 0.03,
                      width: width * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogOutDialog extends StatelessWidget {
  const _LogOutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const NormText(
        title: "Are you sure?",
        color: Colors.black,
      ),
      actions: [
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return TextButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationSignedOut());
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => VisibilityCubit(),
                                  ),
                                  BlocProvider(
                                    create: (context) => FormBloc(
                                        AuthenticationRepositoryImpl(),
                                        DatabaseRepositoryImpl()),
                                  ),
                                  BlocProvider(
                                    create: (context) => AuthenticationBloc(
                                        AuthenticationRepositoryImpl()),
                                  ),
                                ],
                                child: const LoginScreen(),
                              )));
                },
                child:
                    const Text("Yes", style: TextStyle(color: Colors.black)));
          },
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }
}
