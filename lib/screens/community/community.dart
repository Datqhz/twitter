import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Widget communities(context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/wall.jpg"), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10)
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
                        "Cooking",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                            fontSize: 15
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        "149K Members",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 15
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 120,
                    child: AvatarStack(
                      borderColor: Colors.black,
                      height: 30,
                      width: 30,
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
    );
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
                child: ListView(
                  controller: _scrollController,
                  children: [
                    SizedBox(height: 10,),
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
                    ),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    communities(context),
                    SizedBox(height: 16,),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "Show more",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
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
                    ),
                    SizedBox(height: 50)
                  ],
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
