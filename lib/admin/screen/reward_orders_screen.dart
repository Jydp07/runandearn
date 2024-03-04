import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:runandearn/admin/widget/reward_order_details.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:transparent_image/transparent_image.dart';

class RewardOrdersScreen extends StatelessWidget {
  const RewardOrdersScreen({super.key});

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
                final orderData = state.orderStatus;
                final userData = state.userData[index];
                final date = orderData[index].date?.toDate();
                final formatedDate =
                    DateFormat("HH:mm,dd MMM yyyy").format(date!);
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
                                      create: (context) => ShoppingBloc(),
                                      child: RewardOrderDetails(
                                        shoppingModel:
                                            state.shoppingData[index],
                                        userModel: state.userData[index],
                                      ),
                                    )));
                      },
                      onLongPress: () {
                        if (orderData[index].shoppingStatus ==
                                'ShoppingStatus.pending' ||
                            orderData[index].shoppingStatus ==
                                'ShoppingStatus.dispatch' ||
                            orderData[index].shoppingStatus ==
                                'ShoppingStatus.delivered') {
                          showDialog(
                              context: context,
                              builder: (context) => BlocProvider(
                                    create: (context) => ShoppingBloc(),
                                    child: BlocBuilder<ShoppingBloc,
                                        ShoppingState>(
                                      builder: (context, state) {
                                        return AlertDialog(
                                          backgroundColor: Colors.black,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton.icon(
                                                  onPressed: () {
                                                    BlocProvider.of<ShoppingBloc>(
                                                            context)
                                                        .add(OnChangeOrderStatus(
                                                            uid: userData.uid!,
                                                            price: data[index]
                                                                .price!,
                                                            shopId:
                                                                orderData[index]
                                                                    .uid!,
                                                            status:
                                                                '${ShoppingStatus.dispatch}'));
                                                  },
                                                  icon: const Icon(Icons
                                                      .delivery_dining_outlined),
                                                  label: const MiniText(
                                                      title: "Dispatch Order")),
                                              BlocListener<ShoppingBloc,
                                                  ShoppingState>(
                                                listener: (context, state) {
                                                  if(state.isCancel){
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: TextButton.icon(
                                                    onPressed: () {
                                                      BlocProvider
                                                              .of<
                                                                      ShoppingBloc>(
                                                                  context)
                                                          .add(OnChangeOrderStatus(
                                                              uid: orderData[
                                                                      index]
                                                                  .uid!,
                                                              price:
                                                                  data[index]
                                                                      .price!,
                                                              shopId: orderData[
                                                                      index]
                                                                  .shopId!,
                                                              status:
                                                                  '${ShoppingStatus.delivered}'));
                                                    },
                                                    icon:
                                                        const Icon(Icons.done),
                                                    label: const MiniText(
                                                        title:
                                                            "Delivered Order")),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )).then((value) {
                            BlocProvider.of<ShoppingBloc>(context)
                                .add(OnGetAllUserShoppingData());
                          });
                        }
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
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MiniText(
                              title: state.orderStatus[index].shoppingStatus!
                                  .substring(15)
                                  .toUpperCase()),
                          Text(
                            formatedDate,
                            style: TextStyle(
                                color: Colors.white, fontSize: height * 0.01),
                          )
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
