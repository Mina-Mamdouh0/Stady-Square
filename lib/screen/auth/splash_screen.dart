
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/screen/home_screen.dart';
import 'package:stady_square/screen/auth/login_screen.dart';
import 'package:stady_square/shared_pref_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key,);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    Timer(const Duration(seconds: 3),
            () async{
              if((SharedPref.getDate(key: 'kLogin')??false) ){
                BlocProvider.of<AppCubit>(context).getProfile();
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return (SharedPref.getDate(key: 'kLogin')??false) ? HomeScreen() : LoginScreen();
              }));
        }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Image.asset('assets/image/logo.png',
                height: 120,
                width: 120,
                fit:  BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }
}


