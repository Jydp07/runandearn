import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/views/common/text.dart';

class DOB extends StatefulWidget {
  const DOB({super.key});

  @override
  State<DOB> createState() => _DOBState();
}

class _DOBState extends State<DOB> {
  DateTime? date;
  String? formatedDate;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        date = await showDatePicker(
            context: context,
            firstDate: DateTime(1960),
            lastDate: DateTime(2015));
        if (date != null) {
          formatedDate = DateFormat.yMMMd().format(date!);
          // ignore: use_build_context_synchronously
          BlocProvider.of<FormBloc>(context).add(DOBChanged(formatedDate!));
        }
        // ignore: use_build_context_synchronously
      },
      child: Container(
        height: height * 0.08,
        width: width * 95,
        decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 0.2)),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                FontAwesomeIcons.calendar,
                color: Colors.grey,
              ),
            ),
            Center(child: BlocBuilder<FormBloc, FormsValidate>(
              builder: (context, state) {
                if (state.dob.isNotEmpty) {
                  return NormText(
                    title: "Your DOB is ${state.dob}",
                    color: Colors.grey,
                  );
                } else {
                  return const NormText(
                    title: "Date of birth",
                    color: Colors.grey,
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
