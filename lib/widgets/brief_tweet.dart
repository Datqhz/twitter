import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/tweet.dart';
import '../services/storage.dart';
import 'ImageGridView.dart';

class BriefTweet extends StatelessWidget {
  BriefTweet({super.key, required this.tweet});
  late Tweet tweet;

  Widget buildMediaView(){
    return Container(
        color: Colors.black,
        width: 80,
        height: 80,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: tweet.imgLinks.length + tweet.videoLinks.length == 1? Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<String?>(
                future: Storage().getImageTweetURL(tweet.imgLinks[0]),
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
                :ImageGridView(imageLinks: tweet.imgLinks)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Avatar user post
              Container(
                //alignment: Alignment.centerLeft,
                  height: 38,
                  width: 38,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FutureBuilder(
                    future: Storage().downloadAvatarURL(tweet.user!.avatarLink),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                        return Image.network(snapshot.data!);
                      }else {
                        return SizedBox(height: 1,);
                      }
                    },
                  )
              ),
              const SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //user info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tweet.user!.displayName,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),
                            ),
                            SizedBox(width: 8,),
                            Text(
                              tweet.user!.username,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.5),
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ],
                        ),
                        //post time
                        Text(
                          '3h',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.5)
                          ),
                        ),
                      ],
                    ),
                    //is replied?
                    if(tweet.replyTo!=null)...[
                      Text(
                        "Replying to ${tweet.replyTo?.username}",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                    SizedBox(height: 4,),
                    //Tweet content and media
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(tweet.content.isNotEmpty)...[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: tweet.content.length>200? "${tweet.content.substring(0,200)}...": tweet.content,
                                ),
                                if(tweet.content.length>200)...[TextSpan(
                                  text:  "Show more",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14
                                  ),
                                )],
                              ],
                            ),
                          ),
                        ],
                        if(tweet.imgLinks.length+tweet.videoLinks.length !=0)...[
                          buildMediaView()
                        ]
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
