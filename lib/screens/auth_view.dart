import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/screens/home/home.dart';
import 'package:twitter/screens/messages/message.dart';
import 'package:twitter/screens/notification/notification.dart';
import 'package:twitter/screens/search/search.dart';
import 'package:twitter/shared/drawer.dart';
import '../shared/global_variable.dart';
import 'community/community.dart';

class AuthNavigation extends StatefulWidget {
  const AuthNavigation({super.key});

  @override
  State<AuthNavigation> createState() => _AuthNavigationState();
}

class _AuthNavigationState extends State<AuthNavigation> {

  int _currentPage = 0;


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
        return const Community();
      case 3:
        return const NotificationPage();
      default:
        return const MessagePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _switchPage(),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: _bottomNavigateBar()
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
