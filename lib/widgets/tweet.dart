import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/widgets/ImageGridView.dart';
import 'package:twitter/widgets/video_player.dart';
import 'package:video_player/video_player.dart';

class Tweet extends StatefulWidget {
  const Tweet({super.key});

  @override
  State<Tweet> createState() => _TweetState();
}

class _TweetState extends State<Tweet> {

  Widget action(int number, bool isActive, Color? colorActive, IconData icon){
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
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
  Widget buildMediaView(int numberMedia){
    return Container(
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: 400
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: numberMedia == 1? AspectRatio(
              aspectRatio: 16/9,
              child: Video(url: 'assets/videos/vd2.mp4')
            )
            //Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'), fit: BoxFit.cover,)
            :ImageGridView(numberImage: numberMedia,)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
              bottom: BorderSide(
                  width: 0.6,
                  color: Theme.of(context).dividerColor
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
            child: Image.asset("assets/images/patty.png"),
          ),
          const SizedBox(width: 10,),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Patty',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          '@Patty',
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
                const Text(
                  'When a child is scrolled out of view, the associated element subtree, states and render objects are destroyed. A new child at the same position in the list will be lazily recreated along with new elements, states and render objects when it is scrolled back.',
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis
                  ),
                  maxLines: 10,
                ),
                const SizedBox(height: 8,),
                buildMediaView(1),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    action(1045 ,false, null, CupertinoIcons.chat_bubble ),
                    action(1045 ,true, const Color.fromRGBO(84, 209, 130, 1), CupertinoIcons.arrow_2_squarepath ),
                    action(1045 ,true, Colors.pink, CupertinoIcons.heart ),
                    action(0 ,false, null, CupertinoIcons.chart_bar_alt_fill ),
                    action(0 ,false, null, Icons.share_outlined ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


