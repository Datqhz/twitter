import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/screens/profile/follow_view.dart';

import '../../models/tweet.dart';
import '../../shared/global_variable.dart';
import '../../widgets/tweet_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin{
  double imageSize = 0;
  double avatarSize = 100;
  double imageOpacity = 1;
  double previousScroll = 0;
  double top = 0;
  bool showAppbar = false;
  bool showTabbar = false;
  late TabController _tabController;
  late ScrollController scrollController;
  List<GlobalKey<ScrollableState>> tabKeys = List.generate(5, (index) => GlobalKey<ScrollableState>());
  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
        // print("current scroll " + scrollController.offset.toString());
    });
    imageSize = 0;
    scrollController = ScrollController()
      ..addListener(() {
        imageSize = -scrollController.offset;
        avatarSize = 100 - scrollController.offset;
        top = 0 - scrollController.offset;
        // print("Scroll " + scrollController.offset.toString());
        if(top < -265){
          top = -265;
        }
        if(imageSize<-100){
          imageSize = -100;
        }
        if(avatarSize < 50){
          avatarSize = 50;
        }
        imageOpacity =  (imageSize / -100);
        if (scrollController.offset > 100) {
          showAppbar = true;
        } else {
          showAppbar = false;
        }
        setState(() {});
      });
    super.initState();
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
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildTabContent("post"),
                        _buildTabContent("reply"),
                        _buildTabContent("highlight"),
                        _buildTabContent("media"),
                        _buildTabContent("media"),
                        // Container(
                        //   padding: EdgeInsets.only(top: 360+top),
                        //   child: _buildTabContent("like"),
                        // )
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
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              color: Colors.black,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                              children:[
                                //Avatar & button edit
                                Row(
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
                                SizedBox(height: 8,),
                                // user display name
                                Text(
                                  GlobalVariable.currentUser!.displayName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6,),
                                //Username
                                Text(
                                    GlobalVariable.currentUser!.username,
                                    style: TextStyle(
                                      color: Color.fromRGBO(170, 184, 194, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,

                                    ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                // joined time
                                const Row(
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
                                SizedBox(height: 10,),
                                // following & followed
                                Row(
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
                                SizedBox(height: 16,),
                                TabBar(
                                  unselectedLabelColor: Color.fromRGBO(170, 184, 194, 1),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  padding: EdgeInsets.only(bottom: 12),
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
                            ]
                            )
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
                Visibility(
                  visible: showTabbar,
                  child: Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: TabBar(
                        unselectedLabelColor: Color.fromRGBO(170, 184, 194, 1),
                        indicatorSize: TabBarIndicatorSize.label,
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
  Widget _buildTabContent(String text) {
    return ListView(
      controller: scrollController,
      // key: PageStorageKey<String>(text),
      children: _loadList(text),

    );
  }
}
