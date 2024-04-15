import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/notify.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/widgets/tweet_widget.dart';

import '../../shared/app_bar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  List<MyNotification> notificationList = [];


  Future<void> fetchData()async{
    try{
      List<MyNotification> data = await DatabaseService().getNotification();
      setState(() {
        notificationList = data;
      });
    }catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Widget> buildListNotification(){
    List<Widget> rs = [];
    if(notificationList.length !=0){
      print("0");
      rs.add(const SizedBox(height: 50));
      for(MyNotification notification in notificationList){
        if(notification.type == 1){
          rs.add(TweetWidget(tweet: notification.tweet));
        }else {
          rs.add(NotifyItem(notification: notification));
        }
      }
      rs.add(Container(
        padding: EdgeInsets.only(top: 12, bottom: 70),
        child: Icon(CupertinoIcons.circle_fill, size: 5,),
      ));
    }else {
      print("1");
      rs.add(const Center(
        child: Text(
          "There are currently no notifications available to you",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
          ),
        ),
      ));
    }

    return rs;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: buildListNotification(),
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: MyAppBar(currentPage: 3)
            ),
          ]
      );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


class NotifyItem extends StatelessWidget {
  NotifyItem({super.key, required this.notification});
  MyNotification notification; // 2 repost, 3 new post

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.8),
            width: 0.15
          )
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon( notification.type == 2? CupertinoIcons.arrow_2_squarepath : CupertinoIcons.bell_fill, color: notification.type == 2 ? Colors.green: Colors.blue, size: 24,),
          SizedBox(width: 12,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //alignment: Alignment.centerLeft,
                  height: 30,
                  width: 30,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset("assets/images/patty.png")
              ),
              SizedBox(height: 6,),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                      color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400
                  ),
                  children: [
                    if(notification.type == 3) ...[TextSpan(
                      text: "New post notifications for ",
                    )],
                    TextSpan(
                      text: 'Cher',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    if(notification.type == 2) ...[TextSpan(
                      text: " reposted your post",
                    )]
                  ],
                ),
              ),
              SizedBox(height: 6,),
              Text(
                "pic.twitter.com/kdjdjsv",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
