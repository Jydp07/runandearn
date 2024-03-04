import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/admin/screen/shopping_data_details.dart';
import 'package:runandearn/admin/screen/update_shopping_data.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/logic/bloc/shoppingform_bloc/shoppingform_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:transparent_image/transparent_image.dart';

class ModifyShoppingData extends StatelessWidget {
  const ModifyShoppingData({super.key});

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
      body: BlocBuilder<ShoppingBloc, ShoppingState>(
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
          } else if (state.shoppingData.isEmpty) {
            return const Center(
              child: NormText(title: "Nothing to show"),
            );
          } else {
            return ListView.builder(
              itemCount: state.shoppingData.length,
              itemBuilder: (context, index) {
                final data = state.shoppingData;
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                      create: (context) => ShoppingBloc()
                                        ..add(const OnGetShoppingData()),
                                      child: AdminShoppingDetails(index: index),
                                    )));
                      },
                      onLongPress: () {
                        showDialog(
                                context: context,
                                builder: (context) {
                                  return BlocProvider(
                                    create: (context) => ShoppingBloc(),
                                    child: BlocBuilder<ShoppingBloc,
                                        ShoppingState>(
                                      builder: (context, state) {
                                        return _UpdateDeleteDialog(index, data);
                                      },
                                    ),
                                  );
                                },
                                barrierDismissible: false)
                            .then((value) => {
                                  BlocProvider.of<ShoppingBloc>(context)
                                      .add(const OnGetShoppingData())
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
                      subtitle: MiniText(title: "¢${data[index].price}"),
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
                            BlocProvider.of<ShoppingBloc>(context).add(
                                OnDeleteShoppingData(dataId: data[index].uid!));
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
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          ShoppingBloc()..add(const OnGetShoppingData()),
                    ),
                    BlocProvider(
                      create: (context) => ShoppingformBloc(),
                    )
                  ],
                  child: UpdateShoppingData(
                    index: index,
                  ),
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.update,
            color: Colors.white,
          ),
          label: const MiniText(title: "Update"),
        )
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
