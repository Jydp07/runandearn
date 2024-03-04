import 'package:flutter/material.dart';
import 'package:runandearn/views/common/text.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.title,
      this.hintText,
      this.prefix,
      this.suffix,
      this.maxLine,
      this.textInputType,
      this.erroMsg,
      this.maxLength,
      this.controller, this.onChange, });
  final String title;
  final String? hintText;
  final IconData? prefix;
  final IconData? suffix;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final String? erroMsg;
  final ValueChanged? onChange;
  final int? maxLine;
  final int? maxLength;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: hintText,
          label: Padding(
            padding: EdgeInsets.only(left: width*0.07),
            child: NormText(
              title: title,
              color: Colors.grey,
            ),
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left:width*0.03),
            child: Icon(prefix,size: height*0.038,color: Colors.grey,),
          ),
          prefixIconConstraints:
              BoxConstraints.tight(const Size(25, 25)),
          constraints: BoxConstraints(
              maxWidth: width > 600 ? width * 0.4 : width * 0.95),
          suffix: Icon(
            suffix,
            color: Colors.grey,
          ),
          errorText: erroMsg,
          prefix: SizedBox(width: width*0.06,)
        ),
        maxLength: maxLength,
        maxLines: maxLine,
        style: const TextStyle(
          color: Colors.white,
        ),
        onChanged: onChange,
      ),
    );
  }
}
