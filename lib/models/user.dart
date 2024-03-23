import 'package:intl/intl.dart';

class MyUser{
  String uid;
  DateTime createDate;
  String displayName;
  String username;
  String avatarLink;
  String bio;
  String wallLink;
  String phoneNumber;
  String email;

  MyUser({required this.uid,   required this.createDate, required this.bio,required this.displayName,
    required this.username,  required this.wallLink, required this.avatarLink, required this.phoneNumber, required this.email});
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      uid: json['uid'],
      createDate: DateFormat('dd-MM-yyyy').parse(json['createDate']),
      displayName: json['displayName'],
      username: json['username'],
      avatarLink: json['avatarLink'],
      bio: json['bio'],
      wallLink: json['wallLink'],
      phoneNumber: json['phoneNumber']??"",
      email: json['email'],
    );
  }
}
