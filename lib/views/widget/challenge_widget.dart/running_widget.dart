import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RunningWidget extends StatelessWidget {
  const RunningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/svg/running_challenge.svg",fit: BoxFit.fill,);
  }
}