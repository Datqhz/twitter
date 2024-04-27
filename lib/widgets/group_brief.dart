import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/group.dart';
import '../services/storage.dart';

class BriefGroup extends StatelessWidget {
  BriefGroup({super.key, required this.img, required this.title, required this.subTitle, required this.isActive});

  String img;
  String title;
  String subTitle;
  bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: img.isEmpty?Icon(FontAwesomeIcons.earth, color: Colors.white, size: 16,):FutureBuilder<String?>(
                    future: Storage(). downloadGroupURL(img), // Replace with your function to load the image
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            height: 60,
                            width: 60,
                            image: NetworkImage(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        );
                      }else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            height: 60,
                            width: 60,
                            image: AssetImage("assets/images/black.jpg"),
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Visibility(
                    visible: isActive ,
                    child: Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: CupertinoColors.systemGreen,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1.5,
                                color: Colors.black
                            )
                        ),
                        child: Icon(FontAwesomeIcons.check, color: Colors.black,size: 10,),
                      ),
                    )
                )
              ],
            ),
            SizedBox(width: 12,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                    ),
                  ),
                  if(subTitle.isNotEmpty)...[
                    SizedBox(height: 4,),
                    Text(
                      subTitle + " Members",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                          fontSize: 14
                      ),
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
