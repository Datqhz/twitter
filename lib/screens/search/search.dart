import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  Widget trending(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending in Vietnam",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w500
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: const Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white,size: 14,),
              )
            ],
          ),
          const SizedBox(height: 3,),
          const Text(
            "Expansion Pack",
            style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 3,),
          Text(
            "8,845 posts",
            style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24,)
        ],
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80),
              child: ListView.builder(
                itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return trending();
              },
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: MyAppBar(currentPage: 1)
            ),
          ]

      );
  }
}

