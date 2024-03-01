
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/widgets/ImageGridView.dart';
import 'package:twitter/widgets/tweet_view.dart';

import '../services/storage.dart';

class TweetWidget extends StatefulWidget {
  TweetWidget({super.key, required this.tweet});
  Tweet tweet;
  @override
  State<TweetWidget> createState() => _TweetWidgetState();
}

class _TweetWidgetState extends State<TweetWidget> {

  bool _isRepost = false;
  bool _isLike = false;
  bool _isExtend = false;
  bool _isShowMore = false;

  Widget action(int number, bool isActive, Color? colorActive, IconData icon){
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isActive == false? const Color.fromRGBO(170, 184, 194, 1): colorActive,
        ),
        const SizedBox(width: 4,),
        Text(
          number != 0 ?number.toString(): '',
          style: TextStyle(
              fontSize: 14,
              color: isActive == false? const Color.fromRGBO(170, 184, 194, 1): colorActive,
          ),
        )
      ],
    );
  }

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
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: 400
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.tweet.imgLinks.length + widget.tweet.videoLinks.length == 1? AspectRatio(
              aspectRatio: 16/9,
              child: FutureBuilder<String?>(
                future: Storage().getImageTweetURL(widget.tweet.imgLinks[0]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return Text("Error");
                    } else {
                      return Image.network(snapshot.data!);
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //alignment: Alignment.centerLeft,
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
                  const SizedBox(height: 4,),
                  /*const Text(
                    'When a child is scrolled out of view, the associated element subtree, states and render objects are destroyed. A new child at the same position in the list will be lazily recreated along with new elements, states and render objects when it is scrolled back.',
                    style:TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis
                    ),
                    maxLines: 10,
                  ),*/
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
                  widget.tweet.imgLinks.length!=0 ?const SizedBox(height: 8,):const SizedBox(height: 0,),
                  widget.tweet.imgLinks.length!=0 ? buildMediaView(): const SizedBox(height: 1,),
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      action(widget.tweet.totalComment ,false, null, CupertinoIcons.chat_bubble ),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              _isRepost = !_isRepost;
                            });
                          },
                          child: action(1045 , _isRepost, const Color.fromRGBO(84, 209, 130, 1), CupertinoIcons.arrow_2_squarepath )
                      ),
                      GestureDetector(
                          onTap: (){
                              setState(() {
                                _isLike = !_isLike;
                              });
                          },
                          child: action(widget.tweet.totalLike ,_isLike, Colors.pink, CupertinoIcons.heart )
                      ),
                      action(0 ,false, null, CupertinoIcons.chart_bar_alt_fill ),
                      action(0 ,false, null, Icons.share_outlined ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


