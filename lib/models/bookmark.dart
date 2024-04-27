import 'package:twitter/models/tweet.dart';

class Bookmark{
  Tweet tweet;
  String uid;
  String idAsString;

  Bookmark({required this.tweet, required this.uid, required this.idAsString});
  factory Bookmark.fromJson(Map<String, dynamic> json){
    return Bookmark(
        tweet: Tweet.fromJson(json['tweet']),
        uid: json['uid'],
        idAsString: json['idAsString']
    );
  }
}