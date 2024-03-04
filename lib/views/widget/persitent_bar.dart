
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:runandearn/logic/bloc/coin_bloc/coin_bloc.dart';
import 'package:runandearn/logic/cubit/tab_cubit/tab_change_cubit.dart';
import 'package:runandearn/views/screen/challenge_screen.dart';
import 'package:runandearn/views/screen/community_screen.dart';
import 'package:runandearn/views/screen/friends_screen.dart';
import 'package:runandearn/views/screen/reward_screen.dart';
import 'package:runandearn/views/screen/home_screen.dart';

class GnavBar extends StatelessWidget {
  const GnavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return BlocBuilder<TabChangeCubit, TabChangeState>(
      builder: (context, state) {
        return PersistentTabView(
          context,
          screens: [
            BlocProvider(
              create: (context) => CoinBloc()..add(const CoinGet()),
              child: const HomeScreen(),
            ),
            const ChallengeScreen(),
            const CommunityScreen(),
            const FriendsScreen(),
            const RewardScreen()
          ],
          items: [
            PersistentBottomNavBarItem(
                icon: SvgPicture.asset(
                  'assets/svg/home.svg',
                  colorFilter: const ColorFilter.mode(
                      Color(0xFFAFEA0D), BlendMode.srcIn),
                ),
                inactiveIcon: SvgPicture.asset(
                  'assets/svg/home.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                activeColorPrimary: const Color(0xFFAFEA0D),
                inactiveColorPrimary: Colors.white,
                title: "Home",
                textStyle: const TextStyle(color: Colors.white)),
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.bar_chart_outlined,color: Color(0xFFAFEA0D),),
              inactiveIcon: const Icon(Icons.bar_chart,color: Colors.grey,),
              activeColorPrimary: const Color(0xFFAFEA0D),
              inactiveColorPrimary: Colors.white,
              title: "Challenge",
              textStyle: const TextStyle(color: Colors.white),
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(FontAwesomeIcons.personWalking,
                    color: Colors.black),
                activeColorPrimary: Colors.white,
                inactiveColorPrimary: Colors.white,
                textStyle: const TextStyle(color: Colors.white)),
            PersistentBottomNavBarItem(
              icon: SvgPicture.asset(
                'assets/svg/friends.svg',
                colorFilter:
                    const ColorFilter.mode(Color(0xFFAFEA0D), BlendMode.srcIn),
              ),
              inactiveIcon: SvgPicture.asset(
                'assets/svg/friends.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              inactiveColorPrimary: Colors.white,
              activeColorPrimary: const Color(0xFFAFEA0D),
              title: "Friends",
              textStyle: const TextStyle(color: Colors.white),
            ),
            PersistentBottomNavBarItem(
              icon: SvgPicture.asset(
                'assets/svg/gifts.svg',
                colorFilter:
                    const ColorFilter.mode(Color(0xFFAFEA0D), BlendMode.srcIn),
              ),
              inactiveIcon: SvgPicture.asset(
                'assets/svg/gifts.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              title: "Gifts",
              inactiveColorPrimary: Colors.white,
              activeColorPrimary: const Color(0xFFAFEA0D),
              textStyle: const TextStyle(color: Colors.white),
            )
          ],
          confineInSafeArea: true,
          backgroundColor: Colors.black,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: state.selectedIndex == 2 ? false :  true,
          hideNavigationBarWhenKeyboardShows: true,
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style15,
          onItemSelected: (value) {
            BlocProvider.of<TabChangeCubit>(context).onTabChange(value);
            if(value == 0){
              BlocProvider.of<CoinBloc>(context).add(const CoinGet());
            }
          },
        );
      },
    );
  }
}
