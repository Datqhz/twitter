import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/screens/community/community_item.dart';
import 'package:twitter/screens/community/group_profile.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/widgets/tweet_widget.dart';

import '../../models/group.dart';
import '../../services/storage.dart';
import '../../shared/app_bar.dart';
class Community extends StatefulWidget {
  Community({super.key, required this.callback});
  Function(bool) callback;

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {

  late ScrollController _scrollController = ScrollController();
  double tempHeight = 0;
  bool isShow = true;
  late Future<List<Group>> listJoined;

  List<Widget> loadGroups(List<Group> groups){
    List<Widget> rs = [SizedBox(height: 10,),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Discover new Communities",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              ),
            ),
            GestureDetector(
              child: Icon(CupertinoIcons.ellipsis_vertical, size: 14, color: Colors.white,),
            )
          ],
        ),
      ),];
    groups.forEach((element) {
      rs.add(CommunitiesItem(group: element));
    });
    rs.add(Container(
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
        ));
    rs.add(SizedBox(height: 50));
    return rs;
  }
  List<Widget> buildTweet(List<Tweet> tweets){
    List<Widget> rs = [];
    print("num of tweet: " + tweets.length.toString());
    for (var element in tweets) {
      rs.add(TweetWidget(tweet: element));
    }
    return rs;
  }
  Widget groupItem(Group group){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>GroupScreen(group: group)));
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 86,
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black,
          border: Border.all(width: 1, color: Color.fromRGBO(40, 49, 63, 1.0))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: Storage().downloadGroupULR(group.groupImg),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                    return Image(image: NetworkImage(snapshot.data!), height: 50, width: double.infinity,fit: BoxFit.cover,);
                  }else {
                    return SpinKitPulse(size: 10, color: Colors.blue,);
                  }
                },
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              color: Color.fromRGBO(22, 22, 26, 1.0),
              child: Text(
                group.groupName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  List<Widget> buildGroupJoined(List<Group> groups){
    List<Widget> rs = [SizedBox(width: 12,)];
    groups.forEach((element) { 
      rs.add(groupItem(element));
      rs.add(SizedBox(width: 12,));
    });
    return rs.sublist(0, rs.length-1);
  }
  @override
  void initState() {
    // listJoined = DatabaseService().getGroupJoined();
    super.initState();
    listJoined =DatabaseService().getGroupJoined();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50 + tempHeight),
              height: double.infinity,
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (ScrollEndNotification scrollEnd){
                  return true;
                },
                child: FutureBuilder(
                  future: listJoined,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.data?.length!=0){
                        return ListView(
                          children: [
                            Container(
                                height: 103,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(width: 0.15, color: Colors.white.withOpacity(0.5))
                                    )
                                ),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: buildGroupJoined(snapshot.data!),
                                ),
                              ),
                            FutureBuilder(
                              future: DatabaseService().getTweetOfGroupJoined(),
                              builder: (context, snapshot){
                                if(snapshot.connectionState == ConnectionState.done&& snapshot.hasData){
                                  return Column(
                                    children: [
                                      ...buildTweet(snapshot.data!)
                                    ],
                                  );
                                }else {
                                  return SpinKitPulse(
                                    color: Colors.blue,
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }else{
                        return FutureBuilder(
                          future: DatabaseService().getAllGroup(),
                          builder: (context, snapshot){
                            if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                              return ListView(
                                children: loadGroups(snapshot.data!)
                              );
                            }else {
                              return Center(child: SpinKitPulse(color: Colors.blue,));
                            }
                          },
                        );
                      }
                    }
                    else {
                      return Center(child: SpinKitPulse(color: Colors.blue,),);
                    }
                  },
                ),
              ) ,
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                top: tempHeight,
                right: 0,
                left: 0,
                child: MyAppBar(currentPage: 2)
            ),
          ]
      );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
