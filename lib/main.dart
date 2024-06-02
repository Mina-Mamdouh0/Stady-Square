import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/screen/auth/splash_screen.dart';
import 'package:stady_square/shared_pref_services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPref.init();
  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider (create: (BuildContext context) => AppCubit()),
        ],
        child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Square',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0XFFF4EBE2),
        primaryColor: const Color(0XFFCC5500),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0XFFCC5500)
        )
      ),
      home:  const SplashScreen(),
    );
  }
}
