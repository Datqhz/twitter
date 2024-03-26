import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/screens/profile/profile.dart';
import 'package:twitter/services/auth_firebase.dart';

import 'global_variable.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            padding: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.46,
                  color: Theme.of(context).dividerColor
                )
              ),
              color: Colors.black,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 40,
                        width: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                          child: Image.network(GlobalVariable.avatar),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                      },
                    ),
                    GestureDetector(
                      child: const Icon(FontAwesomeIcons.ellipsisVertical, size: 14,),
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Text(
                  GlobalVariable.currentUser!.myUser.displayName,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 6,),
                Text(
                  GlobalVariable.currentUser!.myUser.username,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color.fromRGBO(170, 184, 194, 1)
                  ),
                ),
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      GlobalVariable.numOfFollowing.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      ' Following',
                      style: TextStyle(
                          color: Color.fromRGBO(170, 184, 194, 1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(width: 6,),
                    Text(
                      GlobalVariable.numOfFollowed.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      ' Followers',
                      style: TextStyle(
                          color: Color.fromRGBO(170, 184, 194, 1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ListTile(
              leading: const Icon(CupertinoIcons.person, color: Colors.white, weight: 600,size: 26,),
              title: const Text(
                'Profile',
                style:TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              minLeadingWidth: 24,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.xTwitter, color: Colors.white, weight: 600,size: 26,),
              title: const Text(
                'Premium',
                style:TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              minLeadingWidth: 24,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListTile(
              leading: const Icon(CupertinoIcons.bookmark, color: Colors.white, weight: 600,size: 26,),
              title: const Text(
                'Bookmarks',
                style:TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              minLeadingWidth: 24,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListTile(
              leading: const Icon(CupertinoIcons.square_list, color: Colors.white, weight: 600,size: 26,),
              title: const Text(
                'Lists',
                style:TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              minLeadingWidth: 24,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListTile(
              leading: const Icon(CupertinoIcons.waveform, color: Colors.white, weight: 600,size: 26,),
              title: const Text(
                'Spaces',
                style:TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              minLeadingWidth: 24,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.moneyBill1, color: Colors.white, weight: 600,size: 26,),
              title: const Text(
                'Monetization',
                style:TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              minLeadingWidth: 24,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.moneyBill1, color: Colors.white, weight: 600,size: 26,),
              title: const Text(
                'Log out',
                style:TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              minLeadingWidth: 24,
              onTap: () {
                Navigator.pop(context);
                AuthFirebaseService().signOut();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
            child: Divider(
              height: 0.5,
              color: Theme.of(context).dividerColor,
            ),
          ),
          SizedBox(
            height: 45,
            child: ListTile(
              trailing: const Icon(CupertinoIcons.chevron_down, color: Colors.white, size: 20,),
              title: const Text(
                'Professional Tools',
                style:TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 45,
            child: ListTile(
              trailing: const Icon(CupertinoIcons.chevron_down, color: Colors.white, size: 20,),
              title: const Text(
                'Settings & Support',
                style:TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white
                ) ,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
