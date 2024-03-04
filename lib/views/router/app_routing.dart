// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/admin/screen/admin_login.dart';
import 'package:runandearn/admin/screen/admin_screen.dart';
import 'package:runandearn/logic/bloc/auth_bloc/authentication_bloc.dart';
import 'package:runandearn/logic/bloc/databse_bloc/database_bloc.dart';
import 'package:runandearn/logic/bloc/form_bloc/form_bloc.dart';
import 'package:runandearn/logic/bloc/step_bloc/stepcounter_bloc.dart';
import 'package:runandearn/logic/cubit/tab_cubit/tab_change_cubit.dart';
import 'package:runandearn/logic/cubit/visibility_cubit/visibility_cubit_cubit.dart';
import 'package:runandearn/repository/authentication_repository.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:runandearn/views/screen/challenge_screen.dart';
import 'package:runandearn/views/screen/historyofchalleng_screen.dart';
import 'package:runandearn/views/screen/home_screen.dart';
import 'package:runandearn/views/screen/login_screen.dart';
import 'package:runandearn/views/screen/notification_screen.dart';
import 'package:runandearn/views/screen/referel_screen.dart';
import 'package:runandearn/views/screen/register_extradata_screen.dart';
import 'package:runandearn/views/screen/registration_sreen.dart';
import 'package:runandearn/views/screen/splash_screen.dart';
import 'package:runandearn/views/screen/tab_screen.dart';

class AppRouting {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => DatabaseBloc(DatabaseRepositoryImpl())
                    ..add(const DatabaseFetched()),
                  child: const SpalashScreen(),
                ));
        break;
      case '/Tab':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => TabChangeCubit(),
                  child: const TabScreen(),
                ));
        break;
      case '/Refer':
        return MaterialPageRoute(builder: (_) => const ReferelScreen());
        break;
      case '/SignIn':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => VisibilityCubit(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          AuthenticationBloc(AuthenticationRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => FormBloc(
                          AuthenticationRepositoryImpl(),
                          DatabaseRepositoryImpl()),
                    ),
                  ],
                  child: const LoginScreen(),
                ));
        break;
      case '/SignUp':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => VisibilityCubit(),
                    ),
                    BlocProvider(
                      create: (context) => FormBloc(
                          AuthenticationRepositoryImpl(),
                          DatabaseRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => AuthenticationBloc(
                        AuthenticationRepositoryImpl(),
                      ),
                    ),
                  ],
                  child: const RegistrationScreen(),
                ));
        break;
      case '/SignUpExtra':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => FormBloc(
                          AuthenticationRepositoryImpl(),
                          DatabaseRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => DatabaseBloc(
                        DatabaseRepositoryImpl(),
                      ),
                    ),
                  ],
                  child: const RegisterExtraDataScreen(),
                ));
      case '/Home':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          AuthenticationBloc(AuthenticationRepositoryImpl()),
                    ),
                    BlocProvider(create: (context) => StepcounterBloc()),
                  ],
                  child: const HomeScreen(),
                ));
        break;
      case '/AdminLogin':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => VisibilityCubit(),
                  ),
                  BlocProvider(
                    create: (context) => FormBloc(
                      AuthenticationRepositoryImpl(),
                      DatabaseRepositoryImpl(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) =>
                        AuthenticationBloc(AuthenticationRepositoryImpl()),
                  )
                ], child: const AdminLogin()));
        break;
      case '/AdminScreen':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) =>
                    AuthenticationBloc(AuthenticationRepositoryImpl()),
                child: const AdminScreen()));
      case '/Notification':
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
        break;
      case '/Challenge':
        return MaterialPageRoute(builder: (_) => const ChallengeScreen());
        break;
      case '/HistoryOfChallenge':
        return MaterialPageRoute(
            builder: (_) => const HistoryOfChallengeScreen());
        break;

      default:
        return null;
    }
  }
}
