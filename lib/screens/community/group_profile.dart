import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    _tabController =  TabController(length: 2, vsync: this);
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
                  children: [
                    Container(
                      child: Text(
                        "tweet"
                      ),
                    ),
                    AboutGroupView(),
                    // Container(
                    //   child: Text(
                    //       "tweet"
                    //   ),
                    // ),
                  ],
              ),
              Positioned(
                  top: 0,
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
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 56,
                  color: Color.fromRGBO(22, 22, 26, 1.0).withOpacity(0),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                            height: 34,
                            width: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(17)
                            ),
                            child: Icon(FontAwesomeIcons.arrowLeft, size: 19 ,color: Colors.white,)
                        ),
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
                                    color: Colors.white.withOpacity(0.4),
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
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16)
                                ),
                                child: Icon(FontAwesomeIcons.ellipsisVertical, size: 19, color: Colors.white,)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
    super.dispose();
  }
}

class AboutGroupView extends StatelessWidget {
  const AboutGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
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


