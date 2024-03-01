
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/storage.dart';
import 'package:flutter/material.dart';

class ImageGridView extends StatelessWidget {
  ImageGridView({super.key, required this.imageLinks});

  List<String> imageLinks;
  List<Widget> buildGrid(BuildContext context){
    List<Widget> results = [];
    if(imageLinks.length%2 == 0){
     imageLinks.forEach((element) {
       Future<String> img = Storage().getImageTweetURL(element);
       results.add(buildImageItem(img));
     });
    // }else{
    //   results.add(buildImageItem('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'));
    //   results.add(GridView.count(
    //     primary: false,
    //     physics: NeverScrollableScrollPhysics(),
    //     shrinkWrap: true,
    //     crossAxisSpacing: 6,
    //     mainAxisSpacing: 6,
    //     crossAxisCount: 1,
    //     childAspectRatio: ((MediaQuery.of(context).size.width-64)/2)/97,//((MediaQuery.of(context).size.width-64)/2)/97
    //     children: <Widget>[
    //       Container(
    //         child: Image(
    //           fit: BoxFit.cover,
    //           image: NetworkImage('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'),
    //         ),
    //       ),
    //       Container(
    //         child: Image(
    //           fit: BoxFit.cover,
    //           image: NetworkImage('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'),
    //         ),
    //       ),
    //       // Container(
    //       //   child: Image(
    //       //     fit: BoxFit.cover,
    //       //     image: NetworkImage('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'),
    //       //   ),
    //       // ),
    //       // Container(
    //       //   child: Image(
    //       //     fit: BoxFit.cover,
    //       //     image: NetworkImage('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'),
    //       //   ),
    //       // ),
    //     ],
    //   ));
    }
    return results;
  }

  Widget buildImageItem(Future<String> image){
    return Container(
      child: FutureBuilder<String?>(
          future: image,
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
  }
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      crossAxisCount: 2,
      childAspectRatio: imageLinks.length == 4? ((MediaQuery.of(context).size.width-64)/2)/97 :((MediaQuery.of(context).size.width-64)/2)/200,
      children: buildGrid(context)
    );
  }
}
