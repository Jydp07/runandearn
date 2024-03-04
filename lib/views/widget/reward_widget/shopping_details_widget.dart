import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/user_address_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class ShoppingDetailsWidget extends StatelessWidget {
  const ShoppingDetailsWidget({super.key, required this.shoppingModel});
  final ShoppingModel shoppingModel;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFF232323),
            body: BlocBuilder<ShoppingBloc, ShoppingState>(
                builder: (context, state) {
              final data = shoppingModel;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(children: [
                            SizedBox(
                              height: height * 0.3,
                              width: double.infinity,
                              child: Hero(
                                tag: data.uid!,
                                child: CachedNetworkImage(
                                  imageUrl: data.image!,
                                  placeholder: (context, url) =>
                                      Image.memory(kTransparentImage),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.chevron_left_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.black)),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.black)),
                                )
                              ],
                            )
                          ]),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/svg/coin.svg",
                                        height: height * 0.03),
                                    TitleText(title: "${data.price}"),
                                  ],
                                ),
                                SubtitleText(
                                  title: data.name ?? "",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                Text(
                                  data.description ?? "",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: height * 0.015),
                                  textAlign: TextAlign.justify,
                                ),
                                SizedBox(
                                  height: height * 0.05,
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    height: height * 0.3,
                                    child: CarouselSlider.builder(
                                        itemCount: data.multipleImage?.length,
                                        itemBuilder: (context, index, indexe) {
                                          return CachedNetworkImage(
                                            imageUrl:
                                                data.multipleImage?[index],
                                            placeholder: (context, url) =>
                                                Image.memory(kTransparentImage),
                                          );
                                        },
                                        options: CarouselOptions(
                                            height: 400,
                                            aspectRatio: 16 / 9,
                                            viewportFraction: 0.8,
                                            initialPage: 0,
                                            autoPlay: false,
                                            autoPlayInterval:
                                                const Duration(seconds: 3),
                                            autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: true,
                                            enlargeFactor: 0.3,
                                            scrollDirection: Axis.horizontal))),
                                SizedBox(
                                  height: height * 0.05,
                                ),
                                NormText(
                                  title: "${data.name} Details",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                Text(
                                  data.moreDescription ?? "",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: height * 0.015),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: width * 0.08),
                      child: BlocBuilder<ShoppingBloc, ShoppingState>(
                        builder: (context, state) {
                          return MyButton(
                            onTap: () {
                              state.buySuccess
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                                create: (context) =>
                                                    ShoppingBloc()
                                                      ..add(OnGetUserAdress())
                                                      ..add(OnBuySuccess(
                                                          price: shoppingModel
                                                                  .price ??
                                                              0)),
                                                child: UserAddressScreen(
                                                  shoppingModel: shoppingModel,
                                                ),
                                              )))
                                  : showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.black,
                                          content: const MiniText(
                                              title:
                                                  "You don't have enough coin to buy this product"),
                                          title: const NormText(
                                              title: "Insufficiant Balance"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child:
                                                  const MiniText(title: "Okay"),
                                            )
                                          ],
                                        );
                                      });
                            },
                            height: height * 0.07,
                            width: width * 0.85,
                            child: NormText(
                              title: "Buy now at ¢${data.price}",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            })));
  }
}

// class _ShoppingDetailsSkelaton extends StatelessWidget {
//   const _ShoppingDetailsSkelaton();

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: height * 0.3,
//                   width: double.infinity,
//                   child: Shimmer.fromColors(
//                       baseColor: Colors.grey,
//                       highlightColor: Colors.white,
//                       child:
//                           SvgPicture.asset("assets/svg/cycling_challenge.svg")),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Shimmer.fromColors(
//                     baseColor: Colors.grey,
//                     highlightColor: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Container(
//                           height: height * 0.03,
//                           width: width * 0.5,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.02,
//                         ),
//                         Container(
//                           height: height * 0.015,
//                           width: width * 0.9,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Container(
//                           height: height * 0.015,
//                           width: width * 0.9,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Container(
//                           height: height * 0.015,
//                           width: width * 0.9,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Container(
//                           height: height * 0.015,
//                           width: width * 0.45,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.05,
//                         ),
//                         SizedBox(
//                             width: double.infinity,
//                             height: height * 0.3,
//                             child: SvgPicture.asset(
//                                 "assets/svg/cycling_challenge.svg")),
//                         SizedBox(
//                           height: height * 0.05,
//                         ),
//                         Container(
//                           height: height * 0.02,
//                           width: width * 0.5,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.02,
//                         ),
//                         Container(
//                           height: height * 0.015,
//                           width: width * 0.9,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Container(
//                           height: height * 0.015,
//                           width: width * 0.9,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Container(
//                           height: height * 0.015,
//                           width: width * 0.9,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         Container(
//                           height: height * 0.015,
//                           width: width * 0.45,
//                           color: Colors.grey,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30), topRight: Radius.circular(30))),
//           child: Padding(
//             padding:
//                 EdgeInsets.symmetric(vertical: 8.0, horizontal: width * 0.08),
//             child: BlocBuilder<ShoppingBloc, ShoppingState>(
//               builder: (context, state) {
//                 return MyButton(
//                   onTap: () {},
//                   height: height * 0.07,
//                   width: width * 0.85,
//                   child: const NormText(
//                     title: "Buy now",
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
