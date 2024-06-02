
import 'package:flutter/material.dart';
import 'package:stady_square/model/model.dart';
import 'package:stady_square/screen/room/announcement/announcements_screen.dart';
import 'package:stady_square/screen/room/discussion/discussion_screen.dart';
import 'package:stady_square/screen/room/syllabus/syllabus_screen.dart';
import 'package:stady_square/screen/room/syllabus/todo_list_view.dart';

class RoomScreen extends StatelessWidget {
  final RoomModel roomModel;
  const RoomScreen({Key? key, required this.roomModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[

            ListTile(
              title:  const Text('Discussions', style: TextStyle(fontSize: 18,fontFamily: 'Poppins',color: Color(0XFFCC5500),fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.post_add,color: Color(0XFFCC5500)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return DiscussionScreen(roomModel: roomModel,);
                }));
              },
            ),
            ListTile(
              title:  const Text('Announcements', style: TextStyle(fontSize: 18,fontFamily: 'Poppins',color: Color(0XFFCC5500),fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.post_add,color: Color(0XFFCC5500)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AnnouncementsScreen(roomModel: roomModel,);
                }));
              },
            ),
            ListTile(
              title:  const Text('Syllabus', style: TextStyle(fontSize: 18,fontFamily: 'Poppins',color: Color(0XFFCC5500),fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.post_add,color: Color(0XFFCC5500)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SyllabusScreen(roomModel: roomModel,name: 'Syllabus',);
                }));
              },
            ),
            ListTile(
              title:  const Text('Exams and quiz', style: TextStyle(fontSize: 18,fontFamily: 'Poppins',color: Color(0XFFCC5500),fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.post_add,color: Color(0XFFCC5500)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SyllabusScreen(roomModel: roomModel,name: 'Exams and quiz',);
                }));
              },
            ),
            ListTile(
              title:  const Text('ToDo List', style: TextStyle(fontSize: 18,fontFamily: 'Poppins',color: Color(0XFFCC5500),fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.post_add,color: Color(0XFFCC5500)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return TodoScreen();
                }));


              },
            ),
          ],
        ),
      ),

    );
  }

}
