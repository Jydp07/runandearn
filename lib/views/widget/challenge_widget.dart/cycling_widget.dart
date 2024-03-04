import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CyclingWidget extends StatelessWidget {
  const CyclingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/svg/cycling_challenge.svg",fit: BoxFit.fill,);
  }
}