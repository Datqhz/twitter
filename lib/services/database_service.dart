import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:twitter/models/bookmark.dart';
import 'package:twitter/models/notify.dart';
import 'package:twitter/models/user_info_with_follow.dart';
import 'package:twitter/services/storage.dart';
import 'package:twitter/shared/global_variable.dart';

import '../models/follow.dart';
import '../models/group.dart';
import '../models/tweet.dart';
import '../models/user.dart';

class DatabaseService{
  String url = 'http://192.168.1.19:8080';
  Future<String> extractTokenAndAccessSecureResource() async {
    var token = await extractToken();
    return await accessSecureResource(token);
  }

  Future<String?> extractToken() async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    String? token = await user?.getIdToken();
    return token;
  }
  Future<String> accessSecureResource(token) async {

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer " + token
    };
    Response response = await get(Uri.parse("$url/api/employees"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      return "Could not get input from server";
    }
    return response.body.toString();
  }
  //// Tweet //////
  //Get tweet for u
  Future<List<Tweet>> getTweetForU()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/for-you"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;

  }
  Future<List<Tweet>> getTweetFollowing()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/following"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;

  }
  // Get comment
  Future<List<Tweet>> getCommentOfTweet(String tweetId)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/comment/$tweetId"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;
  }
  //Post tweet
  Future<bool> postTweet(Tweet tweet)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
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
          'replyTo': tweet.replyTo?.myUser.uid,
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
  //  delete tweet
  Future<bool> deleteTweet(String tweetId)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await delete(
        Uri.parse("$url/api/v1/tweet/$tweetId"),
        headers: headers,
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
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await get(
        Uri.parse("$url/api/v1/tweet/like/$tweetId"),
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
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await get(
      Uri.parse("$url/api/v1/tweet/unlike/$tweetId"),
      headers: headers,
    );
    int statusCode = response.statusCode;
    if(statusCode == 200){
      return true;
    }
    return false;
  }
  // Change tweet personal
  Future<bool> changeTweetPersonal(String tweetId, int personal)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await put(
        Uri.parse("$url/api/v1/tweet/personal/$tweetId"),
        headers: headers,
        body:  personal.toString()
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
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await get(
      Uri.parse("$url/api/v1/tweet/undo-repost/$repostId"),
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
      "Authorization" :"Bearer ${token!}"
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
  Future<List<Tweet>> getTweetOfUid(String uid)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/user?uid=$uid"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;

  }
  Future<List<Tweet>> getReplyTweetOfUid(String uid)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/reply?uid=$uid"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;

  }
  Future<List<Tweet>> getMediaTweetOfUid(String uid)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/media?uid=$uid"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;

  }
  Future<List<Tweet>> getLikedTweetByUid(String uid)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/user-like?uid=$uid"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;

  }
  //// User //////
  Future<bool> saveUserInfo(MyUser myUser, FirebaseAuth auth) async{
    User? user = auth.currentUser;
    String? token = await user?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await post(
        Uri.parse("$url/api/v1/user"),
        headers: headers,
        body:  jsonEncode(<String, dynamic>{
          "uid": user?.uid,
          "bio": myUser.bio,
          "displayName": myUser.displayName,
          "username": "dav",
          "avatarLink": "img1.jpg",
          "wallLink": "wall.jpg",
          "phoneNumber": myUser.phoneNumber,
          "email": myUser.email,
        })
    );
    int statusCode = response.statusCode;
    if(statusCode == 201){
      return true;
    }
    return false;
  }
  Future<bool> updateUserInfo(MyUser myUser, FirebaseAuth auth) async{
    User? user = auth.currentUser;
    String? token = await user?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await put(
        Uri.parse("$url/api/v1/user"),
        headers: headers,
        body:  jsonEncode(<String, dynamic>{
          "uid": user?.uid,
          "bio": myUser.bio,
          "displayName": myUser.displayName,
          "username": "dav",
          "avatarLink": myUser.avatarLink,
          "wallLink": myUser.wallLink,
          "phoneNumber": myUser.phoneNumber,
          "email": myUser.email,
        })
    );
    int statusCode = response.statusCode;
    if(statusCode == 201){
      return true;
    }
    return false;
  }
  Future<String> getUserInfo() async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    Response response = await get(Uri.parse("$url/api/v1/user"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      return "Could not get input from server";
    }
    final Map<String, dynamic> data = json.decode(response.body);
    GlobalVariable.currentUser = MyUserWithFollow.fromJson(data);
    GlobalVariable.numOfFollowed = data['numOfFollowers'];
    GlobalVariable.numOfFollowing = data['numOfFollowing'];
    GlobalVariable.avatar = (await Storage().downloadAvatarURL(GlobalVariable.currentUser!.myUser.avatarLink))!;
    GlobalVariable.wall = (await Storage().downloadWallURL(GlobalVariable.currentUser!.myUser.wallLink))!;
    return response.body.toString();
  }
  Future<List<MyUser>> findUserByUsername(String s)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    Response response = await get(Uri.parse("$url/api/v1/user/find/$s"), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode != 200){
      print("error");
    }
    List<MyUser> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => MyUser.fromJson(data))
        .toList();
    return result;
  }

  Future<MyUserWithFollow> getUserInfoWithFollow(String uid) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    Response response = await get(Uri.parse("$url/api/v1/user/$uid"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("error");
    }
    MyUserWithFollow result =MyUserWithFollow.fromJson(json.decode(response.body));
    return result;
  }
  //// Group /////
  //get list group
  Future<bool> createGroup(Group group) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await post(
        Uri.parse("$url/api/v1/group"),
        headers: headers,
        body:  jsonEncode(<String, dynamic>{
          "groupName": group.groupName,
          "groupOwnerId": group.groupOwner.myUser.uid,
          "rulesName": group.rulesName,
          "rulesContent": group.rulesContent,
          "review": group.review,
          "groupImg": group.groupImg,
          "groupMemberIds": group.groupMembers.map((e) => e.myUser.uid).toList()
          // Add any other data you want to send in the body
        })
    );
    int statusCode = response.statusCode;
    if(statusCode == 201){
      return true;
    }
    return false;
  }
  Future<bool> joinGroup(String groupId) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await put(
        Uri.parse("$url/api/v1/group/join"),
        headers: headers,
        body:  groupId
    );
    int statusCode = response.statusCode;
    if(statusCode == 201){
      return true;
    }
    return false;
  }
  Future<bool> leaveGroup(String groupId) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await put(
        Uri.parse("$url/api/v1/group/leave"),
        headers: headers,
        body:  groupId
    );
    int statusCode = response.statusCode;
    if(statusCode == 201){
      return true;
    }
    return false;
  }
  Future<List<Group>> getAllGroup()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    Response response = await get(Uri.parse("$url/api/v1/group"), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode != 200){
      print("error");
    }
    List<Group> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => Group.fromJson(data))
        .toList();
    return result;
  }
  Future<List<Group>> getAllGroupContainS(String s)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    Response response = await get(Uri.parse("$url/api/v1/group/find?regex=$s"), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode != 200){
      print("error");
    }
    List<Group> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => Group.fromJson(data))
        .toList();
    return result;
  }
  // get all group joined
  Future<List<Group>> getGroupJoined()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
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
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/group/$groupId"), headers: headers);
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
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/tweet/group"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Tweet> result = data.map((e) => Tweet.fromJson(e)).toList();
    return result;
  }
  //get members in group
  Future<List<MyUserWithFollow>> getMembersOfGroup(String groupId) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    Response response = await get(Uri.parse("$url/api/v1/group/member/$groupId"), headers: headers);
    int statusCode = response.statusCode;
    List<MyUserWithFollow> rs = [];
    if(statusCode == 200){
      rs = (json.decode(response.body) as List<dynamic>)
          .map((data) => MyUserWithFollow.fromJson(data))
          .toList();
    }
    return rs;
  }

  ////Follow///
  Future<List<Follow>> getFollowing(String uid)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    Response response = await get(Uri.parse("$url/api/v1/follow/following/$uid"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("error");
    }
    List<Follow> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => Follow.fromJson(data))
        .toList();
    return result;
  }
  Future<List<Follow>> getFollowers(String uid)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    Response response = await get(Uri.parse("$url/api/v1/follow/followers/$uid"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("error");
    }
    List<Follow> result = (json.decode(response.body) as List<dynamic>)
        .map((data) => Follow.fromJson(data))
        .toList();
    return result;
  }
  Future<bool> followUid(String uid) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await post(
        Uri.parse("$url/api/v1/follow"),
        headers: headers,
        body:  jsonEncode(<String, dynamic>{
          "userFollow": GlobalVariable.currentUser?.myUser.uid,
          "userFollowed": uid
          // Add any other data you want to send in the body
        })
    );
    int statusCode = response.statusCode;
    if(statusCode == 200){
      return true;
    }
    return false;
  }
  Future<bool> unfollowUid(String uid) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await delete(
        Uri.parse("$url/api/v1/follow/$uid"),
        headers: headers,
    );
    int statusCode = response.statusCode;
    if(statusCode == 200){
      return true;
    }
    return false;
  }

  //Notification////
  Future<List<MyNotification>> getNotification() async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/notification"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<MyNotification> result = data.map((e) => MyNotification.fromJson(e)).toList();
    return result;
  }

  // Bookmark//
  Future<List<Bookmark>> getBookmarkTweet()async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };
    print(token);
    Response response = await get(Uri.parse("$url/api/v1/bookmark"), headers: headers);
    int statusCode = response.statusCode;
    if(statusCode != 200){
      print("Could not get data tweet from server!");
    }
    final List<dynamic> data = json.decode(response.body);
    List<Bookmark> result = data.map((e) => Bookmark.fromJson(e)).toList();
    return result;

  }
  Future<bool> addBookmark(String tweetId)async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await post(
        Uri.parse("$url/api/v1/bookmark"),
        headers: headers,
        body:  jsonEncode(<String, dynamic>{
          "uid": GlobalVariable.currentUser?.myUser.uid,
          "tweetId": tweetId
          // Add any other data you want to send in the body
        })
    );
    int statusCode = response.statusCode;
    if(statusCode == 201){
      return true;
    }
    return false;
  }
  Future<bool> removeBookmarkTweet(String tweetId) async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await delete(
      Uri.parse("$url/api/v1/bookmark/$tweetId"),
      headers: headers,
    );
    int statusCode = response.statusCode;
    if(statusCode == 200){
      return true;
    }
    return false;
  }
  Future<bool> removeAllBookmark() async{
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization" :"Bearer ${token!}"
    };

    Response response = await get(
      Uri.parse("$url/api/v1/bookmark/clear-all"),
      headers: headers,
    );
    int statusCode = response.statusCode;
    if(statusCode == 200){
      return true;
    }
    return false;
  }

}