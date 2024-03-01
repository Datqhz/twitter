import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:twitter/services/storage.dart';
import 'package:twitter/shared/global_variable.dart';

import '../models/tweet.dart';
import '../models/user.dart';

class DatabaseService{
  String url = 'http://192.168.1.14:8080';
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
    return result;

  }

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
          'personal': tweet.personal
          // Add any other data you want to send in the body
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
    GlobalVariable.avatar = Storage().downloadAvatarURL(GlobalVariable.currentUser!.avatarLink);
    GlobalVariable.wall = Storage().downloadWallULR(GlobalVariable.currentUser!.wallLink);
    return response.body.toString();
  }
}