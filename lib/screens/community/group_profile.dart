import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/widgets/tweet_widget.dart';

import '../../models/tweet.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> with SingleTickerProviderStateMixin{

  ValueNotifier<double> top = ValueNotifier(0);
  ValueNotifier<double> opacity = ValueNotifier(0);
  late TabController _tabController;
  List<ScrollController> _scrollControllers = List.generate(2, (index) => ScrollController());
  @override
  void initState() {
    _tabController =  TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if(top.value >-265){
        _scrollControllers[_tabController.index].jumpTo(-top.value);
      }
    });
    _scrollControllers.forEach((element) {
      element.addListener(() {
        double newTop = -element.offset;
        double op = element.offset/135;
        if(newTop < -250){
          newTop = -250;
        }
        if(op>1){
          op = 1;
        }
        top.value = newTop;
        opacity.value = op;
      });
    });
    super.initState();
  }


  List<Widget> loadTweet(List<Tweet>? tweets){
    List<Widget> widgets =[SizedBox(height: 360,)];
    tweets?.forEach((element) {
      widgets.add(TweetWidget(tweet: element));
    });
    return widgets;
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
                    FutureBuilder(
                        future: DatabaseService().getTweet(),
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            return ListView(
                              controller: _scrollControllers[0],
                                key: PageStorageKey<int>(1),
                                children: loadTweet(snapshot.data)
                            );
                          }else {
                            return Center(
                              child: SpinKitPulse(
                                color: Colors.blue,
                                size: 25.0,
                              ),
                            );
                          }
                        }
                    ),

                    AboutGroupView(controller: _scrollControllers[1],),
                    // Container(
                    //   child: Text(
                    //       "tweet"
                    //   ),
                    // ),
                  ],
              ),
              ValueListenableBuilder<double>(
                valueListenable: top,
                builder: (context, value, child){
                  return Positioned(
                      top: value,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 190,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/group.jpg"
                                    ),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Color.fromRGBO(22, 22, 26, 1.0),
                            padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "The Design Sphere",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 32,
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: AvatarStack(
                                            borderColor: Colors.black,
                                            height: 30,
                                            width: 30,
                                            avatars: [
                                              for (var n = 0; n < 3; n++)
                                                AssetImage('assets/images/wall.jpg'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 4,),
                                        Text(
                                          "149k Members",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white.withOpacity(0.8)
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(width: 1, color: Colors.white)
                                          ),
                                          child: Icon(Icons.share_outlined, size: 18,),
                                        ),
                                        SizedBox(width: 8,),
                                        OutlinedButton(
                                          onPressed: (){},
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Colors.white, // Set the border color here
                                              width: 1.0, // Set the border width here
                                            ),
                                            shape:RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0), // Set the border radius here
                                            ),
                                          ),
                                          child: const Text(
                                              "Join in",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white
                                              )
                                          ),
                                        ),
                                        SizedBox(width: 8,),
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(width: 1, color: Colors.white)
                                          ),
                                          child: Icon(CupertinoIcons.bell, size: 18,),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.white.withOpacity(0.6),
                                        width: 0.2
                                    )
                                )
                            ),
                            child: TabBar(
                              controller: _tabController,
                              unselectedLabelColor: Colors.white.withOpacity(0.6),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 3,
                              tabs: [
                                Text(
                                  "Trending",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15
                                  ),
                                ),
                                Text(
                                  "About",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                  );
                },

              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<double>(
                  valueListenable: opacity,
                  builder: (context, value, child){
                    return Container(
                      height: 55,
                      color: Color.fromRGBO(22, 22, 26, 1.0).withOpacity(value),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){

                                },
                                child: Container(
                                    height: 34,
                                    width: 34,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity((0.4-value).clamp(0, 0.4)),
                                        borderRadius: BorderRadius.circular(17)
                                    ),
                                    child: Icon(FontAwesomeIcons.arrowLeft, size: 19 ,color: Colors.white,)
                                ),
                              ),
                              SizedBox(width: 14,),
                              Text(
                                "The Design Sphere",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(value),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){

                                },
                                child: Container(
                                    height: 32,
                                    width: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity((0.4-value).clamp(0, 0.4)),
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Icon(FontAwesomeIcons.search, size: 19, color: Colors.white,)
                                ),
                              ),
                              SizedBox(width: 20,),
                              GestureDetector(
                                onTap: (){

                                },
                                child: Container(
                                    height: 32,
                                    width: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity((0.4-value).clamp(0, 0.4)),
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Icon(FontAwesomeIcons.ellipsisVertical, size: 19, color: Colors.white,)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollControllers[0].dispose();
    _scrollControllers[1].dispose();
    super.dispose();
  }
}

class AboutGroupView extends StatelessWidget {
  AboutGroupView({super.key, required this.controller});
  ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        controller: controller,
        key: PageStorageKey<int>(2),
        child: Column(
          children: [
            SizedBox(height: 360,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.2,
                          color: Colors.white.withOpacity(0.5)
                      )
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Community Info",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:Colors.white.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 26,),
                  Text(
                    "Welcome to The Design Sphere,"
                        " where designers from around the world showcase their work, share feedback, and collaborate on fresh ideas",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:Colors.white.withOpacity(0.7),

                    ),
                  ),
                  SizedBox(height: 18,),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(CupertinoIcons.person_2_fill, color: Colors.white.withOpacity(0.5),),
                            SizedBox(width: 16,),
                            Expanded(
                              child: Text(
                                "Only Community members can post, like, or reply.",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color:Colors.white.withOpacity(0.7),
                                    overflow: TextOverflow.visible
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18,),
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.earth,size: 21, color: Colors.white.withOpacity(0.5),),
                            SizedBox(width: 16,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "All Communities are publicly visible.",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color:Colors.white.withOpacity(0.9)
                                  ),
                                ),
                                Text(
                                  "Anyone can join this Community",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color:Colors.white.withOpacity(0.7)
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 18,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(CupertinoIcons.calendar, color: Colors.white.withOpacity(0.5),),
                            SizedBox(width: 16,),
                            Container(
                              child: Text(
                                "Create 29 Oct 21 by @retromauro",
                                style:TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color:Colors.white.withOpacity(0.7)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.2,
                          color: Colors.white.withOpacity(0.5)
                      )
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rules",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:Colors.white.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 26,),
                  Text(
                    "Community rules are enforced by Community leaders, and are in addition to our Rules",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color:Colors.white.withOpacity(0.7),

                    ),
                  ),
                  SizedBox(height: 18,),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(17)
                              ),
                              child: Text("1", style: TextStyle(
                                  color: Colors.blue.shade100.withOpacity(0.5)
                              ),),
                            ),
                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Be Respectful.",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:Colors.white.withOpacity(0.9)
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "We encourage constructive criticism delivered in a kind and productive way",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color:Colors.white.withOpacity(0.7)
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 18,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(17)
                              ),
                              child: Text("1", style: TextStyle(
                                  color: Colors.blue.shade100.withOpacity(0.5)
                              ),),
                            ),
                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Be Respectful.",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:Colors.white.withOpacity(0.9)
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "We encourage constructive criticism delivered in a kind and productive way",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color:Colors.white.withOpacity(0.7)
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 18,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(17)
                              ),
                              child: Text("1", style: TextStyle(
                                  color: Colors.blue.shade100.withOpacity(0.5)
                              ),),
                            ),
                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Be Respectful.",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:Colors.white.withOpacity(0.9)
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "We encourage constructive criticism delivered in a kind and productive way",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color:Colors.white.withOpacity(0.7)
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.2,
                          color: Colors.white.withOpacity(0.5)
                      )
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Moderators",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:Colors.white.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 26,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "14 Morderators",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color:Colors.white.withOpacity(0.7)
                        ),
                        softWrap: true,
                      ),
                      Icon(CupertinoIcons.chevron_right, color: Colors.white.withOpacity(0.8),),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.2,
                          color: Colors.white.withOpacity(0.5)
                      )
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Members",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:Colors.white.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 26,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "210168 Community Members",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color:Colors.white.withOpacity(0.7)
                        ),
                        softWrap: true,
                      ),
                      Icon(CupertinoIcons.chevron_right, color: Colors.white.withOpacity(0.8),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


