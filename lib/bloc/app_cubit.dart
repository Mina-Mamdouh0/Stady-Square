
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:stady_square/bloc/app_state.dart';
import 'package:stady_square/model/login_model.dart';
import 'package:stady_square/model/model.dart';
import 'package:stady_square/shared_pref_services.dart';


class AppCubit extends Cubit<AppState> {

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  final String baseUrl= 'http://studysmart.somee.com';

  Map<String , String > header={
    'Accept':'application/json',
    'Content-Type':'application/json',
    // 'authorization':'Basic ${base64Encode(utf8.encode('11170315:60-dayfreetrial'))}'
  };

  void login({required String email , required String password})async{
    emit(LoadingLoginState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/Auth/Login'),
          body: json.encode({
            'username':email,
            'password':password
          }),headers:header );
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        LoginModel loginModel = LoginModel.jsonData(data);
        SharedPref.setDate(key: 'kUserId',value: loginModel.userId.toString());
        SharedPref.setDate(key: 'kLogin',value:  true);
        emit(SuccessLoginState());
        print('vklng');
        getProfile();
      }else{
        emit(ErrorLoginState());
      }
    }catch(e){
      emit(ErrorLoginState());
    }
  }


  void signUp({required String email , required String password , required String phone , required String userName , required String fullName})async{
    emit(LoadingSignUpState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/Auth/Register'),
          body: json.encode({
            'username':userName,
            'fullName':fullName,
            'email':email,
            'phone':phone,
            'password':password,
          }),headers:header);
      print('ff');
      if(response.body.isNotEmpty){
        var data = jsonDecode(response.body);
        print(data);
      }
      print(response.statusCode);

      if(response.statusCode==200 || response.statusCode==201){
        emit(SuccessSignUpState());
      }else{
        emit(ErrorSignUpState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorSignUpState());
    }
  }

  ProfileModel? profileModel;
  void getProfile()async{
    emit(LoadingGetProfileState());
    profileModel=null;
    String userId =SharedPref.getDate(key: 'kUserId');
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/Users/GetUserByID/Id').replace(
        queryParameters: {
          'id':userId
        }
      ),
          headers:header );
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        profileModel =ProfileModel.jsonData(data);
        emit(SuccessGetProfileState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetProfileState());
    }
  }


  List<RoomModel> ownerRooms =[];
  List<RoomModel> joinRooms =[];
  void getOwnerRooms()async{
    emit(LoadingGetRoomsState());
    ownerRooms=[];
    String userId =SharedPref.getDate(key: 'kUserId');
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/rooms/GetRoomsByUserId/$userId'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          ownerRooms.add(RoomModel.jsonData(data[i]));
        }
        emit(SuccessGetRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetRoomsState());
    }
  }

  void getJoinRooms()async{
    emit(LoadingGetRoomsState());
    joinRooms=[];
    String userId =SharedPref.getDate(key: 'kUserId');
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/rooms/GetJoindRoomsByUserId/$userId'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          joinRooms.add(RoomModel.jsonData(data[i]));
        }
        emit(SuccessGetRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetRoomsState());
    }
  }

  void addRooms({required String title})async{
    emit(LoadingAddRoomsState());
    String userId =SharedPref.getDate(key: 'kUserId');
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/rooms'),
          body:json.encode({
            'title':title,
            'ownerUserId':int.parse(userId)
          }) ,
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        print(data);
        emit(SuccessAddRoomsState());
        getOwnerRooms();
      }else{
        emit(ErrorAddRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorAddRoomsState());
    }
  }

  void joinRoom({required String roomId})async{
    emit(LoadingAddRoomsState());
    String userId =SharedPref.getDate(key: 'kUserId');
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/rooms/JoinRoom'),
          body:json.encode({
            'roomId':roomId,
            'userId':int.parse(userId)
          }) ,
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        print(data);
        emit(SuccessAddRoomsState());
        getJoinRooms();
      }else{
        emit(ErrorAddRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorAddRoomsState());
    }
  }


  /////////////////////////////////////////

  void addDiscussion({required String title , required String roomId})async{
    emit(LoadingAddRoomsState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/discussions'),
          body:json.encode({
            'discussionName':title,
            'roomId':roomId
          }) ,
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        print(data);
        emit(SuccessAddRoomsState());
        getDiscussion(roomID: roomId);
      }else{
        emit(ErrorAddRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorAddRoomsState());
    }
  }

  List<DiscussionModel> discussionList=[];
  void getDiscussion({required String roomID})async{
    emit(LoadingGetRoomsState());
    discussionList=[];
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/discussions/GetDiscussionByRoomId/$roomID'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          discussionList.add(DiscussionModel.jsonData(data[i]));
        }
        emit(SuccessGetRoomsState());
      }else{
        emit(ErrorGetRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetRoomsState());
    }
  }

  void addPost({required String title , required String id , required String roomId})async{
    emit(LoadingAddRoomsState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/posts'),
          body:json.encode({
            'content':title,
            'discussionId':int.parse(id)
          }) ,
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        print(data);
        emit(SuccessAddRoomsState());
        getDiscussion(roomID: roomId);
      }else{
        emit(ErrorAddRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorAddRoomsState());
    }
  }

  void addComment({required String title , required String id , required String roomId})async{
    emit(LoadingAddRoomsState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/comments/AddComment/$id'),

          body:json.encode({
            'content':title,
          }) ,
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        print(data);
        emit(SuccessAddRoomsState());
        getDiscussion(roomID: roomId);
      }else{
        emit(ErrorAddRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorAddRoomsState());
    }
  }


  /////////////////////////////////////

  void addAnnouncements({required String title , required String roomId})async{
    emit(LoadingAddRoomsState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/announcements'),
          body:json.encode({
            'announcementName':title,
            'roomId':roomId
          }) ,
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        print(data);
        emit(SuccessAddRoomsState());
        getAnnouncements(roomID: roomId);
      }else{
        emit(ErrorAddRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorAddRoomsState());
    }
  }


  List<AnnouncementsModel> announcementsList=[];
  void getAnnouncements({required String roomID})async{
    emit(LoadingGetRoomsState());
    announcementsList=[];
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/announcements/GetAnnouncementsByRoomId/$roomID'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          announcementsList.add(AnnouncementsModel.jsonData(data[i]));
        }
        emit(SuccessGetRoomsState());
      }else{
        emit(ErrorGetRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetRoomsState());
    }
  }

  void addMassage({required String title , required String id , required String roomId})async{
    emit(LoadingAddRoomsState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/messages/AddFileToSyllabes/$id'),
          body:json.encode({
            'content':title,
          }) ,
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        print(data);
        emit(SuccessAddRoomsState());
        getAnnouncements(roomID: roomId);
      }else{
        emit(ErrorAddRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorAddRoomsState());
    }
  }

  ////////////////////////////////////


  void addSyllabus({required String title , required String roomId})async{
    emit(LoadingAddRoomsState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/syllabuses'),
          body:json.encode({
            'syllabusName':title,
            'roomId':roomId
          }) ,
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        print(data);
        emit(SuccessAddRoomsState());
        getSyllabus(roomID: roomId);
      }else{
        emit(ErrorAddRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorAddRoomsState());
    }
  }


  List<SyllabusModel> syllabusList=[];
  void getSyllabus({required String roomID})async{
    emit(LoadingGetRoomsState());
    syllabusList=[];
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/syllabuses/GetSyllabesByRoomId/$roomID'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          syllabusList.add(SyllabusModel.jsonData(data[i]));
        }
        emit(SuccessGetRoomsState());
      }else{
        emit(ErrorGetRoomsState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetRoomsState());
    }
  }

  File ? fileImage;

  void changeFileImage(File file){
    fileImage= file;
    emit(AppInitialState());
  }

  void clearFileImage(){
    fileImage=null;
    emit(AppInitialState());
  }

  void addFiles({required String fileName,required String id , required String roomId})async{

    try{
      emit(LoadingAddRoomsState());
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/files/AddFileToSyllabes/$id'),);
      request.headers.addAll({
        'Accept':'application/json',
        'Content-Type':'application/json',
      });

      if(fileImage!=null){
        request.files.add(http.MultipartFile('file',
            File(fileImage!.path).readAsBytes().asStream(), File(fileImage!.path).lengthSync(),
            filename: fileImage!.path.split("/").last));
      }

      request.fields['fileName'] = fileName;

      var res = await request.send();
      var response = await http.Response.fromStream(res);
      if(response.body.isNotEmpty){
        var resData = json.decode(response.body);
        debugPrint(resData.toString());
      }
      debugPrint(request.fields.toString());
      debugPrint(response.body);
      emit(SuccessAddRoomsState());
      getSyllabus(roomID: roomId);
      debugPrint('Success Upload');
    }catch(e){
      debugPrint('Error Upload ${e.toString()}');
      emit(ErrorAddRoomsState());
    }
  }











}

