import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/storage.dart';

class SearchUserAddInCommunity extends StatefulWidget {
  SearchUserAddInCommunity({super.key, required this.userChoosedList});

  ValueNotifier<List<MyUser>> userChoosedList;

  @override
  State<SearchUserAddInCommunity> createState() => _SearchUserAddInCommunityState();
}

class _SearchUserAddInCommunityState extends State<SearchUserAddInCommunity> {

  final TextEditingController _textEditingController = TextEditingController();
  bool isShowX = false; // button clear text
  Timer _debounce = Timer(const Duration(seconds: 2), (){});
  List<MyUser> listUser = [];
  DatabaseService databaseService = DatabaseService();

  void _loadUserContainRegex(String value) {
    if (_debounce.isActive) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(seconds: 2), () async{
      listUser = await databaseService.findUserByUsername(value);
      setState(() {
      });
    });
  }
  List<Widget> buildListUser(){
    List<Widget> result = [];
    for(MyUser user in listUser){
      result.add(
          GestureDetector(
            onTap:_isChoosed(user.uid)? null : (){
              List<MyUser> temp = widget.userChoosedList.value;
              temp.add(user);
              widget.userChoosedList.value = temp;
              setState(() {
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: FutureBuilder<String?>(
                        future: Storage().downloadAvatarURL(user.avatarLink),
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
                        user.displayName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.username,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                            fontSize: 15
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                  const Expanded(child: SizedBox(height: 1,)),
                  if(_isChoosed(user.uid))...[
                    GestureDetector(
                      onTap: (){
                        List<MyUser> temp = widget.userChoosedList.value;
                        temp.remove(user);
                        widget.userChoosedList.value = temp;
                        setState(() {
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.xmark,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          )
      );
    }
    return result;
  }
  List<Widget> buildListUserChoosed(){
    List<Widget> rs = [];
    for(MyUser user in widget.userChoosedList.value){
      rs.add(userBrief(user));
    }
    return rs;
  }
  Widget userBrief(MyUser user){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.only(right: 6, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(6)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 30,
              width: 30,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: FutureBuilder<String?>(
                future: Storage().downloadAvatarURL(user.avatarLink),
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text("Error");
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                        backgroundImage: NetworkImage(snapshot.data!),
                      );
                    }
                  } else {
                    return const Center(
                      child: SpinKitPulse(
                        color: Colors.white,
                        size: 10.0,
                      ),
                    );
                  }
                },
              )
          ),
          const SizedBox(width: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text(
                user.username,
                style: TextStyle(
                    color: Theme.of(context).dividerColor.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                ),
              ),
            ],
          ),
          const SizedBox(width: 8,),
          GestureDetector(
            onTap: (){
              List<MyUser> temp = widget.userChoosedList.value;
              temp.remove(user);
              widget.userChoosedList.value = temp;
              setState(() {
              });
            },
            child: const Icon(
              CupertinoIcons.xmark,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
  
  bool _isChoosed(String uid){
    for(MyUser user in widget.userChoosedList.value){
      if(user.uid == uid){
        return true;
      }
    }
    return false;
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
              title: TextFormField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'ex. @joshua',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),
                  focusedBorder: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  decorationThickness: 0,
                ),
                onChanged: (value){
                  _loadUserContainRegex(value);
                },
              ),
              actions: [
                IconButton(
                    onPressed: isShowX?(){
                      _textEditingController.clear();
                      isShowX = false;
                      setState(() {

                      });
                    }:null,
                    color: isShowX? Colors.white: Colors.transparent,
                    icon: const Icon(CupertinoIcons.multiply)
                )
              ],
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Stack(
              children: [
                ListView(
                  children: buildListUser(),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Choosed",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(widget.userChoosedList.value.length < 2){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        width: 300,
                                        behavior: SnackBarBehavior.floating,
                                        content: const Text('You need choose at least 2 people to create a community.', textAlign: TextAlign.center,),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14)
                                        ),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                  else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6,),
                          Wrap(
                            children: buildListUserChoosed(),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
}
