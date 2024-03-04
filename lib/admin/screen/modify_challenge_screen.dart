import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/challenge_bloc/challenge_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:transparent_image/transparent_image.dart';

class ModifyChallengeScreen extends StatelessWidget {
  const ModifyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const SubtitleText(
          title: "Modify Shopping Data",
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF232323),
      body: BlocBuilder<ChallengeBloc, ChallengeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (state.error.isNotEmpty) {
            return Center(
              child: NormText(title: state.error),
            );
          } else if (state.challengeData.isEmpty) {
            return const Center(
              child: NormText(title: "Nothing to show"),
            );
          } else {
            return ListView.builder(
              itemCount: state.challengeData.length,
              itemBuilder: (context, index) {
                final data = state.challengeData;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: height * 0.005),
                  child: Container(
                    height: height * 0.09,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      onTap: () {
                        
                      },
                      onLongPress: () {
                        showDialog(
                                context: context,
                                builder: (context) {
                                  return BlocProvider(
                                    create: (context) => ChallengeBloc(),
                                    child: BlocBuilder<ChallengeBloc,
                                        ChallengeState>(
                                      builder: (context, state) {
                                        return _UpdateDeleteDialog(index, data);
                                      },
                                    ),
                                  );
                                },
                                barrierDismissible: false)
                            .then((value) => {
                                  BlocProvider.of<ChallengeBloc>(context)
                                      .add(const OnGetChallengeData())
                                });
                      },
                      contentPadding: EdgeInsets.symmetric(
                          vertical: height * 0.003, horizontal: width * 0.04),
                      leading: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(
                          data[index].image!,
                        ),
                        fit: BoxFit.fill,
                      ),
                      title: NormText(title: data[index].name!),
                      subtitle: MiniText(title: "Prize money ¢${data[index].prize}"),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MiniText(title: data[index].steps.toString(),),
                          Text("Time limit ${data[index].dayLimit} day",style: TextStyle(color: Colors.white,fontSize: height*0.01),)
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _UpdateDeleteDialog extends StatelessWidget {
  const _UpdateDeleteDialog(this.index, this.data);
  final int index;
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextButton.icon(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: Colors.black,
                    icon: const Icon(Icons.delete,color: Colors.red,),
                    title: const NormText(title: "Are you sure?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<ChallengeBloc>(context).add(
                                OnDeleteChallenge(uid: data[index].uid));
                            Navigator.pop(
                              context,
                            );
                          },
                          child: const MiniText(title: "Yes")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const MiniText(title: "No"))
                    ],
                  );
                });
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          label: const MiniText(title: "Delete"),
        ),
        // TextButton.icon(
        //   onPressed: () {
            
        //   },
        //   icon: const Icon(
        //     Icons.update,
        //     color: Colors.white,
        //   ),
        //   label: const MiniText(title: "Update"),
        // )
      ]),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const MiniText(title: "Cancel"))
      ],
    );
  }
}