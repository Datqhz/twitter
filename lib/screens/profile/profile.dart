
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter/models/user_info_with_follow.dart';
import 'package:twitter/screens/profile/edit-profile.dart';
import 'package:twitter/screens/profile/follow_view.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/shared/loading.dart';

import '../../models/tweet.dart';
import '../../services/storage.dart';
import '../../shared/global_variable.dart';
import '../../widgets/tweet_widget.dart';

class Profile extends StatefulWidget {
  Profile({super.key, required this.uid});
  String uid;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin{

  ValueNotifier<double> top = ValueNotifier(0);
  ValueNotifier<double> avatarSize = ValueNotifier(100);
  ValueNotifier<bool> showAppbar = ValueNotifier(false);
  ValueNotifier<String?> avatarLink = ValueNotifier(null);
  ValueNotifier<String?> wallLink = ValueNotifier(null);
  late TabController _tabController;
  final DatabaseService _databaseService = DatabaseService();
  List<Tweet> tweets = [];
  List<Tweet> replyTweets = [];
  List<Tweet> likedTweets = [];
  List<Tweet> mediaTweets = [];
  late MyUserWithFollow user;
  bool _isLoad = true;
  // late ScrollController scrollController;
  List<ScrollController> tabScrollControllers = List.generate(5, (index) => ScrollController());
  List<PageStorageKey<int>> pageKeys = List.generate(5, (index) => PageStorageKey<int>(index));
  List<double> currentOffset = [280, 280, 280, 280, 280];
  @override
  void initState(){
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      currentOffset[_tabController.previousIndex] = tabScrollControllers[_tabController.previousIndex].offset;
      if(top.value>-280){
        tabScrollControllers[_tabController.index].jumpTo(-top.value);
        currentOffset[_tabController.index] = -top.value;
      }else {
        tabScrollControllers[_tabController.index].jumpTo(currentOffset[_tabController.index]);
      }
    });
    for(ScrollController scroll in tabScrollControllers){
      scroll.addListener(() {
        double newAvatarSize = 100 - scroll.offset;
        double newTop = - scroll.offset;
        bool show = false;
        if(newTop < -280){
          newTop = -280;
        }
        if(newAvatarSize < 50){
          newAvatarSize = 50;
        }
        if (scroll.offset > 100 ) {
          show = true;
        } else {
          show = false;
        }
        if(show != showAppbar.value){
          showAppbar.value = show;
        }
        avatarSize.value = newAvatarSize;
        top.value = newTop;
      });
    }
    super.initState();
    fetchData();
  }
  Future<void> fetchData()async{
    try{
      user = await _databaseService.getUserInfoWithFollow(widget.uid);
      tweets =  await _databaseService.getTweetOfUid(widget.uid);
      replyTweets =  await _databaseService.getReplyTweetOfUid(widget.uid);
      likedTweets =  await _databaseService.getLikedTweetByUid(widget.uid);
      mediaTweets =  await _databaseService.getMediaTweetOfUid(widget.uid);
      avatarLink.value = await Storage().downloadAvatarURL(user.myUser.avatarLink);
      wallLink.value = await Storage().downloadWallURL(user.myUser.wallLink);
      _isLoad = false;
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
        rs = replyTweets;
      case 2:
        rs = tweets;
      case 3:
        rs = mediaTweets;
      default:
        rs = likedTweets;
    }
    return rs;
  }
  List<Widget> buildListTweet(int index){
    List<Widget> items = [const SizedBox(height: 380,)];
    if(tweets.isNotEmpty){
      for(Tweet t in filterListTweetForTab(index)){
        items.add(TweetWidget(tweet: t));
      }
    }
    items.add(const SizedBox(height: 50,));
    return items;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoad ? const Loading() : SafeArea(
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
                ValueListenableBuilder(
                  valueListenable: top,
                  builder: (context, value, child){
                    return AnimatedPositioned(
                      top: value,
                      left: 0,
                      right:0,
                      duration: const Duration(milliseconds: 10),
                      child: SizedBox(
                        height: 360+avatarSize.value,
                        child: Column(
                          children: [
                            // wall
                            ValueListenableBuilder(
                                valueListenable: wallLink,
                                builder: (context, value, child){
                                  if(value!=null){
                                    return Container(
                                      height: 150,
                                      width:  MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(value),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }else {
                                    return Container(
                                      height: 150,
                                      width:  MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/images/black.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                }
                            ),
                            Container(
                              transform: Matrix4.translationValues(0, 50-avatarSize.value, 0),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    //Avatar & button edit
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: (100-avatarSize.value)/2),
                                            child:  Container(
                                              alignment: Alignment.centerLeft,
                                              height: avatarSize.value,
                                              width: avatarSize.value,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                              child: ValueListenableBuilder(
                                                valueListenable: avatarLink,
                                                builder: (context, value, child){
                                                  if(value!= null){
                                                    return CircleAvatar(
                                                      backgroundColor: Colors.black,
                                                      radius: 50,
                                                      backgroundImage: NetworkImage(value),
                                                    );
                                                  }else {
                                                    return const CircleAvatar(
                                                      backgroundColor: Colors.black,
                                                      radius: 50,
                                                    );
                                                  }
                                                },
                                              )

                                            ),
                                          ),
                                          const Expanded(child: SizedBox(height: 1,)),
                                          //notify option button
                                          if(GlobalVariable.currentUser?.myUser.uid != widget.uid) ...[GestureDetector(
                                            child: Container(
                                                height: 38,
                                                width: 38,
                                                margin: const EdgeInsets.only(bottom: 4, right: 12),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(25),
                                                    border: Border.all(color: Theme.of(context).dividerColor, width: 1)
                                                ),
                                                child: Icon(user.isFollow == true ?CupertinoIcons.bell: CupertinoIcons.bell_slash, color: Colors.white, size: 16,)
                                            ),
                                          ),],
                                          ValueListenableBuilder(
                                            valueListenable: wallLink,
                                            builder: (context, value, child){
                                              return OutlinedButton(
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen(avatarLink: avatarLink, wallLink: wallLink,)));
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8,),
                                    // user display name
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Text(
                                        user.myUser.displayName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6,),
                                    //Username
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Text(
                                        user.myUser.username,
                                        style: const TextStyle(
                                          color: Color.fromRGBO(170, 184, 194, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,

                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    // joined time
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Row(
                                        children: [
                                          const Icon(CupertinoIcons.calendar, size: 14, color: Color.fromRGBO(170, 184, 194, 1),),
                                          const SizedBox(width: 8,),
                                          Text(
                                            "Joined ${DateFormat.yMMMM("en_US").format(user.myUser.createDate)}",
                                            style: const TextStyle(
                                              color: Color.fromRGBO(170, 184, 194, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    // following & followed
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Row(
                                        children: [
                                          Text(
                                            user.numOfFollowing.toString(),
                                            style: const TextStyle(
                                              color: Colors.white ,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>FollowView(uid: GlobalVariable.currentUser!.myUser.uid, isFollowing: true,)));
                                            },
                                            child: const Text(
                                              " Following",
                                              style: TextStyle(
                                                color: Color.fromRGBO(170, 184, 194, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8,),
                                          Text(
                                            user.numOfFollowed.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8,),
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>FollowView(uid: GlobalVariable.currentUser!.myUser.uid, isFollowing: false)));
                                            },
                                            child: const Text(
                                              "Followers",
                                              style: TextStyle(
                                                color: Color.fromRGBO(170, 184, 194, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16,),
                                    Container(
                                      color: Colors.black,
                                      height: 40,
                                      width: double.infinity,
                                      child: TabBar(
                                        unselectedLabelColor: const Color.fromRGBO(170, 184, 194, 1),
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
                    );
                  },
                ),

                //button appbar
                ValueListenableBuilder(
                  valueListenable: showAppbar,
                    builder: (context, value, child){
                      return Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          decoration: value? BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(wallLink.value!),
                              fit: BoxFit.cover,
                            ),
                          ):null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(CupertinoIcons.arrow_left),
                                onPressed: (){Navigator.pop(context);},
                              ),
                              const SizedBox(width: 12,),
                              Expanded(
                                  flex: 1,
                                  child: Visibility(
                                    visible: value,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.myUser.displayName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              IconButton(
                                icon: const Icon(CupertinoIcons.search),
                                onPressed: (){},
                              ),
                              IconButton(
                                icon: const Icon(CupertinoIcons.ellipsis_vertical),
                                onPressed: (){},
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                )
              ],
        ),
      ),
    );
  }
  Widget _buildTabContent(String text, int tabIndex) {
    return ListView(
      key: pageKeys[tabIndex],
      controller: tabScrollControllers[tabIndex],
      children: buildListTweet(tabIndex),
    );
  }
}
