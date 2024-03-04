import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class WeightWidget extends StatefulWidget {
  const WeightWidget({super.key});

  @override
  State<WeightWidget> createState() => _WeightWidgetState();
}

class _WeightWidgetState extends State<WeightWidget> {
  final weightController = TextEditingController();
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
                  title: "Your weight",
                  hintText: "Your weight",
                  prefix: FontAwesomeIcons.weightScale,
                  textInputType: TextInputType.number,
                  controller: weightController,
                  erroMsg: state.isWeightValid ? null : "Enter weight",
                  onChange: (value){
                    if(value != ""){
                      double weight = double.parse(value);
                      BlocProvider.of<FormBloc>(context).add(WeightChanged(weight));
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
              child: const Center(
                child: SubtitleText(
                  title: "Kg",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
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
    weightController.dispose();
    super.dispose();
  }
}
