class UserData {
  String uid;
  String email;
  String username;
  String password;
  String photoUrl;

  UserData({this.uid, this.email, this.username, this.password, this.photoUrl});

  Map toMap(UserData user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['username'] = user.username;
    data['password'] = user.password;
    data['photoUrl'] = user.photoUrl;

    return data;
  }

  // Named constructor
  UserData.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.password = mapData['password'];
    this.photoUrl = mapData['photoUrl'];
  }
}
