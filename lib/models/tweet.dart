import 'package:intl/intl.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/models/user_info_with_follow.dart';

class Tweet {
  late String idAsString;
  late String content;
  late String uid;
  late List<String> imgLinks;
  late List<String> videoLinks;
  late DateTime uploadDate;
  late MyUserWithFollow? user;
  late int totalComment;
  late int totalLike;
  late int totalRepost;
  late String groupName;
  late int personal;
  late bool isLike;
  late bool isRepost;
  late Tweet? repost;
  late String commentTweetId;
  late MyUserWithFollow? replyTo;



  Tweet(
  {required this.idAsString, required this.content, required this.uid,
    required this.imgLinks, required this.videoLinks, required this.uploadDate,
    required this.user,required this.totalComment, required this.totalLike, required this.totalRepost,
    required this.personal, required this.groupName,required this.isLike,required this.isRepost,
    required this.repost, required this.commentTweetId, required this.replyTo});

  factory Tweet.fromJson(Map<String, dynamic> json){
    return Tweet(
        idAsString:json["idAsString"] ,
        content: json['content']??"",
        uid: json["uid"],
        imgLinks: List<String>.from(json["imageLinks"]),
        videoLinks: List<String>.from(json["videoLinks"]),
        uploadDate: DateTime.parse(json['uploadDate']),
        user: MyUserWithFollow.fromJson(json['userCreate']),
        totalLike: json["totalLike"],
        totalComment: json["totalComment"],
        totalRepost: json["totalRepost"],
        groupName: json['groupName'] ?? "",
        personal: json['personal'],
        isLike: json['like'],
        isRepost: json['repost'],
        replyTo: json['replyToUser'] != null ?MyUserWithFollow.fromJson(json['replyToUser']): null,
        repost: json['repostTweet'] != null?Tweet.fromJson(json['repostTweet']): null,
        commentTweetId: json['commentTweetId']??""
    );
  }

}