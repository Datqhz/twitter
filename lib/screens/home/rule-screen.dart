import 'package:flutter/material.dart';

class CommunityRulesScreen extends StatelessWidget {
  CommunityRulesScreen({super.key, required this.ruleNameList, required this.ruleDesList});

  List<String> ruleNameList;
  List<String> ruleDesList;

  List<Widget> buildListRule(){
    List<Widget> rs = [];
    for(int index = 0; index < ruleNameList.length; index++){
      rs.add(ruleItem(index, ruleNameList[index], ruleDesList[index]));
      rs.add(SizedBox(height: 16,));
    }
    return rs;
  }

  Widget ruleItem(int idx, String ruleName, String ruleDes){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width:30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(17)
          ),
          child: Text((idx+1).toString(), style: TextStyle(
              color: Colors.white
          ),),
        ),
        SizedBox(width: 16,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               ruleName,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color:Colors.white.withOpacity(0.9)
                ),
                softWrap: true,
              ),
              Text(
                ruleDes,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color:Colors.white.withOpacity(0.7)
                ),
                softWrap: true,
              ),
            ],
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
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
            title: Text(
              "Community Rules",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            //content
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 50),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Community rules are enforced by community leaders, and are in addition to our Rules",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16,),
                    ...buildListRule()
                  ],
                ),
              ),
            ),
            //bottom bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.4),
                      width: 0.15
                    )
                  )
                ),
                child: TextButton(
                  child: Text(
                    "Got it",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}
