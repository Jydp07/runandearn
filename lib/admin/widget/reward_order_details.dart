import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/views/common/text.dart';

class RewardOrderDetails extends StatelessWidget {
  const RewardOrderDetails({super.key, required this.shoppingModel, required this.userModel});
  final ShoppingModel shoppingModel;
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFF232323),
            body: BlocBuilder<ShoppingBloc, ShoppingState>(
                builder: (context, state) {
              final data = shoppingModel;
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(children: [
                        SizedBox(
                            height: height * 0.3,
                            width: double.infinity,
                            child: Image.network(data.image ?? "")),
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
                            TitleText(title: "¢${data.price}"),
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
                                      return Image.network(
                                          data.multipleImage?[index]);
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
                            SizedBox(
                              height: height * 0.05,
                            ),
                            const NormText(title: "User Adress"),
                            MiniText(title: userModel.address?[0]),
                            MiniText(title: userModel.address?[1]),
                            MiniText(title: userModel.address?[2]),
                            MiniText(title: userModel.address?[3])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })));
  }
}