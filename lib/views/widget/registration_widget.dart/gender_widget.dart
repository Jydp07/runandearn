import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/views/common/text.dart';

class GenderWidget extends StatefulWidget {
  const GenderWidget({super.key});

  @override
  State<GenderWidget> createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.08,
      width: width * 0.95,
      decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 0.2)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              FontAwesomeIcons.userGroup,
              color: Colors.grey,
            ),
            SizedBox(
              width: width * 0.03,
            ),
            Expanded(
              child: DropdownButton(
                hint: BlocBuilder<FormBloc, FormsValidate>(
                  builder: (context, state) {
                    if (state.gender.isNotEmpty) {
                      return NormText(
                        title: state.gender,
                        color: Colors.grey,
                      );
                    }
                    return const NormText(
                      title: "Choose a gender",
                      color: Colors.grey,
                    );
                  },
                ),
                elevation: 5,
                underline: const SizedBox(),
                dropdownColor: Colors.black87,
                onChanged: (value) {
                  BlocProvider.of<FormBloc>(context).add(GenderChanged(value!));
                },
                items: const [
                  DropdownMenuItem(
                      value: "Male", child: NormText(title: "Male")),
                  DropdownMenuItem(
                    value: "Female",
                    child: NormText(title: "Female"),
                  ),
                  DropdownMenuItem(
                    value: "Other",
                    child: NormText(title: "Other"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
