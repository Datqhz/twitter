import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/screens/profile/follow_view.dart';
import 'package:twitter/services/database_service.dart';

import '../../models/tweet.dart';
import '../../shared/global_variable.dart';
import '../../widgets/tweet_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin{
  double avatarSize = 100;
  double previousScroll = 0;
  double top = 0;
  bool showAppbar = false;
  bool showTabbar = false;
  late TabController _tabController;
  DatabaseService _databaseService = DatabaseService();
  List<Tweet> tweets = [];
  // late ScrollController scrollController;
  List<ScrollController> tabScrollControllers = List.generate(5, (index) => ScrollController());
  List<PageStorageKey<int>> pageKeys = List.generate(5, (index) => PageStorageKey<int>(index));
  List<double> currentOffset = [280, 280, 280, 280, 280];
  @override
  void initState(){
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      // currentOffset[_tabController.previousIndex] = tabScrollControllers[_tabController.previousIndex].offset;
      // if(top>-280){
      //   tabScrollControllers[_tabController.index].jumpTo(-top);
      //   currentOffset[_tabController.index] = -top;
      // }else {
      //   tabScrollControllers[_tabController.index].jumpTo(currentOffset[_tabController.index]);
      // }
    });
    for(ScrollController scroll in tabScrollControllers){
      scroll.addListener(() {
        avatarSize = 100 - scroll.offset;
        top = - scroll.offset;
        if(top < -280){
          top = -280;
        }
        if(avatarSize < 50){
          avatarSize = 50;
        }
        if (scroll.offset > 100) {
          showAppbar = true;
        } else {
          showAppbar = false;
        }
        setState(() {});
      });
    }
    super.initState();
    fetchData();
  }
  Future<void> fetchData()async{
    try{
      tweets =  await _databaseService.getTweetWithCurrentUID();
      print(tweets);
      setState(() {
      });
    }catch(e){
      print(e);
    }

  }
  List<Tweet> filterListTweetForTab(int index){
    List<Tweet> rs = [];
    switch(index){
      case 0:
        rs = tweets;
      case 1:
        rs = tweets;
      case 2:
        rs = tweets;
      case 3:
        rs = tweets.where((element) => (element.imgLinks.length + element.videoLinks.length )!=0).toList();
      default:

    }
    return rs;
  }
  List<Widget> buildListTweet(int index){
    List<Widget> items = [SizedBox(height: 380,)];
    if(tweets.length>0){
      for(Tweet t in filterListTweetForTab(index)){
        items.add(TweetWidget(tweet: t));
      }
    }
    items.add(SizedBox(height: 50,));
    return items;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
              children: [
                TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTabContent("post", 0),
                        _buildTabContent("reply",1),
                        _buildTabContent("highlight",2),
                        _buildTabContent("media",3),
                        _buildTabContent("media",4),
                      ]
                ),
                //user info and tabbar
                Positioned(
                  top: top,
                  left: 0,
                  right:0,
                  child: SizedBox(
                    height: 360+avatarSize,
                    child: Column(
                        children: [
                          Container(
                            height: 150,
                            width:  MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(GlobalVariable.wall),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                              transform: Matrix4.translationValues(0, 50-avatarSize, 0),
                              width: MediaQuery.of(context).size.width,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                              children:[
                                //Avatar & button edit
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: (100-avatarSize)/2),
                                      child:  Container(
                                        alignment: Alignment.centerLeft,
                                        height: avatarSize,
                                        width: avatarSize,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Image.network(GlobalVariable.avatar),

                                      ),
                                    ),
                                    OutlinedButton(
                                        onPressed: (){},
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        side: BorderSide(
                                          color: Theme.of(context).dividerColor, // Set the border color here
                                          width: 1.0, // Set the border width here
                                        ),
                                          shape:RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0), // Set the border radius here
                                          ),
                                        ),
                                        child: const Text(
                                          "Edit profile"
                                        ),
                                    )
                                  ],
                              ),
                                ),
                                SizedBox(height: 8,),
                                // user display name
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Text(
                                    GlobalVariable.currentUser!.displayName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6,),
                                //Username
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Text(
                                      GlobalVariable.currentUser!.username,
                                      style: TextStyle(
                                        color: Color.fromRGBO(170, 184, 194, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,

                                      ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                // joined time
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: const Row(
                                    children: [
                                      Icon(CupertinoIcons.calendar, size: 14, color: Color.fromRGBO(170, 184, 194, 1),),
                                      SizedBox(width: 8,),
                                      Text(
                                        "Joined November 2023 ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(170, 184, 194, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                // following & followed
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Row(
                                    children: [
                                      Text(
                                        GlobalVariable.numOfFollowing.toString(),
                                        style: TextStyle(
                                          color: Colors.white ,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Follow()));
                                        },
                                        child: Text(
                                          " Following",
                                          style: TextStyle(
                                            color: Color.fromRGBO(170, 184, 194, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      Text(
                                        GlobalVariable.numOfFollowed.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      Text(
                                        "Followed",
                                        style: TextStyle(
                                          color: Color.fromRGBO(170, 184, 194, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16,),
                                Container(
                                  color: Colors.black,
                                  height: 40,
                                  width: double.infinity,
                                  child: TabBar(
                                    unselectedLabelColor: Color.fromRGBO(170, 184, 194, 1),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    // padding: EdgeInsets.only(bottom: 12),
                                    indicatorWeight: 3,
                                    isScrollable: true,
                                    controller: _tabController,
                                    tabs: const [
                                      Text('Posts'),
                                      Text('Replies'),
                                      Text('Highlights'),
                                      Text('Media'),
                                      Text('Likes'),
                                    ],
                                  ),
                                ),
                            ]
                            ),
                          ),

                        ],
                    ),
                  ),
                ),
                //image appbar +blur
                Visibility(
                  visible: showAppbar,
                  child: Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 50,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/wall.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // child: BackdropFilter(
                      //   filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      //   child: Container(
                      //     color: Colors.black.withOpacity(0.4),
                      //   ),
                      // ),
                    ),
                  ),
                ),
                //button appbar
                Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(CupertinoIcons.arrow_left),
                          onPressed: (){Navigator.pop(context);},
                        ),
                        SizedBox(width: 12,),
                        Expanded(
                            flex: 1,
                            child: Visibility(
                              visible: showAppbar,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobalVariable.currentUser!.displayName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                  Text(
                                    "6 posts",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        IconButton(
                          icon: Icon(CupertinoIcons.search),
                          onPressed: (){},
                        ),
                        IconButton(
                          icon: Icon(CupertinoIcons.ellipsis_vertical),
                          onPressed: (){},
                        ),
                      ],
                    ),
                )
              ],
        ),
      ),
    );
  }
  List<Widget>_loadList(String text){
    List<Widget> rs = [];
    for(int i in List.generate(20, (index) =>index)){
      rs.add(ListTile(
        title: Container(
          color: Colors.blue,
          width: 100,
          height: 100,
          child: Text(i.toString() + text),
        ),
      ));
    }
    return rs;
  }
  Widget _buildTabContent(String text, int tabIndex) {
    return ListView(
      key: pageKeys[tabIndex],
      controller: tabScrollControllers[tabIndex],
      children: buildListTweet(tabIndex),
    );
  }
}
