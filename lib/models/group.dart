
import 'package:intl/intl.dart';
import 'package:twitter/models/user.dart';

class Group {
  String groupIdAsString;
  String groupName;
  MyUser groupOwner;
  List<String> rulesName;
  List<String> rulesContent;
  DateTime createDate;
  String review;
  String groupImg;
  List<MyUser> groupMembers;

  Group({
      required this.groupIdAsString,
      required this.groupName,
      required this.groupOwner,
      required this.rulesName,
      required this.rulesContent,
      required this.createDate,
      required this.review,
      required this.groupImg,
      required this.groupMembers});
  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
        groupIdAsString: json['groupIdAsString'],
        groupName: json['groupName'],
        groupOwner: MyUser.fromJson(json['groupOwner']),
        rulesName: List<String>.from(json['rulesName']),
        rulesContent: List<String>.from(json['rulesContent']),
        createDate:  DateTime.parse(json['createDate']),
        review: json['review'],
        groupImg: json['groupImg'],
        groupMembers: List<MyUser>.from(
            (json['groupMembers'] as List).map(
                (memberJson) => MyUser.fromJson(memberJson),
            )
        )
    );
  }
}
