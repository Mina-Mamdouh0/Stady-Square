
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/bloc/app_state.dart';
import 'package:stady_square/custom_text_form_field.dart';
import 'package:stady_square/model/model.dart';
import 'package:stady_square/screen/room/discussion/comment_screen.dart';

class PostsScreen extends StatefulWidget {
  final List<PostModel> list;
  final RoomModel  roomModel;
  final String  id;
  const PostsScreen({Key? key, required this.list,required this.roomModel, required this.id}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Posts'),
              actions: [
                (widget.roomModel.ownerUserId == cubit.profileModel?.id) ?IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return AddPost(id: widget.id,roomId: widget.roomModel.roomId??'',);
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
                  return Container(
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
                          Padding(
                            padding:  const EdgeInsets.only(bottom: 10.0),
                            child:  Text(widget.list[index].content??'',
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              ),),
                          ),


                          const SizedBox(height: 10,),
                          ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0XFFCC5500))
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CommentScreen(id: widget.list[index].id.toString(),list: widget.list[index],
                          roomModel: widget.roomModel,);
                        }));
                      },
                      child: const Text(
                        'Add and show Comments',
                        style:
                        TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        },
        listener: (context,state){});
  }
}

class AddPost extends StatelessWidget {
  final String id;
  final String roomId;
  AddPost({Key? key, required this.id, required this.roomId}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Post',
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
                                  cubit.addPost(
                                    id: id,
                                    roomId: roomId,
                                    title: nameController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'Add Post',
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
