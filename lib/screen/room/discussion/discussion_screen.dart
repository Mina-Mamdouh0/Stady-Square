
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/bloc/app_state.dart';
import 'package:stady_square/custom_text_form_field.dart';
import 'package:stady_square/screen/room/discussion/post_screen.dart';

import '../../../model/model.dart';

class DiscussionScreen extends StatefulWidget {
  final RoomModel roomModel ;
  const DiscussionScreen({Key? key,required this.roomModel}) : super(key: key);

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).getDiscussion(roomID: widget.roomModel.roomId??'');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Discussions'),
              actions: [
                (widget.roomModel.ownerUserId == cubit.profileModel?.id) ?IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return AddDiscussions(roomId: widget.roomModel.roomId??'',);
                    }));
                  },
                ):Container()
              ],
            ),
            body: (state is LoadingGetRoomsState)?
            const Center(child: CircularProgressIndicator(),):
            ListView.builder(
              padding: const EdgeInsets.all(15),
                itemCount: cubit.discussionList.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(cubit.discussionList[index].discussionName??'', style: TextStyle(fontSize: 18,fontFamily: 'Poppins',color: Color(0XFFCC5500),fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.post_add,color: Color(0XFFCC5500)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return PostsScreen( list: cubit.discussionList[index].postsList??[],roomModel: widget.roomModel,
                        id: cubit.discussionList[index].discussionId.toString(),);
                      }));
                    },
                  );
                }),
          );
        },
        listener: (context,state){});
  }
}


class AddDiscussions extends StatelessWidget {
  final String roomId;
  AddDiscussions({Key? key, required this.roomId}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Discussion',
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
                                  cubit.addDiscussion(
                                    roomId: roomId,
                                    title: nameController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'Add Discussion',
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
