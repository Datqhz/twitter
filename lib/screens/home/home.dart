import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/services/storage.dart';
import 'package:twitter/shared/global_variable.dart';
import 'package:twitter/widgets/tweet_view.dart';
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
  DatabaseService _databaseService = DatabaseService();
  List<Tweet> tweets=[];
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
      List<Tweet> data =  await _databaseService.getTweet();
      setState(() {
        tweets = data;
      });
    }catch(e){
      print("Lỗi:");
    }

  }
  List<Widget> buildListTweet(){
    List<Widget> items = [];
    if(tweets.length>0){
      for(Tweet t in tweets){
        items.add(TweetWidget(tweet: t));
      }
    }
    items.add(SizedBox(height: 50,));
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
                      padding: EdgeInsets.only(top: 88),
                      child: ListView(
                        children: buildListTweet(),
                       )
                    ),
                    Center(
                        child: Text('following', style: TextStyle(color: Colors.black))
                    )
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
                    unselectedLabelColor: Color.fromRGBO(170, 184, 194, 1),
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
