
import 'package:twitter/models/user_info_with_follow.dart';

class Follow {
  String idAsString;
  MyUserWithFollow userFollow;
  MyUserWithFollow userFollowed;
  bool isNotify;
  Follow({
      required this.idAsString, required this.userFollow, required this.userFollowed, required this.isNotify});
  factory Follow.fromJson(Map<String, dynamic> json){
    return Follow(
        idAsString: json['idAsString'],
        userFollow: MyUserWithFollow.fromJson(json['userFollow']),
        userFollowed: MyUserWithFollow.fromJson(json['userFollowed']),
        isNotify: json['notify']
    );
  }

}