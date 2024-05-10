import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twitter/models/user_info_with_follow.dart';

import '../../services/database_service.dart';
import '../../services/storage.dart';

class Members extends StatefulWidget {
  Members({super.key, required this.groupId});
  String groupId;

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  @override

  List<Widget> _buildFollowList(List<MyUserWithFollow> members) {
    List<Widget> rs = [];
    for (var element in members) {
      rs.add(MemberItem(user: element,));
    }
    return rs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
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
              title:const Text(
                  "Members"
              ),
              actions: [
                IconButton(
                    onPressed: (){},
                    icon: const Icon(CupertinoIcons.person_add)
                )
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: DatabaseService().getMembersOfGroup(widget.groupId),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                print("member: ${snapshot.data!.length}");
                return ListView(
                  children: _buildFollowList(snapshot.data!),
                );
              }else {
                return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "This group hasn't any member.",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 28
                            ),
                          ),
                        ],
                      ),
                    )
                );
              }
            }else{
              return const Center(child: SpinKitPulse(size: 50, color: Colors.blue,));
            }
          },
        )
    );
  }
}

class MemberItem extends StatefulWidget {
  MemberItem({super.key, required this.user});
  MyUserWithFollow user;
  @override
  State<MemberItem> createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> {
  late final ValueNotifier<bool> _isFollow = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    if(widget.user.isFollow){
      _isFollow.value = true;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
              SizedBox(
                height: 40,
                child: FutureBuilder<String?>(
                    future: Storage().downloadAvatarURL(widget.user.myUser.avatarLink),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        return CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!),
                          backgroundColor: Colors.black ,
                          radius: 20,
                        );
                      }else {
                        return const SizedBox(height: 0,);
                      }
                    }
                ),
              ),
              const SizedBox(width: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.myUser.displayName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.user.myUser.username,
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
                        await DatabaseService().unfollowUid(widget.user.myUser.uid);
                      }else {
                        await DatabaseService().followUid(widget.user.myUser.uid);
                      }
                      await DatabaseService().getUserInfo();
                      _isFollow.value = !_isFollow.value;
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
                    child: Text(
                        value?"Following":"Follow"
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

