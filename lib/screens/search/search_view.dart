import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/screens/profile/profile.dart';
import 'package:twitter/services/database_service.dart';

import '../../models/user.dart';
import '../../services/storage.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

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
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(uid: user.uid)));
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
                  )
                ],
              ),
            ),
          )
      );
    }
    return result;
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
                hintText: 'Search X',
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
        child: ListView(
          children: buildListUser(),
        )
      )
    );
  }
}
