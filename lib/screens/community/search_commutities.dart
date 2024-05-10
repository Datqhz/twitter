import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twitter/screens/community/community_item.dart';

import '../../models/group.dart';
import '../../services/database_service.dart';

class SearchCommutitiesScreen extends StatefulWidget {
  const SearchCommutitiesScreen({super.key});

  @override
  State<SearchCommutitiesScreen> createState() => _SearchCommutitiesScreenState();
}

class _SearchCommutitiesScreenState extends State<SearchCommutitiesScreen> {

  final TextEditingController _textEditingController = TextEditingController();
  bool isShowX = false; // button clear text
  Timer _debounce = Timer(const Duration(seconds: 2), (){});
  late Future<List<Group>> futureGroups;
  DatabaseService databaseService = DatabaseService();


  @override
  void initState() {
    futureGroups = databaseService.getAllGroup();
    super.initState();
  }

  void _loadGroupContainRegex(String value) {
    if (_debounce.isActive) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(seconds: 2), () {
      print("my search: $value");
      if(value.isNotEmpty){
        futureGroups = databaseService.getAllGroupContainS(value);
      }else {
        futureGroups = databaseService.getAllGroup();
        print("search all ");
      }
      setState(() {
      });
    });
  }

  List<Widget> buildGroupItem(List<Group> groups){
    List<Widget> rs = [];
    for (var element in groups) {
      rs.add(CommunitiesItem(group: element));
    }
    rs.add(Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.4
              )
          )
      ),
      child: const Icon(CupertinoIcons.circle_fill, size: 5,),
    ));
    rs.add(const SizedBox(height: 20));
    return rs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(width: 0.1, color: Colors.white.withOpacity(0.5))
        ),
        title: TextFormField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Search for a Community',
            hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
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
            isShowX = true;
            _loadGroupContainRegex(value);
          },
        ),
        actions: [
          IconButton(
              onPressed: isShowX?(){
                _textEditingController.clear();
                isShowX = false;
                _loadGroupContainRegex("");
              }:null,
              color: isShowX? Colors.white: Colors.transparent,
              icon: const Icon(CupertinoIcons.multiply)
          )
        ],
      ),
      body:FutureBuilder(
        future: futureGroups,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done &&snapshot.hasData){
            return ListView(children: buildGroupItem(snapshot.data!));
          }else {
            return const Center(child: SpinKitPulse(color: Colors.blue,));
          }
        },
        ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
