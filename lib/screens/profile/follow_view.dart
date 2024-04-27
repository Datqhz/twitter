import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twitter/services/database_service.dart';
import 'package:twitter/shared/global_variable.dart';

import '../../models/follow.dart';
import '../../services/storage.dart';

class FollowView extends StatefulWidget {
  FollowView({super.key, required this.uid, required this.isFollowing});
  String uid;
  bool isFollowing;
  @override
  State<FollowView> createState() => _FollowViewState();
}

class _FollowViewState extends State<FollowView> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
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
            elevation: 0,
            title:Text(
              widget.isFollowing?"Following":"Followers"
            ),
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: Icon(CupertinoIcons.person_add)
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: widget.isFollowing?DatabaseService().getFollowing(widget.uid):DatabaseService().getFollowers(widget.uid),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              return ListView(
                children: _buildFollowList(snapshot.data!),
              );
            }else {
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isFollowing?"Be in the know":"Looking for followers?",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 28
                        ),
                      ),
                      Text(
                        widget.isFollowing
                            ?"Following accounts is an easy way to curate your timeline and know what's happening with the topics and people you're interested in."
                            :"When someone follows this account, they'll show up here. posting and interaction with others helps boots followers",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 15
                        ),
                      ),
                    ],
                  ),
                )
              );
            }
          }else{
            return Center(child: SpinKitPulse(size: 50, color: Colors.blue,));
          }
        },
      )
    );
  }
  List<Widget> _buildFollowList(List<Follow> follows) {
    List<Widget> rs = [];
    follows.forEach((element) {
      rs.add(FollowItem(follow: element, followers: !widget.isFollowing));
    });
    return rs;
  }
}

class FollowItem extends StatelessWidget {
  FollowItem({super.key, required this.follow, required this.followers});
  Follow follow;
  bool followers;
  late ValueNotifier<bool> _isFollow = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    if(followers){
      _isFollow.value = follow.userFollow.isFollow;
    }else {
      _isFollow.value = follow.userFollowed.isFollow;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            width: 0.2,
            color: Colors.white.withOpacity(0.5)
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                child: FutureBuilder<String?>(
                    future: Storage().downloadAvatarURL(!followers?follow.userFollowed.myUser.avatarLink:follow.userFollow.myUser.avatarLink),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        return CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!),
                          backgroundColor: Colors.black ,
                          radius: 20,
                        );
                      }else {
                        return SizedBox(height: 0,);
                      }
                    }
                ),
              ),
              SizedBox(width: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    !followers?follow.userFollowed.myUser.displayName:follow.userFollow.myUser.displayName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    !followers?follow.userFollowed.myUser.username:follow.userFollow.myUser.username,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                        fontSize: 15
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: _isFollow,
              builder: (context, value, child){
                return SizedBox(
                  height: 30,
                  child: TextButton(
                    onPressed: ()async{
                      if(_isFollow.value){
                        await DatabaseService().unfollowUid(!followers?follow.userFollowed.myUser.uid:follow.userFollow.myUser.uid);
                      }else {
                        await DatabaseService().followUid(!followers?follow.userFollowed.myUser.uid:follow.userFollow.myUser.uid);
                      }
                      await DatabaseService().getUserInfo();
                      _isFollow.value = !_isFollow.value;
                    },
                    child: Text(
                        value?"Following":"Follow"
                    ),
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        backgroundColor: value?Colors.black:Colors.white,
                        foregroundColor: value?Colors.white:Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              width: 0.8,
                              color: Theme.of(context).dividerColor
                            )
                        )
                    ),
                  ),
                );
              }
          )

        ],
      ),
    );
  }
}
