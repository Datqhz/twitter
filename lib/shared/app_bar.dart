import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:indexed/indexed.dart';

import '../screens/search/search_view.dart';
import 'global_variable.dart';

class MyAppBar extends StatefulWidget{
  MyAppBar({super.key, required this.currentPage});
  int currentPage;

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {


  Widget _buildCoreAppBar() {
    switch (widget.currentPage) {
      case 0:
        return _appBarHome();
      case 1:
        return _appBarSearch("Search X");
      case 2:
        return _appBarCommunities();
      case 3:
        return _appBarNotifications();
      default:
        return _appBarSearch("Seach Direct Messages");
    }
  }

  Widget _appBarHome() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            FontAwesomeIcons.xTwitter,
            size: 26,
            color: Theme.of(context).iconTheme.color,
          ),
        )
      ],
    );
  }

  Widget _appBarSearch(String placeholder) {
    return Container(
      padding: const EdgeInsets.only(left: 48),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if(placeholder == "Search X"){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchView()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(30, 36, 41, 1),
                foregroundColor: const Color.fromRGBO(101, 119, 134, 1),
                minimumSize:
                    Size(3.5 * MediaQuery.of(context).size.width / 5, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Border radius
                ),
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                width: 3.1 * MediaQuery.of(context).size.width / 5,
                child: Text(
                  placeholder,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Icon(
              CupertinoIcons.gear,
              color: Theme.of(context).iconTheme.color,
              size: 24,
            )
          ],
      ),
    );
  }

  Widget _appBarCommunities() {
    return Container(
      padding: const EdgeInsets.only(left: 48),
      height: 48.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Text("Communities",
                    style: Theme.of(context).textTheme.displayLarge)),
            Row(
              children: [
                Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).iconTheme.color,
                  size: 24,
                ),
                const SizedBox(
                  width: 18,
                ),
                Icon(
                  CupertinoIcons.person_add,
                  color: Theme.of(context).iconTheme.color,
                  size: 24,
                ),
              ],
            )
          ],
        ),
    );
  }

  Widget _appBarNotifications() {
    return Container(
      padding: const EdgeInsets.only(left: 48),
      height: 48.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Notifications",
                style: Theme.of(context).textTheme.displayLarge),
            GestureDetector(
              child: Icon(
                CupertinoIcons.gear,
                color: Theme.of(context).iconTheme.color,
                size: 24,
              ),
              onTap: (){

              },
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
          border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.3))),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Indexer(
        children: [
          Indexed(
            index: 1000,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.centerLeft,
                height: 48,
                width: 48,
                child: Container(
                  //alignment: Alignment.centerLeft,
                  height: 24,
                  width: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.network(GlobalVariable.avatar),
                  // child: FutureBuilder<String?>(
                  //   future: GlobalVariable.avatar,
                  //   builder: (context, snapshot){
                  //     if (snapshot.connectionState == ConnectionState.done) {
                  //       if (snapshot.hasError || snapshot.data == null) {
                  //         return Text("Error");
                  //       } else {
                  //         return Image.network(snapshot.data!);
                  //       }
                  //     }
                  //     return SizedBox(height: 1,);
                  //   },
                  // )
                ),
              ),
              onTap: (){Scaffold.of(context).openDrawer();},
            ),
          ),
          _buildCoreAppBar()
        ],
      ),
    );

  }
}
