import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.title,this.color = Colors.white});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.height*0.025;
    return Text(title,style: GoogleFonts.lato(color: color,fontSize: fontsize,fontWeight: FontWeight.bold),);
  }
}

class NormText extends StatelessWidget {
  const NormText({super.key, required this.title, this.fontWeight,this.color = Colors.white});
  final String title;
  final FontWeight? fontWeight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.height*0.018;
    return Text(title,style: GoogleFonts.lato(color: color,fontSize: fontsize,fontWeight: fontWeight),);
  }
}

class MiniText extends StatelessWidget {
  const MiniText({super.key, required this.title, this.fontWeight,this.color = Colors.white});
  final String title;
  final FontWeight? fontWeight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.height*0.016;
    return Text(title,style: GoogleFonts.lato(color: color,fontSize: fontsize,fontWeight: fontWeight),);
  }
}
class LinkText extends StatelessWidget {
 const LinkText({super.key, required this.title, this.fontWeight,this.color = Colors.blue});
  final String title;
  final FontWeight? fontWeight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.height*0.02;
    return Text(title,style: GoogleFonts.lato(color: color,fontSize: fontsize,fontWeight: fontWeight),);
  }
}

class SubtitleText extends StatelessWidget {
  const SubtitleText({super.key, required this.title, this.fontWeight,this.color = Colors.blue});
  final String title;
  final FontWeight? fontWeight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.height*0.022;
    return Text(title,style: GoogleFonts.lato(color: color,fontSize: fontsize,fontWeight: fontWeight),);
  }
}

