
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/bloc/app_state.dart';
import 'package:stady_square/custom_text_form_field.dart';
import 'package:stady_square/screen/auth/profile_screen.dart';
import 'package:stady_square/screen/room/room_screen.dart';
import 'package:stady_square/shared_pref_services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
BlocProvider.of<AppCubit>(context).getOwnerRooms();
BlocProvider.of<AppCubit>(context).getJoinRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Rooms',
                  style: TextStyle(
                      fontFamily: 'Poppins'
                  )),
              actions: [
                InkWell(
                    onTap: ()async{
                      try{
                        await launch('https://calendar.google.com/calendar/u/0/gp?hl=en');
                      }catch(e){
                        debugPrint(e.toString());
                      }
                    },
                    child: const Icon(Icons.calendar_month)),
                const SizedBox(width: 15,),

                InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return const ProfileScreen();
                      }));
                    },
                    child: const Icon(Icons.perm_contact_cal_outlined)),
                const SizedBox(width: 15,),

                InkWell(
                    onTap: (){
                      SharedPref.removeDate(key: 'kUserId',);
                      SharedPref.removeDate(key: 'kLogin',);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                        return LoginScreen();
                      }), (route) => false);

                    },
                    child: const Icon(Icons.logout)),
                const SizedBox(width: 15,),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Owner Rooms',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                          )),

                      InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return AddRoom();
                            }));
                          },
                          child: const Icon(Icons.add,size: 25,color: Color(0XFFCC5500),))

                    ],
                  ),
                  const SizedBox(height: 20,),
                  (state is LoadingGetRoomsState)?
                  const CircularProgressIndicator():
                  Column(
                    children: [
                      ...cubit.ownerRooms.map((e){
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return RoomScreen(roomModel: e,);
                            }));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey
                                )
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(e.title??'', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,fontFamily: 'Poppins')),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                InkWell(
                                    onTap: (){
                                      Clipboard.setData(ClipboardData(text: e.roomId??''));
                                    },
                                    child: Icon(Icons.copy,size: 25,color: Color(0XFFCC5500),))

                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),


                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Join Rooms',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                          )),

                      InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return JoinRoom();
                            }));
                          },
                          child: const Icon(Icons.add,size: 25,color: Color(0XFFCC5500),))


                    ],
                  ),
                  const SizedBox(height: 20,),
                  (state is LoadingGetRoomsState)?
                  const CircularProgressIndicator():
                  Column(
                    children: [
                      ...cubit.joinRooms.map((e){
                        return InkWell(
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context){
                               return RoomScreen(roomModel: e,);
                             }));
                           },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey
                              )
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(e.title??'', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,fontFamily: 'Poppins')),
                                      Text(e.ownerUserName??'', style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                InkWell(
                                  onTap: (){
                                    Clipboard.setData(ClipboardData(text: e.roomId??''));
                                  },
                                    child: Icon(Icons.copy,size: 25,color: Color(0XFFCC5500),))

                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context,state){});
  }
}

class AddRoom extends StatelessWidget {
  AddRoom({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Rooms',
              style: TextStyle(
                  fontFamily: 'Poppins'
              )),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: formKey,
                child: Column(
                    children: [
                      CustomTextFormField(
                          controller: nameController,
                          hintText: "Name",
                          textInputType:
                          TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return  "Please enter Name";
                            }
                            return null;
                          },
                          contentPadding: const EdgeInsets.all(15)),


                      const SizedBox(height: 25),

                      BlocConsumer<AppCubit, AppState>(
                          builder: (context,state){
                            var cubit = AppCubit.get(context);

                            return (state is LoadingAddRoomsState)?
                            const CircularProgressIndicator():
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0XFFCC5500))
                              ),
                              onPressed: () {
                                if(formKey.currentState!.validate()){
                                  cubit.addRooms(
                                      title: nameController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'Add Room',
                                style:
                                TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }, listener: (context,state){
                        if (state is SuccessAddRoomsState){
                         Navigator.pop(context);
                        }
                        else if(state is ErrorAddRoomsState){
                          Fluttertoast.showToast(
                            msg: 'Please Enter Vaild Data',
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.TOP,
                            fontSize: 18,
                            textColor: Colors.white,
                          );
                        }

                      }),
                    ]))));
  }

}

class JoinRoom extends StatelessWidget {
  JoinRoom({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Join Rooms',
              style: TextStyle(
                  fontFamily: 'Poppins'
              )),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: formKey,
                child: Column(
                    children: [
                      CustomTextFormField(
                          controller: idController,
                          hintText: "Id Room",
                          textInputType:
                          TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return  "Please enter Id Room";
                            }
                            return null;
                          },
                          contentPadding: const EdgeInsets.all(15)),


                      const SizedBox(height: 25),

                      BlocConsumer<AppCubit, AppState>(
                          builder: (context,state){
                            var cubit = AppCubit.get(context);

                            return (state is LoadingAddRoomsState)?
                            const CircularProgressIndicator():
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0XFFCC5500))
                              ),
                              onPressed: () {
                                if(formKey.currentState!.validate()){
                                  cubit.joinRoom(
                                    roomId: idController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'Join Room',
                                style:
                                TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }, listener: (context,state){
                        if (state is SuccessAddRoomsState){
                          Navigator.pop(context);
                        }
                        else if(state is ErrorAddRoomsState){
                          Fluttertoast.showToast(
                            msg: 'Please Enter Vaild Data',
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.TOP,
                            fontSize: 18,
                            textColor: Colors.white,
                          );
                        }

                      }),
                    ]))));
  }

}
