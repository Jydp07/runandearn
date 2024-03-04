import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/widget/reward_widget/shopping_details_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class RewardOrederHistory extends StatelessWidget {
  const RewardOrederHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left_rounded),
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          title: const NormText(title: "Order History"),
        ),
        backgroundColor: const Color(0xFF232323),
        body:
            BlocBuilder<ShoppingBloc, ShoppingState>(builder: (context, state) {
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
                final orderData = state.orderStatus;
                final user = state.userUid;
                final date = orderData[index].date?.toDate();
                final formatedDate =
                    DateFormat("HH:mm, dd MMM yyyy").format(date!);
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: height * 0.005),
                  child: Container(
                    height: height * 0.09,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12)),
                    child: data[index].image != null
                        ? ListTile(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                            create: (context) => ShoppingBloc()
                                              ..add(OnBuy(
                                                  price: state
                                                          .shoppingData[index]
                                                          .price ??
                                                      0)),
                                            child: ShoppingDetailsWidget(
                                              shoppingModel: data[index],
                                            ),
                                          )));
                            },
                            onLongPress: () {
                              if (orderData[index].shoppingStatus ==
                                  'ShoppingStatus.pending') {
                                showDialog(
                                    context: context,
                                    builder: (context) => BlocProvider(
                                          create: (context) => ShoppingBloc(),
                                          child: BlocBuilder<ShoppingBloc,
                                              ShoppingState>(
                                            builder: (context, state) {
                                              return AlertDialog(
                                                backgroundColor: Colors.black,
                                                content: BlocListener<
                                                    ShoppingBloc,
                                                    ShoppingState>(
                                                  listener: (context, state) {
                                                    if (state.isCancel) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: TextButton.icon(
                                                      onPressed: () {
                                                        BlocProvider.of<ShoppingBloc>(
                                                                context)
                                                            .add(OnChangeOrderStatus(
                                                                uid: user,
                                                                price:
                                                                    data[index]
                                                                        .price!,
                                                                shopId: orderData[
                                                                        index]
                                                                    .uid!,
                                                                status:
                                                                    '${ShoppingStatus.cancel}'));
                                                      },
                                                      icon: const Icon(
                                                          Icons.cancel),
                                                      label: const MiniText(
                                                          title:
                                                              "Cancel Order")),
                                                ),
                                              );
                                            },
                                          ),
                                        )).then((value) {
                                  BlocProvider.of<ShoppingBloc>(context)
                                      .add(OnGetUserShoppingData());
                                });
                              }
                            },
                            contentPadding: EdgeInsets.symmetric(
                                vertical: height * 0.003,
                                horizontal: width * 0.04),
                            leading: FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(
                                data[index].image!,
                              ),
                              fit: BoxFit.fill,
                            ),
                            title: NormText(title: data[index].name!),
                            subtitle: Row(
                              children: [
                                SvgPicture.asset("assets/svg/coin.svg"),
                                MiniText(title: "${data[index].price}"),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MiniText(
                                    title: state
                                        .orderStatus[index].shoppingStatus!
                                        .substring(15)
                                        .toUpperCase()),
                                Text(
                                  formatedDate,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.01),
                                )
                              ],
                            ),
                          )
                        : const ListTile(
                            leading: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            title: NormText(title: "Product not available"),
                          ),
                  ),
                );
              },
            );
          }
        }));
  }
}
