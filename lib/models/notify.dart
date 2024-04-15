
import 'package:twitter/models/tweet.dart';

class MyNotification{
  Tweet tweet;
  int type;
  MyNotification({required this.tweet, required this.type});
  factory MyNotification.fromJson(Map<String, dynamic> json){
    return MyNotification(
        tweet: Tweet.fromJson(json['tweet']),
        type: json['type']
    );
  }
}