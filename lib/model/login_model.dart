
class LoginModel{
  String? accessToken;
  String? tokenType;
  int? userId;
  String? userName;
  int? expiresIn;
  int? creationTime;
  int? expirationTime;
  int? accountId;
  String ? email;

  LoginModel(
      {this.email,
      this.userId,
      this.userName,
      this.accessToken,
      this.accountId,
      this.creationTime,
      this.expirationTime,
      this.expiresIn,
      this.tokenType});

  factory LoginModel.jsonData(data){
    return LoginModel(
      email: data['email'],
      userName: data['user_name'],
      userId: data['user_Id'],
      accessToken: data['access_token'],
      accountId: data['accountid'],
      creationTime: data['creation_Time'],
      expirationTime: data['creation_Time'],
      expiresIn: data['expires_in'],
      tokenType: data['token_type'],

    );
  }
}

class ProfileModel{
  int ? id;
  String ? fullName;
  String ? username;
  String ? email;
  String ? phone;

  ProfileModel({this.id, this.email, this.phone, this.username, this.fullName});

  factory ProfileModel.jsonData(data){
    return ProfileModel(
      id: data['id'],
      phone: data['phone'],
      fullName: data['fullName'],
      email: data['email'],
      username: data['username'],
    );
  }


}