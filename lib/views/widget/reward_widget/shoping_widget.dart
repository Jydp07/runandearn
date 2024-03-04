import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/widget/reward_widget/shopping_details_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class ShoppingWidget extends StatelessWidget {
  const ShoppingWidget({super.key});

  get itemBuilder => null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingBloc, ShoppingState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const _ShoppingSkelaton();
        } else if (state.error.isNotEmpty) {
          return Center(
            child: NormText(title: state.error),
          );
        } else if (state.shoppingData.isEmpty) {
          return const Center(
            child: NormText(title: "Nothing to show"),
          );
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: state.shoppingData.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 0.3)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (context) => ShoppingBloc()
                              ..add(OnBuy(
                                  price: state.shoppingData[index].price ?? 0)),
                            child: ShoppingDetailsWidget(
                              shoppingModel: state.shoppingData[index],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Expanded(
                            child: Hero(
                          tag: state.shoppingData[index].uid!,
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image:
                                CachedNetworkImageProvider(state.shoppingData[index].image!),
                            fit: BoxFit.fill,
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              NormText(
                                title: state.shoppingData[index].name ?? "",
                                color: Colors.white,
                              ),
                              Row(
                                children: [
                                  const MiniText(
                                    title: "At ",
                                    color: Color(0xFFAFEA0D),
                                  ),
                                  SvgPicture.asset("assets/svg/coin.svg"),
                                  MiniText(
                                      title:
                                          "${state.shoppingData[index].price}"),
                                  const MiniText(title: "  only",color: Color(0xFFAFEA0D),)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}

class _ShoppingSkelaton extends StatelessWidget {
  const _ShoppingSkelaton();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: 10,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 0.3)),
              child: GestureDetector(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                          child: SvgPicture.asset(
                        "assets/svg/cycling_challenge.svg",
                        fit: BoxFit.cover,
                      )),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.02,
                              width: width * 0.4,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              height: height * 0.015,
                              width: width * 0.35,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      }),
    );
  }
}
