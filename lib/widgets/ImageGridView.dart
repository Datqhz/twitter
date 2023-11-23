import 'package:flutter/material.dart';

class ImageGridView extends StatelessWidget {
  ImageGridView({super.key, required this.numberImage});

  int numberImage;
  List<Widget> buildGrid(BuildContext context){
    List<Widget> results = [];
    if(numberImage%2 == 0){
      results.add(buildImageItem('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'));
      results.add(buildImageItem('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'));
    }else{
      results.add(buildImageItem('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'));
      results.add(GridView.count(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        crossAxisCount: 1,
        childAspectRatio: ((MediaQuery.of(context).size.width-64)/2)/97,//((MediaQuery.of(context).size.width-64)/2)/97
        children: <Widget>[
          Container(
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'),
            ),
          ),
          Container(
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'),
            ),
          ),
          // Container(
          //   child: Image(
          //     fit: BoxFit.cover,
          //     image: NetworkImage('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'),
          //   ),
          // ),
          // Container(
          //   child: Image(
          //     fit: BoxFit.cover,
          //     image: NetworkImage('https://www.ville.quebec.qc.ca/citoyens/environnement/milieux-naturels/img/ph-milieux-naturel-bpa-beauport.jpg'),
          //   ),
          // ),
        ],
      ));
    }
    return results;
  }

  Widget buildImageItem(String path){
    return Container(
      child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(path),
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
      childAspectRatio: numberImage == 4? ((MediaQuery.of(context).size.width-64)/2)/97 :((MediaQuery.of(context).size.width-64)/2)/200,
      children: buildGrid(context)
    );
  }
}
