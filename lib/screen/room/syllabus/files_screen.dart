

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/bloc/app_state.dart';
import 'package:stady_square/custom_text_form_field.dart';
import 'package:stady_square/model/model.dart';
import 'package:stady_square/screen/room/discussion/comment_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class FilesScreen extends StatefulWidget {
  final List<FilesModel> list;
  final RoomModel  roomModel;
  final String  id;
  const FilesScreen({Key? key, required this.list,required this.roomModel, required this.id}) : super(key: key);

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Files'),
              actions: [
                (widget.roomModel.ownerUserId == cubit.profileModel?.id) ?IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return AddFilesScreen(id: widget.id,roomId: widget.roomModel.roomId??'',);
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
                    title: Text(widget.list[index].fileName??'',
                        style: const TextStyle(fontSize: 18,fontFamily: 'Poppins',color: Color(0XFFCC5500),fontWeight: FontWeight.w500)),
                    trailing: InkWell(
                      onTap: ()async{
                        try{
                          await launch('${cubit.baseUrl}/uploads/${widget.list[index].filePath??''}');
                        }catch(e){
                          debugPrint(e.toString());
                        }

                      },
                        child: const Icon(Icons.link,color: Color(0XFFCC5500))),
                  );
                }),
          );
        },
        listener: (context,state){});
  }
}

class AddFilesScreen extends StatefulWidget {
  final String id;
  final String roomId;
  AddFilesScreen({Key? key, required this.id, required this.roomId}) : super(key: key);

  @override
  State<AddFilesScreen> createState() => _AddFilesScreenState();
}
//
class _AddFilesScreenState extends State<AddFilesScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController pathController = TextEditingController();


  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).clearFileImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Files',
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
                      BlocBuilder<AppCubit,AppState>(
                          builder: (context,state){
                            var cubit = AppCubit.get(context);
                        return Center(
                          child: InkWell(
                            onTap: ()async{
                              FilePickerResult? result = await FilePicker.platform.pickFiles();

                              if (result != null) {
                                File file = File(result.files.single.path!);
                                cubit.changeFileImage(File(file.path));
                              } else {
                                // User canceled the picker
                              }
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle
                              ),
                              child: cubit.fileImage == null ?
                              Center(child:Icon(Icons.add)): Center(child:Icon(Icons.check)),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 15),
                      CustomTextFormField(
                          controller: nameController,
                          hintText: "Name File",
                          textInputType:
                          TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return  "Please enter Name";
                            }
                            return null;
                          },
                          contentPadding: const EdgeInsets.all(15)),
                      const SizedBox(height: 15),

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
                                  cubit.addFiles(
                                    id: widget.id,
                                    roomId: widget.roomId,
                                    fileName: nameController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'Add Files',
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
