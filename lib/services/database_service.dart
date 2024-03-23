import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:twitter/services/storage.dart';
import 'package:twitter/shared/global_variable.dart';

import '../models/group.dart';
import '../models/tweet.dart';
import '../models/user.dart';

class DatabaseService{
  String url = 'http://192.168.1.8:8080';
  Future<String> extractTokenAndAccessSecureResource() async {
    var token = await extractToken();
    return await accessSecureResource(token);
  }

  Future<String?> extractToken() async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = await firebaseAuth.currentUser;
    String? token = await user?.getIdToken();
    return token;
  }
  Future<String> accessSecureResource(token) async {

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token
    };
    print(headers);
    Response response = await get(Uri.parse("$url/api/employees"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      return "Could not get input from server";
    }
    return response.body.toString();
  }
  //// Tweet //////
  //Get tweet for u
  Future<List<Tweet>> getTweet()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/for-you"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    print("getd tweet: "  + result.length.toString());
    return result;

  }
  // Get comment
  Future<List<Tweet>> getCommentOfTweet(String tweetId)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/comment/"+tweetId), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    print("begin map");
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    print("comment: " + result.length.toString());
    return result;
  }
  //Post tweet
  Future<bool> postTweet(Tweet tweet)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };

    Response response = await post(
        Uri.parse("$url/api/v1/tweet"),
        headers: headers,
        body:  jsonEncode(<String, dynamic>{
          'content': tweet.content,
          'uid':tweet.uid,
          'imageLinks': tweet.imgLinks,
          'videoLinks': tweet.videoLinks,
          'uploadDate': tweet.uploadDate.toIso8601String(),
          'personal': tweet.personal,
          'groupId': tweet.groupName,
          'replyTo': tweet.replyTo?.uid,
          'repost': tweet.repost?.idAsString,
          'commentTweetId': tweet.commentTweetId,
          'usersLike': []
          // Add any other data you want to send in the body
        })
    );
    int statusCode = response.statusCode;
    if(statusCode == 201){
      return true;
    }
    return false;
  }
  // Like tweet
  Future<bool> likeTweet(String tweetId)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };

    Response response = await get(
        Uri.parse("$url/api/v1/tweet/like/"+tweetId),
        headers: headers,
    );
    int statusCode = response.statusCode;
    if(statusCode == 200){
      return true;
    }
    return false;
  }
  // Unlike tweet
  Future<bool> unlikeTweet(String tweetId)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };

    Response response = await get(
      Uri.parse("$url/api/v1/tweet/unlike/"+tweetId),
      headers: headers,
    );
    int statusCode = response.statusCode;
    if(statusCode == 200){
      return true;
    }
    return false;
  }
  //undo repost tweet
  Future<bool> undoRepost(String repostId) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };

    Response response = await get(
      Uri.parse("$url/api/v1/tweet/undo-repost/"+repostId),
      headers: headers,
    );
    int statusCode = response.statusCode;
    if(statusCode == 200){
      return true;
    }
    return false;
  }
  //Get tweets of current user
  Future<List<Tweet>> getTweetWithCurrentUID()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;

  }
  //// User //////
  Future<String> getUserInfo() async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    Response response = await get(Uri.parse("$url/api/v1/user"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      return "Could not get input from server";
    }
    final Map<String, dynamic> data = json.decode(response.body);
    GlobalVariable.currentUser = MyUser.fromJson(data['user']);
    GlobalVariable.numOfFollowed = data['numOfFollowed'];
    GlobalVariable.numOfFollowing = data['numOfFollowing'];
    GlobalVariable.avatar = (await Storage().downloadAvatarURL(GlobalVariable.currentUser!.avatarLink))!;
    print(GlobalVariable.avatar);
    GlobalVariable.wall = (await Storage().downloadWallULR(GlobalVariable.currentUser!.wallLink))!;
    return response.body.toString();
  }
  Future<List<MyUser>> findUserByUsername(String s)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    Response response = await get(Uri.parse("$url/api/v1/user/"+s), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode != 200){
      print("error");
    }
    List<MyUser> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => MyUser.fromJson(data))
        .toList();
    print(result.length);
    return result;
  }
  //// Group /////
  //get list group
  Future<List<Group>> getAllGroup()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    Response response = await get(Uri.parse("$url/api/v1/group"), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode != 200){
      print("error");
    }
    List<Group> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => Group.fromJson(data))
        .toList();
    print(result.length);
    return result;
  }
  Future<List<Group>> getAllGroupContainS(String s)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    Response response = await get(Uri.parse("$url/api/v1/group/find?regex="+s), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode != 200){
      print("error");
    }
    List<Group> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => Group.fromJson(data))
        .toList();
    print(result.length);
    return result;
  }
  // get all group joined
  Future<List<Group>> getGroupJoined()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    Response response = await get(Uri.parse("$url/api/v1/group/joined"), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode != 200){
      print("error");
    }
    List<Group> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => Group.fromJson(data))
        .toList();
    return result;
  }
  // get tweets of group
  Future<List<Tweet>> getTweetOfGroup(String groupId)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/group/"+ groupId), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;
  }
  Future<List<Tweet>> getTweetOfGroupJoined()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token!
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/group"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    print(data.toString());
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;
  }
}