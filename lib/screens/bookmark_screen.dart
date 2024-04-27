import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/bookmark.dart';
import 'package:twitter/shared/loading.dart';

import '../services/database_service.dart';
import '../widgets/tweet_widget.dart';


class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {

  List<Bookmark> bookmarkTweets = [];
  bool _isLoad = true;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Bookmark> data = await DatabaseService().getBookmarkTweet();
      setState(() {
        bookmarkTweets = data;
        _isLoad = false;
      });
    } catch (e) {
      print(e);
    }
  }
  List<Widget> buildListTweet(){
    List<Widget> items = [];
    if(bookmarkTweets.length>0){
      for(Bookmark t in bookmarkTweets){
        items.add(TweetWidget(tweet: t.tweet));
      }
    }
    items.add(SizedBox(height: 50,));
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.35,
                      color: Theme.of(context).dividerColor
                  )
              )
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Bookmarks",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              ),
            ),
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white, size: 18,),
                color: Colors.black,
                onSelected: (value) async{
                  await DatabaseService().removeAllBookmark();
                  bookmarkTweets.clear();
                  setState(() {
                  });
                },
                itemBuilder: (BuildContext context) {
                  return {'Clear all Bookmarks'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
      ),
      body: _isLoad? Loading():Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: bookmarkTweets.isEmpty ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Save posts for later",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "Bookmark posts to easily find them again in the future.",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w300
                  ),
                ),
              ],
            )
        ) : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: buildListTweet(),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}
