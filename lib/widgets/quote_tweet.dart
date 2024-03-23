import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twitter/widgets/ImageGridView.dart';

import '../models/tweet.dart';
import '../services/storage.dart';

class QuoteTweet extends StatelessWidget {
  QuoteTweet({super.key, this.quote, required this.brief});
  late Tweet? quote;
  late bool brief;

  List<Widget> buildCore(){
    if(brief){
      return [
        SizedBox(height: 12,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: 100,
                 width: 100,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: ImageGridView(imageLinks: quote!.imgLinks, isSquare: true)
      ),
              if(quote!.content.isNotEmpty)...[
                SizedBox(height: 4,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    quote!.content,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis
                    ),
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 4,),
              ],
            ],
          ),
        ),
        SizedBox(height: 10,),
      ];
    }else {
      return [
        if(quote!.content.isNotEmpty)...[
          SizedBox(height: 4,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              quote!.content,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis
              ),
              maxLines: 5,
            ),
          ),
          SizedBox(height: 4,),
        ],
        Container(
          clipBehavior: Clip.antiAlias,
          constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: 300,
          ),
          decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
          ),
          child: ImageGridView(imageLinks: quote!.imgLinks, isSquare: false)
        )];
    }
  }

  String caculateUploadDate(DateTime date){
    DateTime currentDate = DateTime.now();
    // Calculate the absolute difference
    Duration difference = currentDate.difference(date).abs();
    if (difference.inDays > 0 ) {
      if(difference.inDays>365){
        return DateFormat.yMMMMd("en_US").parse(date.toString()).toString();
      }else {
        return DateFormat.MMMMd("en_US").format(date).toString();
      }
    }else {
      return "${difference.inHours}h";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.5, color: Colors.white.withOpacity(0.2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Container(
                  height: 20,
                  child: FutureBuilder<String?>(
                      future: Storage().downloadAvatarURL(quote!.user!.avatarLink),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done){
                          return CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data!),
                            backgroundColor: Colors.black ,
                            radius: 10,
                          );
                        }else {
                          return SizedBox(height: 0,);
                        }
                      }
                  ),
                ),
                SizedBox(width: 4,),
                Text(
                  quote!.user!.displayName,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis
                  ),
                ),
                SizedBox(width: 4,),
                Text(
                  quote!.user!.username,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.5),
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                SizedBox(width: 4,),
                Icon(
                  FontAwesomeIcons.solidCircle,
                  size: 2.5,
                  color: Colors.white.withOpacity(0.5),
                ),
                SizedBox(width: 4,),
                Text(
                  caculateUploadDate(quote!.uploadDate),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.5)
                  ),
                ),
              ],
            ),
          ),
          if(quote!.replyTo!=null)...[Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Replying to ${quote!.replyTo?.username}",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w400
              ),
            ),
          ),],
          ...buildCore()
        ],
      ),
    );
  }
}
