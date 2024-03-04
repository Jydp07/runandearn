import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class HeightWidget extends StatefulWidget {
  const HeightWidget({super.key});

  @override
  State<HeightWidget> createState() => _HeightWidgetState();
}

class _HeightWidgetState extends State<HeightWidget> {
  String selectedValue = "Ft";
  final heightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.95,
      height: height * 0.08,
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<FormBloc, FormsValidate>(
              builder: (context, state) {
                return MyTextField(
                  title: "Your Height",
                  hintText: "Your Height",
                  prefix: FontAwesomeIcons.textHeight,
                  textInputType: TextInputType.number,
                  controller: heightController,
                  erroMsg: state.isHeightValid ? null : "Enter height",
                  onChange: (value) {
                    if (value != "") {
                      double height = double.parse(value);
                      BlocProvider.of<FormBloc>(context)
                          .add(HeightChanged(height));
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              height: height * 0.078,
              width: width * 0.16,
              decoration: BoxDecoration(
                  color: const Color(0xFFAFEA0D),
                  borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: DropdownButton(
                  items: const [
                    DropdownMenuItem(
                      value: "Ft",
                      child: SubtitleText(
                        title: "Ft",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownMenuItem(
                      value: "In",
                      child: SubtitleText(
                        title: "In",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Cm",
                      child: SubtitleText(
                        title: "Cm",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                  iconSize: 10,
                  underline: const SizedBox(),
                  dropdownColor: Colors.black,
                  hint: SubtitleText(
                    title: selectedValue,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    super.dispose();
  }
}
