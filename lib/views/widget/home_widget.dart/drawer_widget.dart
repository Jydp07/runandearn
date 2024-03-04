import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/logic/bloc/coin_bloc/coin_bloc.dart';
import 'package:runandearn/logic/bloc/databse_bloc/database_bloc.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/myprofile_screen.dart';
import 'package:runandearn/views/screen/wallet_screen.dart';
import 'package:shimmer/shimmer.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.coin});
  final int coin;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Drawer(
      backgroundColor: const Color(0xFF232323),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/drawerimg.png",
              fit: BoxFit.cover,
            )),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<DatabaseBloc, DatabaseState>(
                  builder: (context, state) {
                    if (state is DatabaseSuccess) {
                      return TitleText(title: state.userData.name ?? "");
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: Container(
                          height: height * 0.05,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(16))),
                    );
                  },
                ),
                BlocBuilder<DatabaseBloc, DatabaseState>(
                  builder: (context, state) {
                    if (state is DatabaseSuccess) {
                      return NormText(title: state.userData.email!);
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: Container(
                          height: height * 0.03,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider(
                      create: (context) =>
                          DatabaseBloc(DatabaseRepositoryImpl())
                            ..add(const DatabaseFetched()),
                      child: const MyProfile(),
                    )));
          },
          child: const ListTile(
            leading: FaIcon(
              FontAwesomeIcons.circleUser,
              size: 26,
              color: Colors.white,
            ),
            title: NormText(title: "My Profile"),
          ),
        ),
        ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.wallet,
            size: 26,
            color: Colors.white,
          ),
          title: const NormText(title: "Wallet"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider(
                          create: (context) =>
                              CoinBloc()..add(const CoinGet()),
                          child: const WalletScreen(),
                        )));
          },
        ),
        const ListTile(
          leading: FaIcon(
            FontAwesomeIcons.headphones,
            size: 26,
            color: Colors.white,
          ),
          title: NormText(title: "Support"),
        ),
        const Divider(
          thickness: 1,
        ),
        
      ]),
    );
  }
}


