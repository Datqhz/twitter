import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:twitter/screens/home/post_tweet.dart';
import 'package:twitter/widgets/brief_tweet.dart';
import '../../models/tweet.dart';
import '../../services/database_service.dart';
import '../../services/storage.dart';
import '../../shared/global_variable.dart';

class CommentTweetScreen extends StatefulWidget {
  CommentTweetScreen({super.key, required this.reply});
  late Tweet reply;
  @override
  State<CommentTweetScreen> createState() => _CommentTweetScreenState();
}

class _CommentTweetScreenState extends State<CommentTweetScreen> {

  late List<XFile> imagePicked = [];
  final TextEditingController _controller = TextEditingController();
  int numOfWord = 0;
  bool _canPost = false;
  String content = "";
  int personal = 1;

  @override
  void initState() {
    super.initState();
  } // build view for imagePicked
  Widget buildListImage(){
    if(imagePicked.length>1){
      List<Widget> result = [];
      imagePicked.forEach((element) {
        Size size = ImageSizeGetter.getSize(FileInput(File(element.path)));
        result.add(ImagePicked(image: element, removeImage: removeImage,));
      });
      return Container(
        height: 160,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: result,
        ),
      );
    }else{
      return ImagePicked(image: imagePicked[0], removeImage: removeImage,);
    }
  }
  //remove image in imagePicked
  void removeImage(XFile file){
    imagePicked.remove(file);
    setState(() {
    });
  }
  Widget buildPickPersonalView(){
    String content = "";
    late Icon icon;
    if(personal == 1){
      content = "Everyone can reply";
      icon = Icon(FontAwesomeIcons.earth, color: Colors.blue, size: 13,);
    }else if(personal == 2){
      content = "Anyone follow you can reply";
      icon = Icon(FontAwesomeIcons.user, color: Colors.blue, size: 13,);
    }else {
      content = "Just you can reply";
      icon = Icon(FontAwesomeIcons.at, color: Colors.blue, size: 13,);
    }
    return Row(
      children: [
        icon,
        SizedBox(width: 12,),
        Text(
          content,
          style: TextStyle(
              color: Colors.blue,
              fontSize: 13
          ),
        )
      ],
    );
  }
  // post comment
  void postTweet(List<XFile> images, Tweet tweet)async{
    List<String> imageNames = [];
    try{
      // upload image to the cloud if have
      if(images.length!=0){
        for(XFile image in images){
          String name = await Storage().putImage(image, 'tweet/images');
          if(name != ""){
            imageNames.add(name);
          }
        }
      }
      tweet.imgLinks = imageNames;
      bool result = await DatabaseService().postTweet(tweet);
      if(result){
        print("post tweet successful!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // backgroundColor: Colors.transparent,
            // padding: EdgeInsets.symmetric(horizontal: 12),
            width: 2.3*MediaQuery.of(context).size.width/4,
            behavior: SnackBarBehavior.floating,
            content: const Text('Your tweet is posted success!!'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }else {
        print("error");
      }
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 55, left: 15, right: 15, bottom:50 ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    BriefTweet(tweet: widget.reply,),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 52),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            children: [
                              TextSpan(
                                text: 'Replying to ',
                              ),
                              TextSpan(
                                text: widget.reply.user?.myUser.username,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // show user avatar
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 40,
                          width: 40,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.network(GlobalVariable.avatar),
                        ),
                        SizedBox(width: 12,),
                        // content and media
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller:_controller ,
                                decoration: InputDecoration(
                                  hintText: imagePicked.length != 0 ? "Add a comment...":"Post your reply?",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 16
                                  ),
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration.none
                                ),
                                onChanged: (value){
                                  setState(() {
                                    numOfWord = value.length;
                                    content = value;
                                    if(value.length >300){
                                      _canPost = false;
                                    }else if(value.length >0 || imagePicked.length!=0){
                                      _canPost = true;
                                    }else {
                                      _canPost = false;
                                    }
                                    setState(() {

                                    });
                                  });
                                },
                              ),
                              imagePicked.length!=0? buildListImage(): Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              // app bar for this screen
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(
                        width: 0.15,
                        color: Colors.white.withOpacity(0.4)
                      )
                    )
                  ),
                  padding: EdgeInsets.only(right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Icon(FontAwesomeIcons.close, size: 24,),
                        ),
                      ),
                      TextButton(
                        onPressed: _canPost?(){
                          Tweet tweet = Tweet(idAsString: "", content: content, uid: GlobalVariable.currentUser!.myUser.uid, imgLinks: [], videoLinks: [],
                            uploadDate: DateTime.now(), user: GlobalVariable.currentUser, totalComment: 0, totalLike: 0, personal: personal ,
                            isLike: false,groupName: "", repost: null, commentTweetId: widget.reply.idAsString, replyTo: widget.reply.user, totalRepost: 0,
                            isRepost: false, isBookmark: false, totalBookmark: 0, totalQuote: 0,  );
                          print(tweet);
                          postTweet(imagePicked, tweet);

                          Navigator.pop(context);
                        }:null,
                        child: Text(
                            "Reply"
                        ),
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.blue.withOpacity(0.6),
                            disabledForegroundColor: Colors.white.withOpacity(0.6),
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // add image
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border(
                            top: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                                width: 0.5
                            )
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap:()async{
                              if(imagePicked.length < 4){
                                List<XFile> images = await ImagePicker().pickMultiImage(
                                    maxWidth: 1920,
                                    maxHeight: 1080,
                                    imageQuality: 100
                                );
                                if(images!=null){
                                  if(images.length>4){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        // backgroundColor: Colors.transparent,
                                        width: 2.6*MediaQuery.of(context).size.width/4,
                                        behavior: SnackBarBehavior.floating,
                                        content: const Text('The number of selected photos is more than 4. Therefore, the first 4 images selected will be kept.'),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14)
                                        ),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                    imagePicked = images.sublist(0, 4);
                                  }else {
                                    imagePicked = images;
                                  }
                                  setState(() {
                                    _canPost = true;
                                  });
                                }
                              }
                            },
                            child: Icon(FontAwesomeIcons.image, color: imagePicked.length == 4 ? Colors.blue.withOpacity(0.7):Colors.blue, size: 20,)
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white.withOpacity(0.4),
                            strokeWidth: numOfWord/300 >1 ? 3: 2,
                            value: (numOfWord/300).clamp(0, 1), // Set the value between 0.0 and 1.0
                            valueColor: AlwaysStoppedAnimation<Color>(numOfWord/300>1 ? Colors.red: Colors.blue), // Set the color
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
