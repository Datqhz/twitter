

import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';

import '../../models/group.dart';
import '../../services/storage.dart';
import 'group_profile.dart';

class CommunitiesItem extends StatelessWidget {
  CommunitiesItem({super.key, required this.group});
  Group group;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> GroupScreen(group: group)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                width: 90,
                child: FutureBuilder<String?>(
                  future: Storage().downloadGroupULR(group.groupImg), // Replace with your function to load the image
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: NetworkImage(snapshot.data!),
                          fit: BoxFit.cover,
                        ),
                      );
                    }else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/images/black.jpg", // Replace with your placeholder image
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.groupName,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 15
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          group.groupMembers.length.toString() + " Members",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 140,
                      child: AvatarStack(
                        borderColor: Colors.black,
                        height: 36,
                        width: 36,
                        avatars: [
                          for (var n = 0; n < 5; n++)
                            AssetImage('assets/images/wall.jpg'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
