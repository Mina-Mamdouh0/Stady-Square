
import 'package:stady_square/model/login_model.dart';

class RoomModel{
 String ? roomId;
 String ? title;
 int ? ownerUserId;
 String ? ownerUserName;
 String ? createdAt;

 RoomModel(
     {this.createdAt,
      this.title,
      this.ownerUserId,
      this.ownerUserName,
      this.roomId});

 factory RoomModel.jsonData(data){
   return RoomModel(
     createdAt: data['createdAt'],
     title: data['title'],
     ownerUserId: data['ownerUserId'],
     ownerUserName: data['ownerUserName'],
     roomId: data['roomId'],
   );
 }


}
///////////////////////////////////////////////////

class DiscussionModel{
  int ? discussionId;
  String ? discussionName;
  String ? roomId;
  String ? createdAt;
  List <PostModel>? postsList;

  DiscussionModel(
      {this.discussionId,
      this.createdAt,
      this.roomId,
      this.postsList,
      this.discussionName});

  factory DiscussionModel.jsonData(data){
    var postList = data['posts']!=null?data['posts'] as List:[];
    List<PostModel> posts = postList.map((tagJson) => PostModel.jsonData(tagJson)).toList();

    return DiscussionModel(
      discussionId: data['discussionId'],
      createdAt: data['createdAt'],
      roomId:   data['roomId'],
      discussionName:  data['discussionName'],
      postsList:data['posts']!=null ? posts : null
    );
  }



}

class PostModel{
  int ? id;
  int ? discussionId;
  String  ? content;
  String  ? createdAt;
  ProfileModel ? author;
  List<CommentModel> ? listComments;

  PostModel({this.createdAt, this.id, this.content, this.author, this.discussionId, this.listComments});

  factory PostModel.jsonData(data){
    var commentList = data['comments']!=null?data['comments'] as List:[];
    List<CommentModel> comments = commentList.map((tagJson) => CommentModel.jsonData(tagJson)).toList();


    return PostModel(
      createdAt: data['createdAt'],
      id: data['id'],
      content: data['content'],
      author: data['author']!=null ? ProfileModel.jsonData(data['author']): null,
      discussionId: data['discussionId'],
      listComments:data['comments']!=null ? comments : null
    );
  }

}

class CommentModel{
  int ? id;
  int ? discussionId;
  String  ? content;
  String  ? createdAt;
  ProfileModel ? author;

  CommentModel({this.createdAt, this.id, this.content, this.author, this.discussionId,});

  factory CommentModel.jsonData(data){
    return CommentModel(
        createdAt: data['createdAt'],
        id: data['id'],
        content: data['content'],
        author:data['author']!=null ? ProfileModel.jsonData(data['author']): null,
        discussionId: data['discussionId'],
    );
  }
}

//////////////////////////////////////////////////////////////////////////


class AnnouncementsModel{
  int ? announcementId;
  String ? announcementName;
  String ? roomId;
  String ? createdAt;
  List <MassageModel>? massageList;

  AnnouncementsModel(
      {this.announcementId,
        this.createdAt,
        this.roomId,
        this.massageList,
        this.announcementName});

  factory AnnouncementsModel.jsonData(data){
    var massageList = data['messages']!=null?data['messages'] as List:[];
    List<MassageModel> massages = massageList.map((tagJson) => MassageModel.jsonData(tagJson)).toList();

    return AnnouncementsModel(
        announcementName: data['announcementName'],
        createdAt: data['createdAt'],
        roomId:   data['roomId'],
        announcementId:  data['announcementId'],
        massageList:data['messages']!=null ? massages : null
    );
  }



}

class MassageModel{
  int ? id;
  String  ? content;
  String  ? createdAt;

  MassageModel({this.createdAt, this.id, this.content,});

  factory MassageModel.jsonData(data){
    return MassageModel(
        createdAt: data['createdAt'],
        id: data['id'],
        content: data['content'],
    );
  }

}

////////////////////////////////////////////////////////

class SyllabusModel{
  int ? syllabusId;
  String ? syllabusName;
  String ? roomId;
  String ? createdAt;
  List <FilesModel>? filesList;


  SyllabusModel(
      {this.syllabusId,
        this.createdAt,
        this.roomId,
        this.filesList,
        this.syllabusName});

  factory SyllabusModel.jsonData(data){
    var filesList = data['files']!=null?data['files'] as List:[];
    List<FilesModel> files = filesList.map((tagJson) => FilesModel.jsonData(tagJson)).toList();

    return SyllabusModel(
        syllabusName: data['syllabusName'],
        createdAt: data['createdAt'],
        roomId:   data['roomId'],
        syllabusId:  data['syllabusId'],
        filesList:data['files']!=null ? files : null
    );
  }
}

class FilesModel{
  int ? id;
  String  ? fileName;
  String  ? filePath;
  String  ? uploadedAt;


  FilesModel({this.fileName, this.id, this.filePath,this.uploadedAt});

  factory FilesModel.jsonData(data){
    return FilesModel(
      uploadedAt: data['uploadedAt'],
      id: data['id'],
      filePath: data['filePath'],
      fileName: data['fileName'],
    );
  }

}

