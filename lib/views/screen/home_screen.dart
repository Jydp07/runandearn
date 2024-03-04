import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:runandearn/logic/bloc/auth_bloc/authentication_bloc.dart';
import 'package:runandearn/logic/bloc/coin_bloc/coin_bloc.dart';
import 'package:runandearn/logic/bloc/databse_bloc/database_bloc.dart';
import 'package:runandearn/logic/bloc/step_bloc/stepcounter_bloc.dart';
import 'package:runandearn/repository/authentication_repository.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:runandearn/services/notification_service.dart';
import 'package:runandearn/views/common/text.dart';
import 'package:runandearn/views/screen/community_screen.dart';
import 'package:runandearn/views/widget/home_widget.dart/data_widget.dart';
import 'package:runandearn/views/widget/home_widget.dart/details_widget.dart';
import 'package:runandearn/views/widget/home_widget.dart/drawer_widget.dart';
import 'package:runandearn/views/widget/home_widget.dart/indicator_widget.dart';
import 'package:runandearn/views/widget/home_widget.dart/stepcount_widget.dart';
import 'package:runandearn/views/widget/home_widget.dart/water_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => StepcounterBloc()
              ..add(const OntakePermissionEvent())
              ..add(const OnGetStepsEvent())
              ..add(OnGetWater())
              ..add(const OnGoalGet())),
        BlocProvider(
          create: (context) => DatabaseBloc(DatabaseRepositoryImpl())
            ..add(const DatabaseFetched()),
        ),
        BlocProvider(
          create: (context) => CoinBloc()..add(const CoinGet()),
        ),
      ],
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final dateTime = DateFormat("EE, dd MMM yyyy").format(DateTime.now());
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      BlocProvider.of<StepcounterBloc>(context).add(const OnSetStepsEvent());
      BlocProvider.of<StepcounterBloc>(context).add(const OnGetStepsEvent());
      NotificationService.showNotification(
          id: 1,
          title:
              "${BlocProvider.of<StepcounterBloc>(context).state.step} steps",
          body:
              "Your target is ${BlocProvider.of<StepcounterBloc>(context).state.goal} steps complete now and win your daily rewward.",
          dateTime: DateTime.now().add(const Duration(seconds: 60)));
      if (DateTime.now().hour < 21) {
        NotificationService.showNotification(
            id: 2,
            title:
                "${BlocProvider.of<StepcounterBloc>(context).state.step} steps",
            body:
                "Your target is ${BlocProvider.of<StepcounterBloc>(context).state.goal} steps complete now.",
            dateTime: DateTime.now().add(const Duration(hours: 2)));
        NotificationService.showNotification(
            id: 3,
            title:
                "${BlocProvider.of<StepcounterBloc>(context).state.step} steps today",
            body: "Complete your target and win your daily reward",
            dateTime: DateTime.now().add(const Duration(days: 1)));
      }
    }
    NotificationService.showPeriodicNotification(
      title: "Drink 1 glass water",
      body: "You have to drink 8 glass of water per day.",
      repeatInterval: RepeatInterval.hourly,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AuthenticationBloc(AuthenticationRepositoryImpl()),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFF232323),
          appBar: AppBar(
            title: NormText(title: dateTime),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: SvgPicture.asset("assets/svg/drawer.svg"),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  BlocProvider.of<CoinBloc>(context).add(const CoinGet());
                },
                icon: SvgPicture.asset(
                  "assets/svg/coin.svg",
                  height: height * 0.025,
                ),
                label: BlocBuilder<CoinBloc, CoinState>(
                  builder: (context, state) {
                    return state.coin != 0 ? _Balance(state.coin) : const SizedBox();
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CommunityScreen()));
                },
                icon: const Icon(
                  FontAwesomeIcons.bell,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          drawer: MyDrawer(
            coin: BlocProvider.of<CoinBloc>(context).state.coin,
          ),
          body: BlocBuilder<StepcounterBloc, StepcounterState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else {
                return Center(
                    child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DetailsWidget(),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    SizedBox(
                      width: width * 0.95,
                      child: const StepCountWidget(),
                    ),
                    const IndicatorWidget(),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    const DataWidget(),
                    SizedBox(
                      height: height * 0.012,
                    ),
                    const WaterWidget(),
                  ],
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Balance extends StatefulWidget {
  const _Balance(this.coin);
  final int coin;

  @override
  State<_Balance> createState() => _BalanceState();
}

class _BalanceState extends State<_Balance>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(seconds: 1);

  AnimationController? controller;
  Animation<double>? animation;
  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        setState(() {});
      });
    animation =
        Tween(begin: 0.0, end: widget.coin.toDouble()).animate(controller!);
    controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MiniText(title: animation!.value.toStringAsFixed(1));
  }
}
