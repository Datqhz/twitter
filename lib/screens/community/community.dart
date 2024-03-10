import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twitter/screens/community/group_profile.dart';
import 'package:twitter/services/database_service.dart';

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
  double _previous = 0;
  double tempHeight = 0;
  bool isShow = true;

  Widget communities(context, Group group){
    return GestureDetector(
      onTap:(){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> GroupScreen(group: group)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                width: 90,
                child: FutureBuilder<String?>(
                    future: Storage().downloadGroupULR(group.groupImg), // Replace with your function to load the image
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        );
                      }else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/images/black.jpg", // Replace with your placeholder image
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                ),
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.groupName,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 15
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          group.groupMembers.length.toString() + " Members",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 140,
                      child: AvatarStack(
                        borderColor: Colors.black,
                        height: 36,
                        width: 36,
                        avatars: [
                          for (var n = 0; n < 5; n++)
                            AssetImage('assets/images/wall.jpg'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
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
    rs.add(SizedBox(height: 16,));
    groups.forEach((element) {
      rs.add(communities(context, element));
      rs.add(SizedBox(height: 16,));
    });
    rs.add(SizedBox(height: 10,));
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
  @override
  void initState() {
    // _scrollController = ScrollController()..addListener(() {
    //   tempHeight += _previous - _scrollController.offset;
    //   if(tempHeight<=-50){
    //     tempHeight = -50;
    //   }else if(tempHeight>=0){
    //     tempHeight = 0;
    //   }
    //   _previous = _scrollController.offset;
    //   setState(() {
    //
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50 + tempHeight),
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (ScrollEndNotification scrollEnd){
                  setState(() {
                    if(tempHeight <- 25){
                      isShow = false;
                      tempHeight = -50;
                    }else{
                      isShow = true;
                      tempHeight = 0;
                    }
                    // this.widget.callback(isShow);
                  });
                  return true;
                },
                child: FutureBuilder<List<Group>>(
                  future: DatabaseService().getAllGroup(),
                  builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        return ListView(
                          controller: _scrollController,
                          children: loadGroups(snapshot.data!),
                        );
                      }else {
                        return SpinKitPulse(
                          color: Colors.blue,
                        );
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
