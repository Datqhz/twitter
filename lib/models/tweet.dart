import 'package:intl/intl.dart';
import 'package:twitter/models/user.dart';

class Tweet {
  late String idAsString;
  late String content;
  late String uid;
  late List<String> imgLinks;
  late List<String> videoLinks;
  late DateTime uploadDate;
  late MyUser? user;
  late int totalComment;
  late int totalLike;
  late String groupName;
  late int personal;
  late bool isLike;
  late Tweet? repost;
  late String commentTweetId;
  late MyUser? replyTo;



  Tweet(
  {required this.idAsString, required this.content, required this.uid,
    required this.imgLinks, required this.videoLinks, required this.uploadDate,
    required this.user,required this.totalComment, required this.totalLike,
    required this.personal, required this.groupName,required this.isLike,
    required this.repost, required this.commentTweetId, required this.replyTo});

  factory Tweet.fromJson(Map<String, dynamic> json){
    return Tweet(
        idAsString:json["idAsString"] ,
        content: json["content"],
        uid: json["uid"],
        imgLinks: List<String>.from(json["imageLinks"]),
        videoLinks: List<String>.from(json["videoLinks"]),
        uploadDate: DateFormat('dd-MM-yyyy').parse(json['uploadDate']),
        user: MyUser.fromJson(json['user']),
        totalLike: json["totalLike"],
        totalComment: json["totalComment"],
        groupName: json['groupName'] ?? "",
        personal: json['personal'],
        isLike: json['like'],
        replyTo: json['replyToUser'] != null ?MyUser.fromJson(json['replyToUser']): null,
        repost: json['repostTweet'] != null?Tweet.fromJson(json['repostTweet']): null,
        commentTweetId: json['commentTweetId']??""
    );
  }

}