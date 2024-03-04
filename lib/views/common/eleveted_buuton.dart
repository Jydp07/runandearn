import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap, required this.child, required this.height, required this.width});
  final VoidCallback onTap;
  final Widget child;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: onTap,
            child: Container(
                height: height ,
                width: width,
                decoration: BoxDecoration(
                    color: const Color(0xFFAFEA0D),
                    borderRadius: BorderRadius.circular(30),
                    ),
                child: Center(
                    child: child)),
          );
  }
}