import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/admin/widget/camera_widget.dart';
import 'package:runandearn/admin/widget/carousel_widget.dart';
import 'package:runandearn/logic/bloc/shoppingform_bloc/shoppingform_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class AddShoppingDataScreen extends StatefulWidget {
  const AddShoppingDataScreen({super.key});

  @override
  State<AddShoppingDataScreen> createState() => _AddShoppingDataScreenState();
}

class _AddShoppingDataScreenState extends State<AddShoppingDataScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final moreDescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const SubtitleText(
            title: "Add Shopping Data",
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF232323),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                BlocBuilder<ShoppingformBloc, ShoppingformState>(
                  builder: (context, state) {
                    return MyTextField(
                      title: "Product Name",
                      prefix: Icons.shopping_cart,
                      erroMsg: state.isNamevalid ? null : "Enter valid name",
                      onChange: (value) {
                        BlocProvider.of<ShoppingformBloc>(context)
                            .add(OnNameChanged(name: value));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                BlocBuilder<ShoppingformBloc, ShoppingformState>(
                  builder: (context, state) {
                    return MyTextField(
                      title: "Product Price",
                      prefix: Icons.attach_money,
                      textInputType: TextInputType.number,
                      erroMsg: state.isPriceValid ? null : "Enter valid price",
                      onChange: (value) {
                        BlocProvider.of<ShoppingformBloc>(context).add(
                            OnPriceChanged(
                                price: value == "" ? 0 : double.parse(value)));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                CameraWidget(
                  onTap: () {
                    BlocProvider.of<ShoppingformBloc>(context)
                        .add(const OnImageChanged());
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                BlocBuilder<ShoppingformBloc, ShoppingformState>(
                  builder: (context, state) {
                    return MyTextField(
                      title: "Product Description",
                      prefix: Icons.description,
                      hintText: "Description",
                      maxLength: 1000,
                      erroMsg: state.isDescriptionValid
                          ? null
                          : "Enter valid description",
                      maxLine: 8,
                      onChange: (value) {
                        BlocProvider.of<ShoppingformBloc>(context)
                            .add(OnDescriptionChanged(description: value));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                const MiniText(
                  title: "Pick Multiple Image",
                  color: Colors.grey,
                ),
                CarouselWidget(
                  onTap: () {
                    BlocProvider.of<ShoppingformBloc>(context)
                        .add(const OnMultipleImageChanged());
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                MyTextField(
                  title: "More Discription",
                  prefix: Icons.description,
                  maxLength: 1500,
                  maxLine: 8,
                  onChange: (value) {
                    BlocProvider.of<ShoppingformBloc>(context)
                        .add(OnMoreDescriptionChanged(moreDescription: value));
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                BlocBuilder<ShoppingformBloc, ShoppingformState>(
                  builder: (context, state) {
                    return MyButton(
                      onTap: () {
                       state.isLoading ? null : BlocProvider.of<ShoppingformBloc>(context)
                            .add(OnSubmitData());
                        FocusScope.of(context).unfocus();
                      },
                      height: height * 0.07,
                      width: width * 0.8,
                      child: BlocConsumer<ShoppingformBloc, ShoppingformState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          }
                          return const NormText(
                            title: "Add Data",
                            color: Colors.black,
                          );
                        },
                        listener:
                            (BuildContext context, ShoppingformState state) {
                          if (state.isSubmitSuccess) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: MiniText(title: "Data Added"),
                            ));
                            Navigator.pop(context);
                          } else if (!state.isDataValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: MiniText(title: state.error),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    moreDescriptionController.dispose();
    super.dispose();
  }
}
