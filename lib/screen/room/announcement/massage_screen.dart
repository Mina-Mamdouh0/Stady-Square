

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/bloc/app_state.dart';
import 'package:stady_square/custom_text_form_field.dart';
import 'package:stady_square/model/model.dart';
import 'package:stady_square/screen/room/discussion/comment_screen.dart';

class MassageScreen extends StatefulWidget {
  final List<MassageModel> list;
  final RoomModel  roomModel;
  final String  id;
  const MassageScreen({Key? key, required this.list,required this.roomModel, required this.id}) : super(key: key);

  @override
  State<MassageScreen> createState() => _MassageScreenState();
}

class _MassageScreenState extends State<MassageScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Massage'),
              actions: [
                (widget.roomModel.ownerUserId == cubit.profileModel?.id) ?IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return AddMassage(id: widget.id,roomId: widget.roomModel.roomId??'',);
                    }));
                  },
                ):Container()
              ],
            ),
            body: (state is LoadingGetRoomsState)?
            const Center(child: CircularProgressIndicator(),):
            ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: widget.list.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(widget.list[index].content??'',
                        style: const TextStyle(fontSize: 18,fontFamily: 'Poppins',color: Color(0XFFCC5500),fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.notifications,color: Color(0XFFCC5500)),
                  );
                }),
          );
        },
        listener: (context,state){});
  }
}

class AddMassage extends StatelessWidget {
  final String id;
  final String roomId;
  AddMassage({Key? key, required this.id, required this.roomId}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Massage',
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
                          hintText: "Content",
                          textInputType:
                          TextInputType.text,
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return  "Please enter content";
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
                                  cubit.addMassage(
                                    id: id,
                                    roomId: roomId,
                                    title: nameController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'Add Massage',
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
