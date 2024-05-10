import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:image_picker/image_picker.dart";
import "package:twitter/models/tweet.dart";
import "package:twitter/screens/profile/profile.dart";
import "package:twitter/shared/global_variable.dart";
import "package:twitter/widgets/image_grid_view.dart";
import "package:twitter/widgets/quote_tweet.dart";
import "package:twitter/widgets/tweet_widget.dart";

import "../screens/home/comment_tweet.dart";
import "../screens/home/post_tweet.dart";
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
  final bool _isBookmark = false;
  late Future<List<Tweet>> tweets;

  void postTweet(List<XFile> images, Tweet tweet)async{
    List<String> imageNames = [];
    try{
      // upload image to the cloud if have
      if(images.isNotEmpty){
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

  List<Widget> buildComment(List<Tweet> comment){
    List<Widget> rs = [];
    for (var element in comment) {
      rs.add(TweetWidget(tweet: element));
    }
    rs.add(Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      // decoration: BoxDecoration(
      //     border: Border(
      //         top: BorderSide(
      //             color: Theme.of(context).dividerColor,
      //             width: 0.4
      //         )
      //     )
      // ),
      child: const Icon(CupertinoIcons.circle_fill, size: 5,),
    ));
    rs.add(const SizedBox(height: 20));
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
          preferredSize: const Size.fromHeight(0), // Chiều cao của đường viền
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
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(uid:widget.tweet.user!.myUser.uid)));
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 16),
                                height: 32,
                                width: 32,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: FutureBuilder<String?>(
                                    future: Storage().downloadAvatarURL(widget.tweet.user!.myUser.avatarLink),
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
                                    widget.tweet.user!.myUser.displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                  Text(
                                    widget.tweet.user!.myUser.username,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(170, 184, 194, 1),
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            if(widget.tweet.user?.myUser.uid!=GlobalVariable.currentUser?.myUser.uid)...[SizedBox(
                              height: 26,
                              width: 110,
                              child: TextButton(
                                onPressed: widget.tweet.user!.isFollow?()async{
                                  await DatabaseService().unfollowUid(widget.tweet.user!.myUser.uid);
                                  setState((){
                                    widget.tweet.user!.isFollow = !widget.tweet.user!.isFollow;
                                  });
                                }:()async{
                                  await DatabaseService().followUid(widget.tweet.user!.myUser.uid);
                                  setState((){
                                    widget.tweet.user!.isFollow = !widget.tweet.user!.isFollow;
                                  });
                                },
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                    backgroundColor: widget.tweet.user!.isFollow?Colors.black:Colors.white,
                                    foregroundColor: widget.tweet.user!.isFollow?Colors.white:Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(
                                          width: 0.8,
                                          color: Theme.of(context).dividerColor
                                        )
                                    )
                                ),
                                child: Text(
                                  widget.tweet.user!.isFollow?"Following": "Follow",
                                ),
                              ),
                            )],
                            const SizedBox(width: 12,),
                            GestureDetector(
                              onTap: (){
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        color: Colors.black,
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  CupertinoIcons.minus,
                                                  color: Colors.white.withOpacity(0.8),
                                                  size: 40,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            if(widget.tweet.user!.myUser.uid!= GlobalVariable.currentUser!.myUser.uid)...[
                                              OptionItem(
                                                  icon : Icon(widget.tweet.user!.isFollow?CupertinoIcons.person_crop_circle_badge_xmark: CupertinoIcons.person_crop_circle_badge_plus, size: 24, color: Colors.grey.withOpacity(0.8)),
                                                  title: widget.tweet.user!.isFollow?"Unfollow ${widget.tweet.user!.myUser.username}":"Follow ${widget.tweet.user!.myUser.username}" ,
                                                  callback:() async{
                                                if(widget.tweet.user!.isFollow){
                                                  await DatabaseService().unfollowUid(widget.tweet.uid);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      // backgroundColor: Colors.transparent,
                                                      // padding: EdgeInsets.symmetric(horizontal: 12),
                                                      width: 2.3 * MediaQuery.of(context).size.width / 4,
                                                      behavior: SnackBarBehavior.floating,
                                                      content: Text('You unfollow ${widget.tweet.user!.myUser.username}', textAlign: TextAlign.center,),
                                                      shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                      duration: const Duration(seconds: 3),
                                                    ),
                                                  );
                                                }else {
                                                  await DatabaseService().followUid(widget.tweet.uid);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      // backgroundColor: Colors.transparent,
                                                      // padding: EdgeInsets.symmetric(horizontal: 12),
                                                      width: 2.3 * MediaQuery.of(context).size.width / 4,
                                                      behavior: SnackBarBehavior.floating,
                                                      content: Text('You follow ${widget.tweet.user!.myUser.username}', textAlign: TextAlign.center,),
                                                      shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                      duration: const Duration(seconds: 3),
                                                    ),
                                                  );
                                                }
                                              }),
                                            ],
                                            if(widget.tweet.user!.myUser.uid == GlobalVariable.currentUser!.myUser.uid)...[OptionItem(icon : Icon(CupertinoIcons.trash, size: 24, color: Colors.grey.withOpacity(0.8)), title: "Delete post", callback:() async{
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context){
                                                    return Dialog(
                                                      elevation: 0,
                                                      backgroundColor: Colors.grey.shade800,
                                                      child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              const SizedBox(height: 8,),
                                                              const Text(
                                                                "Delete post?",
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 8,),
                                                              const Text(
                                                                "This can't be undo and it will be removed from your profile, the timeline of any accounts that follow your, and from search results.",
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                    style: TextButton.styleFrom(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                                                      textStyle: const TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Color.fromRGBO(153, 162, 232, 1)
                                                                      ),
                                                                      backgroundColor: Colors.transparent,
                                                                    ),
                                                                    child: const Text(
                                                                      "Cancel",
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () async{
                                                                      await DatabaseService().deleteTweet(widget.tweet.idAsString);
                                                                      Navigator.pop(context);
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                          width: 2.3 * MediaQuery.of(context).size.width / 4,
                                                                          behavior: SnackBarBehavior.floating,
                                                                          content: const Text('Your post is deleted.', textAlign: TextAlign.center,),
                                                                          shape:
                                                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                                          duration: const Duration(seconds: 3),
                                                                        ),
                                                                      );
                                                                      Navigator.pop(context);
                                                                    },
                                                                    style: TextButton.styleFrom(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                                      textStyle: const TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Color.fromRGBO(153, 162, 232, 1)
                                                                      ),
                                                                      backgroundColor: Colors.transparent,
                                                                    ),
                                                                    child: const Text(
                                                                      "Delete",
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                      ),
                                                    );
                                                  }
                                              );
                                            }),
                                              OptionItem(icon: Icon(CupertinoIcons.chat_bubble, size: 24, color: Colors.grey.withOpacity(0.8)),
                                                  title: "Change who can reply",
                                                  callback: () {
                                                    Navigator.pop(context);
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            height: MediaQuery.of(context).size.height * 0.5,
                                                            color: Colors.black,
                                                            child: Column(
                                                              children: [
                                                                const Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Icon(
                                                                      CupertinoIcons.minus,
                                                                      color: Colors.white,
                                                                      size: 40,
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                const Align(
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
                                                                const SizedBox(height: 15,),
                                                                Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                    child: Text(
                                                                      "Pick who can reply to this post. Keep in mind that anyone mentioned can always reply.",
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors.white.withOpacity(0.5),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                //personal 1
                                                                GestureDetector(
                                                                  onTap: () async{
                                                                    Navigator.pop(context);
                                                                    await DatabaseService().changeTweetPersonal(widget.tweet.idAsString, 1);
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
                                                                                  margin: const EdgeInsets.all(4),
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.blue,
                                                                                      borderRadius: BorderRadius.circular(25)
                                                                                  ),
                                                                                  child: const Icon(FontAwesomeIcons.earth, size: 20),
                                                                                ),
                                                                                Visibility(
                                                                                    visible: widget.tweet.personal == 1,
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
                                                                                        child: const Icon(FontAwesomeIcons.check, color: Colors.black,size: 10,),
                                                                                      ),
                                                                                    )
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(width: 12,),
                                                                            const Text(
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
                                                                //personal 2
                                                                const SizedBox(height: 20,),
                                                                GestureDetector(
                                                                  onTap: ()async{
                                                                    Navigator.pop(context);
                                                                    await DatabaseService().changeTweetPersonal(widget.tweet.idAsString, 2);
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
                                                                                  margin: const EdgeInsets.all(4),
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.blue,
                                                                                      borderRadius: BorderRadius.circular(25)
                                                                                  ),
                                                                                  child: const Icon(FontAwesomeIcons.user, size: 20),
                                                                                ),
                                                                                Visibility(
                                                                                    visible: widget.tweet.personal  == 2,
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
                                                                                        child: const Icon(FontAwesomeIcons.check, color: Colors.black,size: 10,),
                                                                                      ),
                                                                                    )
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(width: 12,),
                                                                            const Text(
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
                                                                const SizedBox(height: 20,),
                                                                //personal 3
                                                                GestureDetector(
                                                                  onTap: ()async{
                                                                    Navigator.pop(context);
                                                                    await DatabaseService().changeTweetPersonal(widget.tweet.idAsString, 3);
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
                                                                                  margin: const EdgeInsets.all(4),
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.blue,
                                                                                      borderRadius: BorderRadius.circular(25)
                                                                                  ),
                                                                                  child: const Icon(FontAwesomeIcons.at, size: 20),
                                                                                ),
                                                                                Visibility(
                                                                                    visible: widget.tweet.personal == 3,
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
                                                                                        child: const Icon(FontAwesomeIcons.check, color: Colors.black,size: 10,),
                                                                                      ),
                                                                                    )
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(width: 12,),
                                                                            const Text(
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
                                                  }),],
                                            const SizedBox(
                                              height: 6,
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                                child: Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white,size: 16,),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    if(widget.tweet.replyTo!=null)...[
                      const SizedBox(height: 8,),
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
                              const TextSpan(
                                text: 'Reply to ',
                              ),
                              TextSpan(
                                text: widget.tweet.replyTo?.myUser.username,
                                style: const TextStyle(
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
                      style: const TextStyle(
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
                            widget.tweet.totalRepost.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            " Reposts",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Text(
                            widget.tweet.totalQuote.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            " Quote",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Text(
                            widget.tweet.totalLike.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            " Likes",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),const SizedBox(width: 8,),
                          Text(
                            widget.tweet.totalBookmark.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            " Bookmarks",
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
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context){
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        height: 150,
                                        color: Colors.black,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              child: const Icon(
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
                                                    content: const Align( alignment: Alignment.center, child: Text('Undo Repost tweet successful!.')),
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
                                                  isLike: false,groupName: "", repost: widget.tweet, commentTweetId: '', replyTo: null, totalRepost: 0, isRepost: false,
                                                  isBookmark: false, totalBookmark: 0, totalQuote: 0,  );
                                                await DatabaseService().postTweet(repost);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    // backgroundColor: Colors.transparent,

                                                    behavior: SnackBarBehavior.floating,
                                                    content: const Align( alignment: Alignment.center, child: Text('Repost tweet successful!.')),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(14)
                                                    ),
                                                    duration: const Duration(seconds: 3),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.arrow_2_squarepath,
                                                      color: Colors.white.withOpacity(0.7),
                                                      size: 25,
                                                    ),
                                                    const SizedBox(width: 12,),
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
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      FontAwesomeIcons.solidPenToSquare,
                                                      color: Colors.white.withOpacity(0.7),
                                                      size: 24,
                                                    ),
                                                    const SizedBox(width: 12,),
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
                                setState(() {
                                  _isRepost = !_isRepost;
                                });
                              },
                              child: Icon(
                                CupertinoIcons.arrow_2_squarepath ,
                                size: 22,
                                color: widget.tweet.isRepost? const Color.fromRGBO(84, 209, 130, 1):const Color.fromRGBO(170, 184, 194, 1),
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
                                color: widget.tweet.isLike?Colors.pink:const Color.fromRGBO(170, 184, 194, 1),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                if(widget.tweet.isBookmark) {
                                  await DatabaseService().removeBookmarkTweet(widget.tweet.idAsString);
                                }else {
                                  await DatabaseService().addBookmark(widget.tweet.idAsString);
                                }
                                setState(() {
                                  if(widget.tweet.isBookmark){
                                    widget.tweet.totalBookmark -=1;
                                  }else {
                                    widget.tweet.totalBookmark +=1;
                                  }
                                  widget.tweet.isBookmark= !widget.tweet.isBookmark;
                                });
                              },
                              child: Icon(
                                widget.tweet.isBookmark ?  CupertinoIcons.bookmark_solid :CupertinoIcons.bookmark,
                                size: 22,
                                color: widget.tweet.isBookmark ? Colors.blue :const Color.fromRGBO(170, 184, 194, 1),
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
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.4
                                  )
                              )
                          ),
                          child: const Icon(CupertinoIcons.circle_fill, size: 5,),
                        );
                      }
                    }else {
                      return const SpinKitPulse(color: Colors.blue,);
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
