
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/bloc/app_state.dart';
import 'package:stady_square/model/model.dart';

import '../../../custom_text_form_field.dart';

class CommentScreen extends StatefulWidget {
  final PostModel list;
  final String  id;
  final RoomModel  roomModel;
  const CommentScreen({Key? key, required this.list, required this.id, required this.roomModel}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Comments'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return AddComment(id: widget.id,roomId: widget.roomModel.roomId??'',);
                    }));
                  },
                )
              ],
            ),
            body:
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.grey
                  )
              ),
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
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.list.content??'',
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                        ),),
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: widget.list.listComments?.length,
                            itemBuilder: (context,index){
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.list.listComments?[index].content??'',
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0XFFCC5500),
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                    ),),
                                  const SizedBox(height: 10,),
                                  Text(widget.list.listComments?[index].createdAt??'',
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                    ),),
                                  const Divider(color: Colors.black,thickness: 1,),

                                ],
                              );
                            }),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context,state){});
  }
}

class AddComment extends StatelessWidget {
  final String id;
  final String roomId;
  AddComment({Key? key, required this.id, required this.roomId}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Comment',
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
                                  cubit.addComment(
                                    id: id,
                                    roomId: roomId,
                                    title: nameController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'Add Comment',
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
