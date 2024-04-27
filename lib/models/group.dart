
import 'package:intl/intl.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/models/user_info_with_follow.dart';

class Group {
  String groupIdAsString;
  String groupName;
  MyUserWithFollow groupOwner;
  List<String> rulesName;
  List<String> rulesContent;
  DateTime createDate;
  String review;
  String groupImg;
  List<MyUserWithFollow> groupMembers;
  bool isJoined;

  Group({
      required this.groupIdAsString,
      required this.groupName,
      required this.groupOwner,
      required this.rulesName,
      required this.rulesContent,
      required this.createDate,
      required this.review,
      required this.groupImg,
      required this.groupMembers,
      required this.isJoined});
  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
        groupIdAsString: json['groupIdAsString'],
        groupName: json['groupName'],
        groupOwner: MyUserWithFollow.fromJson(json['groupOwner']),
        rulesName: List<String>.from(json['rulesName']),
        rulesContent: List<String>.from(json['rulesContent']),
        createDate:  DateTime.parse(json['createDate']),
        review: json['review'],
        groupImg: json['groupImg'],
        groupMembers: List<MyUserWithFollow>.from(
            (json['groupMembers'] as List).map(
                (memberJson) => MyUserWithFollow.fromJson(memberJson),
            )
        ),
        isJoined: json['isJoined']
    );
  }
}
