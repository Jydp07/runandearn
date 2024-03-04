import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/bloc/shopping_bloc/shopping_bloc.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/views/common/eleveted_buuton.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/common/text_field.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key, required this.shoppingModel});
  final ShoppingModel shoppingModel;
  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  final houseController = TextEditingController();
  final cityController = TextEditingController();
  final zipcodeController = TextEditingController();
  final countryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String> address = [];
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF232323),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(
              parent: BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal,
          )),
          child: Center(
            child: BlocBuilder<ShoppingBloc, ShoppingState>(
              builder: (context, state) {
                if (state.userAddress.isNotEmpty) {
                  houseController.text = state.userAddress[0];
                  cityController.text = state.userAddress[1];
                  zipcodeController.text = state.userAddress[2];
                  countryController.text = state.userAddress[3];
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.05),
                      child: const Row(
                        children: [
                          NormText(title: "Please enter shipping address"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    SizedBox(
                        height: height * 0.08,
                        width: width * 0.9,
                        child: MyTextField(
                          title: "House/Building/Street",
                          prefix: Icons.home,
                          controller: houseController,
                        )),
                    SizedBox(
                      height: height * 0.012,
                    ),
                    SizedBox(
                        height: height * 0.08,
                        width: width * 0.9,
                        child: MyTextField(
                          title: "Village/District/City",
                          prefix: Icons.location_city,
                          controller: cityController,
                        )),
                    SizedBox(
                      height: height * 0.012,
                    ),
                    SizedBox(
                        height: height * 0.08,
                        width: width * 0.9,
                        child: MyTextField(
                          title: "Zip code/Pin code",
                          prefix: Icons.pin_drop_rounded,
                          controller: zipcodeController,
                          textInputType: TextInputType.number,
                        )),
                    SizedBox(
                      height: height * 0.012,
                    ),
                    SizedBox(
                        height: height * 0.08,
                        width: width * 0.9,
                        child: MyTextField(
                          title: "Country",
                          prefix: Icons.language_outlined,
                          controller: countryController,
                        )),
                    SizedBox(
                      height: height * 0.2,
                    ),
                    MyButton(
                      onTap: () {
                        address = [
                          houseController.text,
                          cityController.text,
                          zipcodeController.text,
                          countryController.text
                        ];
                        showDialog(
                            context: context,
                            builder: (context) {
                              return BlocProvider(
                                create: (context) => ShoppingBloc(),
                                child: AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: const NormText(title: "Are you sure?"),
                                  content: const MiniText(
                                      title: "Press \"Yes\" to confirm order."),
                                  actions: [
                                    BlocListener<ShoppingBloc, ShoppingState>(
                                      listener: (context, state) {
                                        if (!state.isAddressValid) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    backgroundColor:
                                                        Colors.black,
                                                    content: const NormText(
                                                        title:
                                                            "Enter valid address"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const MiniText(
                                                              title: "Okay"))
                                                    ],
                                                  ));
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: BlocBuilder<ShoppingBloc,
                                          ShoppingState>(
                                        builder: (context, state) {
                                          return TextButton(
                                              onPressed: () {
                                                BlocProvider.of<ShoppingBloc>(
                                                        context)
                                                    .add(OnSetUserAddressToBuy(
                                                        address: address));
                                                BlocProvider.of<ShoppingBloc>(
                                                        context)
                                                    .add(OnSetUserShoppingData(
                                                        shoppingId: widget.shoppingModel.uid!,
                                                        shoppingStatus:
                                                            "${ShoppingStatus
                                                                .pending}"));
                                              },
                                              child:
                                                  const NormText(title: "Yes"));
                                        },
                                      ),
                                    ),
                                    BlocBuilder<ShoppingBloc, ShoppingState>(
                                      builder: (context, state) {
                                        return TextButton(
                                            onPressed: () {
                                              BlocProvider.of<ShoppingBloc>(
                                                      context)
                                                  .add(OnBuyCancel(
                                                      price: 
                                                              widget.shoppingModel.price!));
                                              Navigator.pop(context);
                                            },
                                            child: const NormText(title: "No"));
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      height: height * 0.07,
                      width: width * 0.9,
                      child: const NormText(
                        title: "Buy",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
