import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/logic/app_bloc_observer.dart';
import 'package:runandearn/views/router/app_routing.dart';
import 'package:timezone/data/latest_10y.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDfpsbz6pmiO9Mc45yqA0ozuLTB5mHeqpg',
          appId: '1:951745399394:android:9c48f18989d8285d6f1f3b',
          messagingSenderId: '951745399394',
          projectId: 'run-and-earn-1398',
          storageBucket: 'run-and-earn-1398.appspot.com'));
   initializeTimeZones();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final AppRouting appRouting = AppRouting();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouting.onGenerateRoute,
    );
  }
}
