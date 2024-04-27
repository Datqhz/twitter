import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/screens/home/home.dart';
import 'package:twitter/screens/home/post_tweet.dart';
import 'package:twitter/screens/messages/message.dart';
import 'package:twitter/screens/notification/notification.dart';
import 'package:twitter/screens/search/search.dart';
import 'package:twitter/shared/drawer.dart';
import '../models/tweet.dart';
import '../services/database_service.dart';
import '../services/storage.dart';
import '../shared/global_variable.dart';
import 'community/community.dart';

class AuthNavigation extends StatefulWidget {
  const AuthNavigation({super.key});

  @override
  State<AuthNavigation> createState() => _AuthNavigationState();
}

class _AuthNavigationState extends State<AuthNavigation> {

  int _currentPage = 0;
  bool isShowBottomBar = true;
  DatabaseService databaseService = DatabaseService();
  bool _isLoad = true;

  Widget _bottomNavigateBar(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GlobalVariable.paddingScreen, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.2
          )
        )
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Column(
              children: [
                Icon(_currentPage == 0? CupertinoIcons.house_fill: CupertinoIcons.house,color: Colors.white),
              ],
            ),
            onTap: (){
              setState(() {
                _currentPage = 0;
              });
            },
          ),
          GestureDetector(
            child: Column(
              children: [
                Icon( _currentPage == 1 ?FontAwesomeIcons.magnifyingGlass : CupertinoIcons.search,color: Colors.white),
              ],
            ),
            onTap: (){
              setState(() {
                _currentPage = 1;
              });
            },
          ),
          GestureDetector(
            child: Column(
              children: [
                Icon( _currentPage == 2 ? CupertinoIcons.person_2_fill: CupertinoIcons.person_2,color: Colors.white ),
              ],
            ),
            onTap: (){
              setState(() {
                _currentPage = 2;
              });
            },
          ),
          GestureDetector(
            child: Column(
              children: [
                Icon(_currentPage == 3? CupertinoIcons.bell_fill :CupertinoIcons.bell,color: Colors.white),
              ],
            ),
            onTap: (){
              setState(() {
                _currentPage = 3;
              });
            },
          ),
          GestureDetector(
            child: Column(
              children: [
                Icon(_currentPage == 4 ?FontAwesomeIcons.solidEnvelope: FontAwesomeIcons.envelope,color: Colors.white),
              ],
            ),
            onTap: (){
              setState(() {
                _currentPage = 4;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _switchPage(){
    switch (_currentPage) {
      case 0:
        return const Home();
      case 1:
        return const SearchPage();
      case 2:
        return Community(callback: setShowBottomBar,);
      case 3:
        return const NotificationPage();
      default:
        return const MessagePage();
    }
  }
  void setShowBottomBar(bool isShow){
    setState((){
      isShowBottomBar = isShow;
    });
  }
  Future<void> getUserInfo()async{
    await databaseService.getUserInfo();
    _isLoad = false;
    setState(() {
    });
  }

  void postTweet(List<XFile> images, Tweet tweet)async{
    List<String> imageNames = [];
    try{
      // upload image to the cloud if have
      if(images.length!=0){
        for(XFile image in images){
          String name = await Storage().putImage(image, 'tweet/images');
          if(name != ""){
            imageNames.add(name);
          }
        }
      }
      tweet.imgLinks = imageNames;
      bool result = await databaseService.postTweet(tweet);
      if(result){
        print("post tweet successful!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: 2.3*MediaQuery.of(context).size.width/4,
            behavior: SnackBarBehavior.floating,
            content: const Text('Your tweet is posted success!!'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }else {
        print("error");
      }
    }catch(e){
      print(e.toString());
    }
  }


  @override
  void initState() {
    getUserInfo();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
      return _isLoad?
        SpinKitPulse(
          size: 50,
          color: Colors.white,
        ): Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              _switchPage(),
              AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  bottom: isShowBottomBar?70:-50,
                  right: 10,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PostTweetScreen(postTweet: postTweet)));
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Icon(FontAwesomeIcons.featherPointed),
                    ),
                  )
              ),
              AnimatedPositioned(
                  bottom: isShowBottomBar?0:-50,
                  right: 0,
                  left: 0,
                  duration: Duration(milliseconds: 200),
                  child: _bottomNavigateBar()
              ),
            ],
          ),
          drawer: MyDrawer(),
        );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
