
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/bloc/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppState>(
        builder: (context,state){
          var cubit= AppCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          elevation: 0.0,
          backgroundColor: Color(0XFFCC5500),
        ),
        body: (state is LoadingGetProfileState)?
        const Center(
          child: CircularProgressIndicator(),
        ):SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/image/logo.png',
                  height: 150,
                  width: 150,
                  fit:  BoxFit.cover,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Expanded(
                    child: Text('Email : ',
                      style: TextStyle(
                        color:Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),),
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: Text(cubit.profileModel?.email??'',
                      style: const TextStyle(
                        color:Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Expanded(
                    child: Text('Full Name : ',
                      style: TextStyle(
                        color:Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),),
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: Text(cubit.profileModel?.fullName??'',
                      style: const TextStyle(
                        color:Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Expanded(
                    child: Text('User Name : ',
                      style: TextStyle(
                        color:Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),),
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: Text(cubit.profileModel?.username??'',
                      style: const TextStyle(
                        color:Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Expanded(
                    child: Text('Phone Number : ',
                      style: TextStyle(
                        color:Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),),
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: Text(cubit.profileModel?.phone??'',
                      style: const TextStyle(
                        color:Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),),
                  ),
                ],
              ),
              const SizedBox(height: 20,),


            ],
          ),
        ),

      );
    });
  }
}
