import 'package:flutter/material.dart';
import 'package:runandearn/views/common/text.dart';

class ActiveWidget extends StatelessWidget {
  const ActiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height * 0.25,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NormText(
                title: "You aren't part of any challenge",
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: height * 0.06,
                  width: width * 0.5,
                  decoration: BoxDecoration(
                      color: const Color(0xFFAFEA0D),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFAFEA0D).withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(
                              0,
                              height *
                                  0.001), // You can adjust the offset as needed
                        ),
                      ]),
                  child: Center(
                    child: Text(
                      "Start challenges",
                      style: TextStyle(
                          color: const Color(0xFF151515),
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
