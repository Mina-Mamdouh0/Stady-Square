
import 'package:flutter/material.dart';
import 'package:stady_square/custom_text_form_field.dart';
import 'package:stady_square/shared_pref_services.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  TextEditingController controller = TextEditingController();
  List<String> list= SharedPref.getDate(key: 'ListTo')??[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('To Do'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              controller: controller,
              maxLines: 4,
              hintText: 'To Do ',
            ),
            const SizedBox(height: 15,),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0XFFCC5500))
                ),
                onPressed: () {
                  if(controller.text.isNotEmpty){

                    list.add(controller.text);
                    SharedPref.setListDate(key: 'ListTo', value: list);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Add',
                  style:
                  TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),

            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  child: Text(list[index]),
                );
                })



          ],
        ),
      ),
    );
  }
}
