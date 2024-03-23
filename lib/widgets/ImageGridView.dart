
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/storage.dart';
import 'package:flutter/material.dart';

class ImageGridView extends StatelessWidget {
  ImageGridView({super.key, required this.imageLinks, required this.isSquare});

  late bool isSquare;

  List<String> imageLinks;
  Widget buildGrid(BuildContext context){
    double ratio4 = ((MediaQuery.of(context).size.width-64)/2)/97;
    double ratiolr = ((MediaQuery.of(context).size.width-64)/2)/200;
    if(isSquare){
      ratio4 = 1;
      ratiolr = 1;
    }else {
      ratio4 = ((MediaQuery.of(context).size.width-64)/2)/97;
      ratiolr = ((MediaQuery.of(context).size.width-64)/2)/200;
    }
    List<Widget> results = [];
    if(imageLinks.length== 1){
      return Container(
        width: double.infinity,
        child: FutureBuilder<String?>(
          future: Storage().getImageTweetURL(imageLinks[0]),
          builder: (context,snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError || snapshot.data == null) {
                return Text("Error");
              } else {
                return Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(snapshot.data!),
                );
              }
            } else {
              return Center(
                child: SpinKitPulse(
                  color: Colors.blue,
                  size: 25.0,
                ),
              );
            }
          },
        ),
      );
    }else {
      if(imageLinks.length%2 == 0) { // use it for num of images 2 and 4
        imageLinks.forEach((element) {
          results.add(buildImageItem(Storage().getImageTweetURL(element)));
        });
      }
      else if (imageLinks.length %2 != 0){ // in case num of images equal 3
        results.add(buildImageItem(Storage().getImageTweetURL(imageLinks[0])));
        List<Widget>temp = [];
        for (int j = 1; j < imageLinks.length; j++) {
          temp.add(buildImageItem(Storage().getImageTweetURL(imageLinks[j])));
        }
        results.add(GridView.count(
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            crossAxisCount: 1,
            childAspectRatio: ratio4,//((MediaQuery.of(context).size.width-64)/2)/97
            children: temp
        ));
      }
      return GridView.count(
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          crossAxisCount: 2,
          childAspectRatio: imageLinks.length == 4? ratio4 :ratiolr,
          children: results
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return buildGrid(context);
  }
}


Widget buildImageItem(Future<String> image){
  return Container(
    child: FutureBuilder<String?>(
      future: image,
      builder: (context,snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return const Text("Error");
          } else {
            return Image(
              fit: BoxFit.cover,
              image: NetworkImage(snapshot.data!),
            );
          }
        } else {
          return const Center(
            child: SpinKitPulse(
              color: Colors.blue,
              size: 25.0,
            ),
          );
        }
      },
    ),
  );
}