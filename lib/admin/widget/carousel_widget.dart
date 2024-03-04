import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/shoppingform_bloc/shoppingform_bloc.dart';
import 'package:runandearn/views/common/text.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * 0.3,
        width: width * 0.95,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white, width: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: BlocBuilder<ShoppingformBloc, ShoppingformState>(
          builder: (context, state) {
            if (state.multipleImage.isEmpty) {
              return Center(
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                  size: height * 0.04,
                ),
              );
            }
            return CarouselSlider.builder(
                itemCount: state.multipleImage.length,
                itemBuilder: (context, index, indexes) {
                  return state.error == ""
                      ? Image.file(File(state.multipleImage[index].path))
                      : NormText(title: state.error);
                },
                options: CarouselOptions(
                    initialPage: 0,
                    autoPlay: false,
                    scrollDirection: Axis.horizontal));
          },
        ),
      ),
    );
  }
}
