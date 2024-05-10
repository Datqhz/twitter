
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/screens/bookmark_screen.dart';
import 'package:twitter/screens/profile/profile.dart';
import 'package:twitter/services/auth_firebase.dart';

import '../screens/profile/follow_view.dart';
import '../services/storage.dart';
import 'global_variable.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Widget accountItem(MyUser user){
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 40,
          width: 40,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: FutureBuilder(
            future: Storage().downloadAvatarURL(user.avatarLink),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                return Image.network(snapshot.data!);
              }else{
                return Image.asset("assets/images/black.jpg");
              }
            },
          )
        ),
        Column(
          children: [
            Text(
              GlobalVariable.currentUser!.myUser.displayName,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white
              ),
            ),
            const SizedBox(height: 6,),
            Text(
              GlobalVariable.currentUser!.myUser.username,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Color.fromRGBO(170, 184, 194, 1)
              ),
            ),
          ],
        )
      ],
    );
  }

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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(uid: GlobalVariable.currentUser!.myUser.uid,)));
                      },
                    ),
                    GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 220,
                                color: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.minus,
                                          color: Colors.white.withOpacity(0.8),
                                          size: 40,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      "Accounts",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 15,),
                                    accountItem(GlobalVariable.currentUser!.myUser),
                                    const SizedBox(height: 18,),
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          AuthFirebaseService().signOut();
                                        },
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 46),
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          side: const BorderSide(
                                            color: Colors.white,
                                            width: 1
                                          )
                                        )
                                      ),
                                        child: const Text(
                                          "Sign out",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.red
                                          ),
                                        ),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 1)
                          ),
                          child: const Icon(FontAwesomeIcons.ellipsisVertical, size: 14,)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Text(
                  GlobalVariable.currentUser!.myUser.displayName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 6,),
                Text(
                  GlobalVariable.currentUser!.myUser.username,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color.fromRGBO(170, 184, 194, 1)
                  ),
                ),
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FollowView(uid: GlobalVariable.currentUser!.myUser.uid, isFollowing: true)));
                      },
                      child: Row(
                        children: [
                          Text(
                            GlobalVariable.numOfFollowing.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          const Text(
                            ' Following',
                            style: TextStyle(
                                color: Color.fromRGBO(170, 184, 194, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FollowView(uid: GlobalVariable.currentUser!.myUser.uid, isFollowing: false)));

                      },
                      child: Row(
                        children: [
                          Text(
                            GlobalVariable.numOfFollowed.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          const Text(
                            ' Followers',
                            style: TextStyle(
                                color: Color.fromRGBO(170, 184, 194, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w400
                            ),
                          )
                        ],
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(uid: GlobalVariable.currentUser!.myUser.uid)));

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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const BookmarkScreen()));
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
