import 'package:flutter/material.dart';
import 'package:runandearn/views/common/text.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 15,
                      color: Colors.white,
                    ),
                    NormText(title: " Steps")
                  ],
                )),
                SizedBox(
                  width: width * 0.05,
                ),
                const Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: Colors.blue,
                      ),
                      NormText(title: " Coins")
                    ],
                  ),
                ),
              ],
            );
  }
}