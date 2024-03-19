
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/screens/home/comment_tweet.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/shared/global_variable.dart';
import 'package:twitter/widgets/ImageGridView.dart';
import 'package:twitter/widgets/tweet_view.dart';

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
    if(widget.tweet.content.length>200){
      setState(() {
        _isShowMore = true;
      });
    }
  }

  Widget buildMediaView(){
    return Container(
      color: Colors.black,
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: 400
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.tweet.imgLinks.length + widget.tweet.videoLinks.length == 1? Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<String?>(
                future: Storage().getImageTweetURL(widget.tweet.imgLinks[0]),
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
            :ImageGridView(imageLinks: widget.tweet.imgLinks)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>TweetView(tweet: widget.tweet,)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
            if(widget.tweet.repost!= null || widget.tweet.groupName.isNotEmpty)...[
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 26,),
                Icon(widget.tweet.groupName.isNotEmpty? CupertinoIcons.person_2_fill: FontAwesomeIcons.retweet, color: Colors.white.withOpacity(0.5), size: 14,),
                SizedBox(width: 12,),
                Text(
                  widget.tweet.groupName.isNotEmpty?widget.tweet.groupName: widget.tweet.user!.displayName + " repost",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.5)
                  ),
                ),
              ],
            ), SizedBox(height: 4,),
            ],
            Row(
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
                                widget.tweet.user!.displayName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                                ),
                              ),
                              SizedBox(width: 8,),
                              Text(
                                widget.tweet.user!.username,
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
                                '3h',
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
                      if(widget.tweet.replyTo!=null)...[
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
                                  text: widget.tweet.replyTo?.username,
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
                      if(widget.tweet.content.isNotEmpty)...[
                        const SizedBox(height: 4,),
                        Text.rich(
                          TextSpan(
                            text: _isShowMore?(_isExtend? widget.tweet.content:widget.tweet.content.substring(0, 200)+"..."):widget.tweet.content,
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
/*                  maxLines: _isExtend?1000:4,
                        overflow: TextOverflow.ellipsis,*/
                        ),
                      ],
                      widget.tweet.imgLinks.length!=0 ?const SizedBox(height: 8,):const SizedBox(height: 0,),
                      widget.tweet.imgLinks.length!=0 ? buildMediaView(): const SizedBox(height: 1,),
                      const SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // comment
                          TweetAction(number: widget.tweet.totalComment, isActive: false,
                              colorActive: null,  icon:CupertinoIcons.chat_bubble, tweet: widget.tweet, type: 1),
                          //re-post
                          TweetAction(number: 123, isActive: false,
                              colorActive: const Color.fromRGBO(84, 209, 130, 1), icon:CupertinoIcons.arrow_2_squarepath, tweet: widget.tweet, type: 2),
                          // like
                          TweetAction(number: widget.tweet.totalLike, isActive: widget.tweet.isLike,
                               colorActive: Colors.pink, icon:CupertinoIcons.heart, tweet: widget.tweet, type: 3),
                          //view
                          TweetAction(number: 0, isActive: false,
                              colorActive: null, icon:CupertinoIcons.chart_bar_alt_fill, tweet: widget.tweet, type: 4),
                          //share
                          TweetAction(number: 0, isActive: false,
                              colorActive: null, icon:Icons.share_outlined, tweet: widget.tweet, type: 6),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
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


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        switch (widget.type){
          case 1: // action is comment
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CommentTweetScreen(reply: widget.tweet)));
            break;
          case 2: // action is re-post
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
      child: Row(
        children: [
          Icon(
            widget.icon,
            size: 16,
            color: widget.isActive == false? const Color.fromRGBO(170, 184, 194, 1): widget.colorActive,
          ),
          const SizedBox(width: 4,),
          Text(
            widget.number != 0 ?widget.number.toString(): '',
            style: TextStyle(
              fontSize: 14,
              color: widget.isActive == false? const Color.fromRGBO(170, 184, 194, 1): widget.colorActive,
            ),
          )
        ],
      ),
    );;
  }
}



