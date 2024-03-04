import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/logic/bloc/shoppingform_bloc/shoppingform_bloc.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class UpdateShoppingData extends StatefulWidget {
  const UpdateShoppingData({super.key, required this.index});
  final int index;
  @override
  State<UpdateShoppingData> createState() => _UpdateShoppingDataState();
}

class _UpdateShoppingDataState extends State<UpdateShoppingData> {
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
            title: "Update Shopping Data",
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF232323),
        body: BlocBuilder<ShoppingBloc, ShoppingState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (state.error.isNotEmpty) {
              return Center(
                child: NormText(title: state.error),
              );
            } else if (state.shoppingData.isEmpty) {
              return const Center(
                child: NormText(title: "Nothing to show"),
              );
            } else {
              final data = state.shoppingData[widget.index];
              nameController.text = data.name ?? "";
              priceController.text = data.price.toString();
              descriptionController.text = data.description ?? "";
              moreDescriptionController.text = data.moreDescription ?? "";
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      MyTextField(
                        title: "Product Name",
                        controller: nameController,
                        prefix: Icons.shopping_cart,
                        onChange: (value) {
                          BlocProvider.of<ShoppingformBloc>(context)
                              .add(OnNameChanged(name: value));
                        },
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      MyTextField(
                        title: "Product Price",
                         textInputType: TextInputType.number,
                        prefix: Icons.attach_money,
                        controller: priceController,
                        onChange: (value) {
                          if (value != "") {
                            final price = double.parse(value);
                            BlocProvider.of<ShoppingformBloc>(context)
                                .add(OnPriceChanged(price: price));
                          }
                        },
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<ShoppingformBloc>(context)
                              .add(const OnImageChanged());
                        },
                        child: Container(
                          height: height * 0.3,
                          width: width * 0.95,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              BlocBuilder<ShoppingformBloc, ShoppingformState>(
                            builder: (context, state) {
                              if (data.image!.isNotEmpty) {
                                return state.image.path.isEmpty ? Image.network(
                                  data.image!,
                                  fit: BoxFit.contain,
                                ) : Image.file(state.image);
                              }
                              return Center(
                                child: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: height * 0.05,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      MyTextField(
                        title: "Product Description",
                        prefix: Icons.description,
                        hintText: "Description",
                        controller: descriptionController,
                        maxLength: 1000,
                        maxLine: 8,
                        onChange: (value) {
                          BlocProvider.of<ShoppingformBloc>(context)
                              .add(OnDescriptionChanged(description: value));
                        },
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      const MiniText(
                        title: "Pick Multiple Image",
                        color: Colors.grey,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<ShoppingformBloc>(context)
                              .add(const OnMultipleImageChanged());
                        },
                        child: Container(
                          height: height * 0.3,
                          width: width * 0.95,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              BlocBuilder<ShoppingformBloc, ShoppingformState>(
                            builder: (context, state) {
                              if (data.multipleImage!.isEmpty) {
                                return Center(
                                  child: Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                    size: height * 0.04,
                                  ),
                                );
                              }
                              return CarouselSlider.builder(
                                  itemCount: state.multipleImage.isEmpty ? data.multipleImage?.length : state.multipleImage.length,
                                  itemBuilder: (context, index, indexes) {
                                    return state.multipleImage.isEmpty ?
                                    Image.network(
                                        data.multipleImage?[index]) : Image.file(state.multipleImage[index]);
                                  },
                                  options: CarouselOptions(
                                      initialPage: 0,
                                      autoPlay: false,
                                      scrollDirection: Axis.horizontal));
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      MyTextField(
                        title: "More Discription",
                        prefix: Icons.description,
                        maxLength: 1500,
                        maxLine: 8,
                        controller: moreDescriptionController,
                        onChange: (value) {
                          BlocProvider.of<ShoppingformBloc>(context).add(
                              OnMoreDescriptionChanged(moreDescription: value));
                        },
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      MyButton(
                        onTap: () {
                          BlocProvider.of<ShoppingformBloc>(context)
                              .add(OnUpdateShoppingData(data.uid!));
                          FocusScope.of(context).unfocus();
                        },
                        height: height * 0.07,
                        width: width * 0.8,
                        child:
                            BlocConsumer<ShoppingformBloc, ShoppingformState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              );
                            }
                            return const NormText(
                              title: "Update Data",
                              color: Colors.black,
                            );
                          },
                          listener:
                              (BuildContext context, ShoppingformState state) {
                            if (state.isSubmitSuccess) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: MiniText(title: "Data Updated"),
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
                      ),
                    ],
                  ),
                ),
              );
            }
          },
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
