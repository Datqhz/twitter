import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:twitter/models/tweet.dart";
import "package:twitter/widgets/ImageGridView.dart";
import "package:twitter/widgets/quote_tweet.dart";
import "package:twitter/widgets/tweet_widget.dart";

import "../screens/home/comment_tweet.dart";
import "../services/database_service.dart";
import "../services/storage.dart";

class TweetView extends StatefulWidget {
  TweetView({super.key, required this.tweet});
  late Tweet tweet;
  @override
  State<TweetView> createState() => _TweetViewState();
}

class _TweetViewState extends State<TweetView> {
  bool _isRepost = false;
  bool _isBookmark = false;
  late Future<List<Tweet>> tweets;
  List<Widget> buildComment(List<Tweet

  > comment){
    List<Widget> rs = [];
    comment.forEach((element) {
      rs.add(TweetWidget(tweet: element));
    });
    rs.add(Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12, bottom: 12),
      // decoration: BoxDecoration(
      //     border: Border(
      //         top: BorderSide(
      //             color: Theme.of(context).dividerColor,
      //             width: 0.4
      //         )
      //     )
      // ),
      child: Icon(CupertinoIcons.circle_fill, size: 5,),
    ));
    rs.add(SizedBox(height: 20));
    return rs;
  }

  @override
  void initState() {
    super.initState();
    tweets = DatabaseService().getCommentOfTweet(widget.tweet.idAsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0), // Chiều cao của đường viền
          child: Divider(
            height: 0,
            color: Theme.of(context).dividerColor, // Màu sắc của đường viền
            thickness: 0.2, // Độ dày của đường viền
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 16),
                              height: 32,
                              width: 32,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: FutureBuilder<String?>(
                                  future: Storage().downloadAvatarURL(widget.tweet.user!.avatarLink),
                                  builder: (context, snapshot){
                                    if(snapshot.connectionState == ConnectionState.done){
                                      return Image.network(snapshot.data!);
                                    }
                                    return Container(color: Colors.black,);
                                  }
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.tweet.user!.displayName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16
                                  ),
                                ),
                                Text(
                                  widget.tweet.user!.username,
                                  style: TextStyle(
                                      color: Color.fromRGBO(170, 184, 194, 1),
                                      fontSize: 14
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 26,
                              width: 110,
                              child: TextButton(
                                onPressed: (){
                                },
                                child: Text(
                                  "Subcribe",
                                ),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    )
                                ),
                              ),
                            ),
                            const SizedBox(width: 12,),
                            GestureDetector(
                              child: const Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white,size: 14,),
                            )
                          ],
                        )
                      ],
                    ),
                    if(widget.tweet.replyTo!=null)...[
                      SizedBox(height: 8,),
                      //Navigate to replied user profile
                      GestureDetector(
                        onTap: (){

                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
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
                                    fontSize: 15
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6,),
                    Text(
                      widget.tweet.content,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    if(widget.tweet.imgLinks.isNotEmpty)...[const SizedBox(height: 8,)],
                    // image view
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:ImageGridView(imageLinks: widget.tweet.imgLinks, isSquare: false,)
                    ),
                    if(widget.tweet.repost!= null && widget.tweet.content.isNotEmpty)...[
                      const SizedBox(height: 10,),
                      QuoteTweet(quote:widget.tweet.repost ,brief: false)
                    ],
                    const SizedBox(height: 12,),
                    //action
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.2,
                                  color: Theme.of(context).dividerColor
                              )
                          )
                      ),
                      child: Row(
                        children: [
                          Text(
                            "35.9M ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            "Reposts",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            "70 ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            "Quote",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            widget.tweet.totalLike.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            "Likes",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),SizedBox(width: 8,),
                          Text(
                            "324 ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            "Bookmarks",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.25,
                                  color: Theme.of(context).dividerColor
                              )
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> CommentTweetScreen(reply: widget.tweet)));
                              },
                              child: const Icon(
                                CupertinoIcons.chat_bubble ,
                                size: 22,
                                color: Color.fromRGBO(170, 184, 194, 1),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _isRepost = !_isRepost;
                                });
                              },
                              child: Icon(
                                CupertinoIcons.arrow_2_squarepath ,
                                size: 22,
                                color: _isRepost? Color.fromRGBO(84, 209, 130, 1):Color.fromRGBO(170, 184, 194, 1),
                              ),
                            ),
                            GestureDetector(
                              onTap: ()async{
                                if(widget.tweet.isLike){
                                  await DatabaseService().unlikeTweet(widget.tweet.idAsString);
                                }else {
                                  await DatabaseService().likeTweet(widget.tweet.idAsString);
                                }
                                setState(() {
                                  if(widget.tweet.isLike){
                                    widget.tweet.totalLike -=1;
                                  }else {
                                    widget.tweet.totalLike +=1;
                                  }
                                  widget.tweet.isLike = !widget.tweet.isLike;
                                });
                              },
                              child: Icon(
                                widget.tweet.isLike? CupertinoIcons.heart_solid : CupertinoIcons.heart,
                                size: 22,
                                color: widget.tweet.isLike?Colors.pink:Color.fromRGBO(170, 184, 194, 1),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _isBookmark = !_isBookmark;
                                });
                              },
                              child: Icon(
                                _isBookmark? CupertinoIcons.bookmark_solid :CupertinoIcons.bookmark,
                                size: 22,
                                color: _isBookmark? Colors.blue :Color.fromRGBO(170, 184, 194, 1),
                              ),
                            ),
                            const Icon(
                              Icons.share_outlined,
                              size: 22,
                              color: Color.fromRGBO(170, 184, 194, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //comment
              FutureBuilder(
                  future: tweets,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                      if(snapshot.data!.isNotEmpty){
                        return Column(
                          children: [
                            ...buildComment(snapshot.data!)
                          ],
                        );
                      }else{
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.4
                                  )
                              )
                          ),
                          child: Icon(CupertinoIcons.circle_fill, size: 5,),
                        );
                      }
                    }else {
                      return SpinKitPulse(color: Colors.blue,);
                    }
                  }
              )
            ],
          ),
        )
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
