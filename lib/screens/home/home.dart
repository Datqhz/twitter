import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/services/storage.dart';
import 'package:twitter/widgets/tweet_widget.dart';

import '../../shared/app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  late TabController _tabController;
  Storage storage = Storage();
  final DatabaseService _databaseService = DatabaseService();
  List<Tweet> tweetsForU=[];
  List<Tweet> tweetsFollowing=[];
  @override
  void initState(){

    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData()async{
    try{
      List<Tweet> data1 =  await _databaseService.getTweetForU();
      List<Tweet> data2 =  await _databaseService.getTweetFollowing();
      setState(() {
        tweetsForU = data1;
        tweetsFollowing = data2;
      });
    }catch(e){
      print(e);
    }
  }
  List<Widget> buildListTweet(List<Tweet> tweets){
    List<Widget> items = [];
    if(tweets.isNotEmpty){
      for(Tweet t in tweets){
        items.add(TweetWidget(tweet: t));
      }
    }
    items.add(Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.4
              )
          )
      ),
      child: const Icon(CupertinoIcons.circle_fill, size: 5,),
    ));
    items.add(const SizedBox(height: 50,));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            TabBarView(
                controller: _tabController,
                children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      padding: const EdgeInsets.only(top: 88),
                      child: ListView(
                        children: buildListTweet(tweetsForU),
                       )
                    ),
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      padding: const EdgeInsets.only(top: 88),
                      child: ListView(
                        children: buildListTweet(tweetsFollowing),
                      )
                  ),
                ]
            ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: MyAppBar(currentPage: 0)
            ),
            Positioned(
                top: 48,
                right: 0,
                left: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(width: 0.14, color: Theme.of(context).dividerColor)
                    )
                  ),
                  child: TabBar(
                    unselectedLabelColor: const Color.fromRGBO(170, 184, 194, 1),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    controller: _tabController,
                    tabs: const [
                      Text('For you'),
                      Text('Following')
                    ],
                  ),
                )
            ),
          ]

      );
  }
}
