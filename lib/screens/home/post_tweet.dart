import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import '../../models/tweet.dart';
import '../../shared/global_variable.dart';

class PostTweetScreen extends StatefulWidget {
  PostTweetScreen({super.key, required this.postTweet});
  late Function postTweet;
  @override
  State<PostTweetScreen> createState() => _PostTweetScreenState();
}

class _PostTweetScreenState extends State<PostTweetScreen> {

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
              padding: EdgeInsets.only(top: 65, left: 15, right: 15, bottom: 84),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
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
                          // child: FutureBuilder<String?>(
                          //   future: GlobalVariable.avatar,
                          //   builder: (context, snapshot){
                          //     if (snapshot.connectionState == ConnectionState.done) {
                          //       if (snapshot.hasError || snapshot.data == null) {
                          //         return Text("Error");
                          //       } else {
                          //         return Image.network(snapshot.data!);
                          //       }
                          //     }
                          //     return SizedBox(height: 1,);
                          //   },
                          // )
                      ),
                      SizedBox(width: 12,),
                      // content and media
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
                              controller:_controller ,
                              decoration: InputDecoration(
                                hintText: imagePicked.length != 0 ? "Add a comment...":"What's happening?",
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
              ),
            ),
            // app bar for this screen
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.only(top: 12, right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(FontAwesomeIcons.close, size: 24,),
                      ),
                      TextButton(
                        onPressed: _canPost?(){
                          Tweet tweet = Tweet(idAsString: "", content: content, uid: GlobalVariable.currentUser!.uid, imgLinks: [], videoLinks: [],
                            uploadDate: DateTime.now(), user: GlobalVariable.currentUser, totalComment: 0, totalLike: 0, personal: personal , isLike: false,groupName: "", repost: null, commentTweetId: '', replyTo: null, );
                          print(tweet);
                          widget.postTweet(imagePicked, tweet);
                          Navigator.pop(context);
                        }:null,
                        child: Text(
                            "Post"
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
            // some setting about personal
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
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
                      child: GestureDetector(
                        onTap: (){
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  color: Colors.black,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.minus,
                                            color: Colors.white,
                                            size: 40,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Text(
                                            "Who can reply?",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Text(
                                            "Pick who can reply to this post. Keep in mind that anyone mentioned can always reply.",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                          personal = 1;
                                          setState(() {
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:20 ),
                                          child: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        margin: EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                          borderRadius: BorderRadius.circular(25)
                                                        ),
                                                        child: Icon(FontAwesomeIcons.earth, size: 20),
                                                      ),
                                                      Visibility(
                                                          visible: personal == 1,
                                                          child: Positioned(
                                                            right: 0,
                                                            bottom: 0,
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration: BoxDecoration(
                                                                color: CupertinoColors.systemGreen,
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: Border.all(
                                                                  width: 1.5,
                                                                  color: Colors.black
                                                                )
                                                              ),
                                                              child: Icon(FontAwesomeIcons.check, color: Colors.black,size: 10,),
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(width: 12,),
                                                  Text(
                                                    "Everyone",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                          personal = 2;
                                          setState(() {
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:20 ),
                                          child: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        margin: EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius: BorderRadius.circular(25)
                                                        ),
                                                        child: Icon(FontAwesomeIcons.user, size: 20),
                                                      ),
                                                      Visibility(
                                                          visible: personal == 2,
                                                          child: Positioned(
                                                            right: 0,
                                                            bottom: 0,
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration: BoxDecoration(
                                                                  color: CupertinoColors.systemGreen,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  border: Border.all(
                                                                      width: 1.5,
                                                                      color: Colors.black
                                                                  )
                                                              ),
                                                              child: Icon(FontAwesomeIcons.check, color: Colors.black,size: 10,),
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(width: 12,),
                                                  Text(
                                                    "Anyone follow you",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                          personal = 3;
                                          setState(() {
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:20 ),
                                          child: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        margin: EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius: BorderRadius.circular(25)
                                                        ),
                                                        child: Icon(FontAwesomeIcons.at, size: 20),
                                                      ),
                                                      Visibility(
                                                          visible: personal == 3,
                                                          child: Positioned(
                                                            right: 0,
                                                            bottom: 0,
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration: BoxDecoration(
                                                                  color: CupertinoColors.systemGreen,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  border: Border.all(
                                                                      width: 1.5,
                                                                      color: Colors.black
                                                                  )
                                                              ),
                                                              child: Icon(FontAwesomeIcons.check, color: Colors.black,size: 10,),
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(width: 12,),
                                                  Text(
                                                    "Just you",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: buildPickPersonalView(),
                      ),
                    ),
                    Container(
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
                  ],
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

// image item after choosed
class ImagePicked extends StatelessWidget {
  const ImagePicked({super.key, required this.image, required this.removeImage});
  final XFile image;
  final Function removeImage;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(26.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Image.file(File(image.path), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: GestureDetector(
            onTap: (){
              removeImage(image);
            },
            child: Container(
              alignment: Alignment.center,
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Icon(FontAwesomeIcons.close, size: 16,color: Colors.black,),
            ),
          ),
        )
      ],
    );
  }
}

