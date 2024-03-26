
import 'package:twitter/models/user.dart';

class MyUserWithFollow{
  MyUser myUser;
  int numOfFollowing;
  int numOfFollowed;
  bool isFollow;

  MyUserWithFollow({required this.myUser,   required this.numOfFollowed, required this.numOfFollowing,required this.isFollow});
  factory MyUserWithFollow.fromJson(Map<String, dynamic> json) {
    return MyUserWithFollow(
        myUser: MyUser.fromJson(json['user']),
        numOfFollowed: json['numOfFollowed'],
        numOfFollowing: json['numOfFollowing'],
        isFollow: json['follow']
    );
  }
}