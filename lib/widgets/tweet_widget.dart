
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/screens/home/comment_tweet.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/shared/global_variable.dart';
import 'package:twitter/widgets/ImageGridView.dart';
import 'package:twitter/widgets/quote_tweet.dart';
import 'package:twitter/widgets/tweet_view.dart';

import '../screens/home/post_tweet.dart';
import '../services/storage.dart';

class TweetWidget extends StatefulWidget {
  TweetWidget({ super.key, required this.tweet});
  Tweet tweet;
  @override
  State<TweetWidget> createState() => _TweetWidgetState();
}

class _TweetWidgetState extends State<TweetWidget> {

  bool _isExtend = false;
  bool _isShowMore = false;


  @override
  void initState() {
    super.initState();
  }
  Widget buildMediaView(List<String> imgLinks){
    return Container(
      color: Colors.black,
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: 400
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imgLinks.length == 1? Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<String?>(
                future: Storage().getImageTweetURL(imgLinks[0]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return Text("Error");
                    } else {
                      return Image.network(snapshot.data!, fit: BoxFit.cover,);
                    }
                  }
                  return SpinKitPulse(
                    color: Colors.blue,
                    size: 50.0,
                  );
                },
              ),
            )
            //Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'), fit: BoxFit.cover,)
            :ImageGridView(imageLinks: imgLinks, isSquare: false,)
        )
    );
  }
  Widget buildTweetWidget(){
    Tweet? tweet;
    if(widget.tweet.repost!=null && widget.tweet.content.isEmpty) {
      tweet = widget.tweet.repost;
    }else {
      tweet = widget.tweet;
    }
    if(tweet!.content.length>200){
      setState(() {
        _isShowMore = true;
      });
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          //alignment: Alignment.centerLeft,
            height: 38,
            width: 38,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.network(GlobalVariable.avatar)
        ),
        const SizedBox(width: 10,),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tweet!.user!.myUser.displayName,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),
                      ),
                      SizedBox(width: 8,),
                      Text(
                        tweet.user!.myUser.username,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(170, 184, 194, 1),
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                      SizedBox(width: 4,),
                      Icon(
                        FontAwesomeIcons.solidCircle,
                        size: 2.5,
                        color: Color.fromRGBO(170, 184, 194, 1),
                      ),
                      SizedBox(width: 4,),
                      Text(
                        GlobalVariable().caculateUploadDate(tweet.uploadDate),
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(170, 184, 194, 1)
                        ),
                      ),
                    ],
                  ),
                  Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white, size: 14,)
                ],
              ),
              if(tweet.replyTo!=null)...[
                //Navigate to replied user profile
                GestureDetector(
                  onTap: (){

                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      children: [
                        TextSpan(
                          text: 'Reply to ',
                        ),
                        TextSpan(
                          text: tweet.replyTo?.myUser.username,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if(tweet.content.isNotEmpty)...[
                const SizedBox(height: 4,),
                Text.rich(
                  TextSpan(
                    text: _isShowMore?(_isExtend? tweet.content:widget.tweet.content.substring(0, 200)+"..."):tweet.content,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white
                    ),
                    children: <TextSpan>[
                      if(_isShowMore)
                        if(!_isExtend)
                          TextSpan(
                            text: ' more',
                            style: TextStyle(
                              color: Colors.blue,

                            ),
                            // Xử lý khi nhấn vào "Xem thêm"
                            recognizer: TapGestureRecognizer()..onTap = () {
                              setState(() {
                                _isExtend = !_isExtend;
                              });
                            },
                          )
                        else
                          TextSpan(
                            text: ' brief',
                            style: TextStyle(
                              color: Colors.blue,

                            ),
                            // Xử lý khi nhấn vào "Thu gọn"
                            recognizer: TapGestureRecognizer()..onTap = () {
                              setState(() {
                                _isExtend = !_isExtend;
                              });
                            },
                          )
                    ],
                  ),
                ),
              ],
              if(tweet.imgLinks.isNotEmpty)...[
                const SizedBox(height: 8,),
                buildMediaView(tweet.imgLinks)
              ],
              if(tweet.repost!=null)...[
                const SizedBox(height: 8,),
                QuoteTweet(quote: tweet.repost,brief: tweet.imgLinks.isNotEmpty)
              ],
              // action of tweet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // comment
                  TweetAction(number: tweet.totalComment, isActive: false,
                      colorActive: null,  icon:CupertinoIcons.chat_bubble, tweet: tweet, type: 1),
                  //re-post
                  TweetAction(number: tweet.totalRepost, isActive: tweet.isRepost,
                      colorActive: const Color.fromRGBO(84, 209, 130, 1), icon:CupertinoIcons.arrow_2_squarepath, tweet: tweet, type: 2),
                  // like
                  TweetAction(number: tweet.totalLike, isActive: tweet.isLike,
                      colorActive: Colors.pink, icon:CupertinoIcons.heart, tweet: tweet, type: 3),
                  //view
                  TweetAction(number: 0, isActive: false,
                      colorActive: null, icon:CupertinoIcons.chart_bar_alt_fill, tweet: tweet, type: 4),
                  //share
                  TweetAction(number: 0, isActive: false,
                      colorActive: null, icon:Icons.share_outlined, tweet: tweet, type: 6),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>TweetView(tweet: (widget.tweet.repost!=null && widget.tweet.content.isEmpty)?widget.tweet.repost!:widget.tweet,)));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8,right: 8, top: 12),
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border(
                bottom: BorderSide(
                    width: 0.2,
                    color: Colors.white.withOpacity(0.4)
                )
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if((widget.tweet.repost!= null && widget.tweet.content.isEmpty) || widget.tweet.groupName.isNotEmpty)...[
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 26,),
                Icon(widget.tweet.groupName.isNotEmpty? CupertinoIcons.person_2_fill: FontAwesomeIcons.retweet, color: Colors.white.withOpacity(0.5), size: 14,),
                SizedBox(width: 12,),
                Text(
                  widget.tweet.groupName.isNotEmpty?widget.tweet.groupName: "${widget.tweet.user!.myUser.displayName} repost",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.5)
                  ),
                ),
              ],
            ), SizedBox(height: 4,),
            ],
            buildTweetWidget()
          ],
        ),
      ),
    );
  }
}
class TweetAction extends StatefulWidget {
  TweetAction({super.key, required this.number, required this.isActive, required this.colorActive, required this.icon, required this.tweet, required this.type});
  int number;
  bool isActive;
  Color? colorActive;
  IconData icon;
  Tweet tweet;
  int type; // what kind action is
  @override
  State<TweetAction> createState() => _TweetActionState();
}

class _TweetActionState extends State<TweetAction> {

  void postTweet(List<XFile> images, Tweet tweet)async{
    List<String> imageNames = [];
    try{
      // upload image to the cloud if have
      if(images.length!=0){
        for(XFile image in images){
          String name = await Storage().putImage(image);
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
    return GestureDetector(
      onTap: ()async{
        switch (widget.type){
          case 1: // action is comment
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CommentTweetScreen(reply: widget.tweet)));
            break;
          case 2: // action is re-post
            showModalBottomSheet(
                context: context,
                builder: (context){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    height: 150,
                    color: Colors.black,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Icon(
                            CupertinoIcons.minus,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        // not yet
                        GestureDetector(
                          onTap: widget.tweet.isRepost? () async{
                            await DatabaseService().undoRepost(widget.tweet.idAsString);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                // backgroundColor: Colors.transparent,

                                behavior: SnackBarBehavior.floating,
                                content: Align( alignment: Alignment.center, child: const Text('Undo Repost tweet successful!.')),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            Navigator.pop(context);
                          }:()async{
                            Tweet repost = Tweet(idAsString: "", content: "", uid: GlobalVariable.currentUser!.myUser.uid, imgLinks: [], videoLinks: [],
                              uploadDate: DateTime.now(), user: GlobalVariable.currentUser, totalComment: 0, totalLike: 0, personal: 1 ,
                              isLike: false,groupName: "", repost: widget.tweet, commentTweetId: '', replyTo: null, totalRepost: 0, isRepost: false, );
                            await DatabaseService().postTweet(repost);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                // backgroundColor: Colors.transparent,

                                behavior: SnackBarBehavior.floating,
                                content: Align( alignment: Alignment.center, child: const Text('Repost tweet successful!.')),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.arrow_2_squarepath,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 25,
                                ),
                                SizedBox(width: 12,),
                                Text(
                                  widget.tweet.isRepost ? "Undo Reposts" :"Reposts",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.7)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PostTweetScreen(postTweet: postTweet, quote: widget.tweet,)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidPenToSquare,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 24,
                                ),
                                SizedBox(width: 12,),
                                Text(
                                  "Quotes",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.7)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            );
            break;
          case 3: // action is like
            if(widget.isActive){
              await DatabaseService().unlikeTweet(widget.tweet.idAsString);
            }else {
              await DatabaseService().likeTweet(widget.tweet.idAsString);
            }
            setState(() {
              if(widget.isActive){
                widget.number -=1;
              }else {
                widget.number +=1;
              }
              widget.isActive = !widget.isActive;
            });
            break;
          case 4: //view
            break;
          case 5: //bookmark
            break;
          default: //share
            break;

        }

    },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: widget.isActive == false? const Color.fromRGBO(170, 184, 194, 1): widget.colorActive,
            ),
            const SizedBox(width: 4,),
            Text(
              widget.number > 0 ?widget.number.toString(): '',
              style: TextStyle(
                fontSize: 14,
                color: widget.isActive == false? const Color.fromRGBO(170, 184, 194, 1): widget.colorActive,
              ),
            )
          ],
        ),
      ),
    );;
  }
}



