import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/screens/home/comment_tweet.dart';
import 'package:twitter/screens/profile/profile.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/shared/global_variable.dart';
import 'package:twitter/widgets/image_grid_view.dart';
import 'package:twitter/widgets/quote_tweet.dart';
import 'package:twitter/widgets/tweet_view.dart';

import '../screens/home/post_tweet.dart';
import '../services/storage.dart';

class TweetWidget extends StatefulWidget {
  TweetWidget({super.key, required this.tweet});

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

  Widget buildMediaView(List<String> imgLinks) {
    return Container(
        color: Colors.black,
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 100, maxHeight: 400),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imgLinks.length == 1
                ? Card(
                    clipBehavior: Clip.antiAlias,
                    child: FutureBuilder<String?>(
                      future: Storage().getImageTweetURL(imgLinks[0]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError || snapshot.data == null) {
                            return const Text("Error");
                          } else {
                            return Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          }
                        }
                        return const SpinKitPulse(
                          color: Colors.blue,
                          size: 50.0,
                        );
                      },
                    ),
                  )
                //Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'), fit: BoxFit.cover,)
                : ImageGridView(
                    imageLinks: imgLinks,
                    isSquare: false,
                  )));
  }

  Widget buildTweetWidget() {
    Tweet? tweet;
    if (widget.tweet.repost != null && widget.tweet.content.isEmpty) {
      tweet = widget.tweet.repost;
    } else {
      tweet = widget.tweet;
    }
    if (tweet!.content.length > 200) {
      setState(() {
        _isShowMore = true;
      });
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(uid: tweet!.user!.myUser.uid)));
          },
          child: Container(
            //alignment: Alignment.centerLeft,
              height: 38,
              width: 38,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: FutureBuilder(
                future:
                Storage().downloadAvatarURL(tweet.user!.myUser.avatarLink),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Image.network(snapshot.data!);
                  } else {
                    return Image.asset("assets/images/black.jpg");
                  }
                },
              )),
        ),
        const SizedBox(
          width: 10,
        ),
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
                        tweet.user!.myUser.displayName,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        tweet.user!.myUser.username,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(170, 184, 194, 1),
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        FontAwesomeIcons.solidCircle,
                        size: 2.5,
                        color: Color.fromRGBO(170, 184, 194, 1),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        GlobalVariable().caculateUploadDate(tweet.uploadDate),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(170, 184, 194, 1)),
                      ),
                    ],
                  ),
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
                                  OptionItem(icon: Icon(CupertinoIcons.trash, size: 24, color: Colors.grey.withOpacity(0.8)), title: "Delete post", callback: () async{
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
                                         callback:  () {
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
                                          }),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8, top: 6, bottom: 6),
                      child: Icon(
                        CupertinoIcons.ellipsis_vertical,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  )
                ],
              ),
              if (tweet.replyTo != null) ...[
                //Navigate to replied user profile
                GestureDetector(
                  onTap: () {},
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Reply to ',
                        ),
                        TextSpan(
                          text: tweet.replyTo?.myUser.username,
                          style: const TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (tweet.content.isNotEmpty) ...[
                const SizedBox(
                  height: 4,
                ),
                Text.rich(
                  TextSpan(
                    text: _isShowMore
                        ? (_isExtend
                            ? tweet.content
                            : "${widget.tweet.content.substring(0, 200)}...")
                        : tweet.content,
                    style: const TextStyle(fontSize: 14.0, color: Colors.white),
                    children: <TextSpan>[
                      if (_isShowMore)
                        if (!_isExtend)
                          TextSpan(
                            text: ' more',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                            // Xử lý khi nhấn vào "Xem thêm"
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  _isExtend = !_isExtend;
                                });
                              },
                          )
                        else
                          TextSpan(
                            text: ' brief',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                            // Xử lý khi nhấn vào "Thu gọn"
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  _isExtend = !_isExtend;
                                });
                              },
                          )
                    ],
                  ),
                ),
              ],
              if (tweet.imgLinks.isNotEmpty) ...[
                const SizedBox(
                  height: 8,
                ),
                buildMediaView(tweet.imgLinks)
              ],
              if (tweet.repost != null) ...[
                const SizedBox(
                  height: 8,
                ),
                QuoteTweet(
                    quote: tweet.repost, brief: tweet.imgLinks.isNotEmpty)
              ],
              // action of tweet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // comment
                  TweetAction(
                      number: tweet.totalComment,
                      isActive: false,
                      colorActive: null,
                      icon: CupertinoIcons.chat_bubble,
                      tweet: tweet,
                      type: 1),
                  //re-post
                  TweetAction(
                      number: tweet.totalRepost + tweet.totalQuote,
                      isActive: tweet.isRepost,
                      colorActive: const Color.fromRGBO(84, 209, 130, 1),
                      icon: CupertinoIcons.arrow_2_squarepath,
                      tweet: tweet,
                      type: 2),
                  // like
                  TweetAction(
                      number: tweet.totalLike,
                      isActive: tweet.isLike,
                      colorActive: Colors.pink,
                      icon: CupertinoIcons.heart,
                      tweet: tweet,
                      type: 3),
                  //view
                  TweetAction(
                      number: 0,
                      isActive: false,
                      colorActive: null,
                      icon: CupertinoIcons.chart_bar_alt_fill,
                      tweet: tweet,
                      type: 4),
                  //share
                  TweetAction(
                      number: 0,
                      isActive: false,
                      colorActive: null,
                      icon: Icons.share_outlined,
                      tweet: tweet,
                      type: 6),
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TweetView(
                      tweet: (widget.tweet.repost != null &&
                              widget.tweet.content.isEmpty)
                          ? widget.tweet.repost!
                          : widget.tweet,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border(
                bottom: BorderSide(
                    width: 0.2, color: Colors.white.withOpacity(0.4)))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((widget.tweet.repost != null && widget.tweet.content.isEmpty) ||
                widget.tweet.groupName.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 26,
                  ),
                  Icon(
                    widget.tweet.groupName.isNotEmpty
                        ? CupertinoIcons.person_2_fill
                        : FontAwesomeIcons.retweet,
                    color: Colors.white.withOpacity(0.5),
                    size: 14,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    widget.tweet.groupName.isNotEmpty
                        ? widget.tweet.groupName
                        : "${widget.tweet.user!.myUser.displayName} repost",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.5)),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
            ],
            buildTweetWidget()
          ],
        ),
      ),
    );
  }
}

class TweetAction extends StatefulWidget {
  TweetAction(
      {super.key,
      required this.number,
      required this.isActive,
      required this.colorActive,
      required this.icon,
      required this.tweet,
      required this.type});

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
  void postTweet(List<XFile> images, Tweet tweet) async {
    List<String> imageNames = [];
    try {
      // upload image to the cloud if have
      if (images.isNotEmpty) {
        for (XFile image in images) {
          String name = await Storage().putImage(image, "tweet/images");
          if (name != "") {
            imageNames.add(name);
          }
        }
      }
      tweet.imgLinks = imageNames;
      bool result = await DatabaseService().postTweet(tweet);
      if (result) {
        print("post tweet successful!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // backgroundColor: Colors.transparent,
            // padding: EdgeInsets.symmetric(horizontal: 12),
            width: 2.3 * MediaQuery.of(context).size.width / 4,
            behavior: SnackBarBehavior.floating,
            content: const Text('Your tweet is posted success!!'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        print("error");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        switch (widget.type) {
          case 1: // action is comment
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CommentTweetScreen(reply: widget.tweet)));
            break;
          case 2: // action is re-post
            showModalBottomSheet(
                context: context,
                builder: (context) {
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
                          onTap: widget.isActive
                              ? () async {
                                  await DatabaseService()
                                      .undoRepost(widget.tweet.idAsString);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      // backgroundColor: Colors.transparent,
                                      behavior: SnackBarBehavior.floating,
                                      content: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              'Undo Repost tweet successful!.')),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  setState(() {
                                    widget.isActive = !widget.isActive;
                                    widget.tweet.isRepost = !widget.tweet.isRepost;
                                  });
                                  Navigator.pop(context);
                                }
                              : () async {
                                  Tweet repost = Tweet(
                                    idAsString: "",
                                    content: "",
                                    uid: GlobalVariable.currentUser!.myUser.uid,
                                    imgLinks: [],
                                    videoLinks: [],
                                    uploadDate: DateTime.now(),
                                    user: GlobalVariable.currentUser,
                                    totalComment: 0,
                                    totalLike: 0,
                                    personal: 1,
                                    isLike: false,
                                    groupName: "",
                                    repost: widget.tweet,
                                    commentTweetId: '',
                                    replyTo: null,
                                    totalRepost: 0,
                                    isRepost: false,
                                    isBookmark: false,
                                    totalBookmark: 0,
                                    totalQuote: 0,
                                  );
                                  await DatabaseService().postTweet(repost);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      // backgroundColor: Colors.transparent,
                                      behavior: SnackBarBehavior.floating,
                                      content: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              'Repost tweet successful!.')),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  setState(() {
                                    widget.isActive = !widget.isActive;
                                    widget.tweet.isRepost = !widget.tweet.isRepost;
                                  });
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
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  widget.tweet.isRepost
                                      ? "Undo Reposts"
                                      : "Reposts",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostTweetScreen(
                                          postTweet: postTweet,
                                          quote: widget.tweet,
                                        )));
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
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Quotes",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
            break;
          case 3: // action is like
            if (widget.isActive) {
              await DatabaseService().unlikeTweet(widget.tweet.idAsString);
            } else {
              await DatabaseService().likeTweet(widget.tweet.idAsString);
            }
            setState(() {
              if (widget.isActive) {
                widget.number -= 1;
              } else {
                widget.number += 1;
              }
              widget.isActive = !widget.isActive;
              widget.tweet.isLike = !widget.tweet.isLike;
            });
            break;
          case 4: //view
            break;
          case 5: //bookmark
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
              color: widget.isActive == false
                  ? const Color.fromRGBO(170, 184, 194, 1)
                  : widget.colorActive,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              widget.number > 0 ? widget.number.toString() : '',
              style: TextStyle(
                fontSize: 14,
                color: widget.isActive == false
                    ? const Color.fromRGBO(170, 184, 194, 1)
                    : widget.colorActive,
              ),
            )
          ],
        ),
      ),
    );
  }
}
class OptionItem extends StatelessWidget {
  OptionItem({super.key, required this.icon, required this.title, required this.callback});
  Icon icon;
  String title;
  VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 8,),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      );
  }
}

