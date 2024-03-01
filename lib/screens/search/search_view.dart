import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  TextEditingController _textEditingController = TextEditingController();
  bool isShowX = false;
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
                color: Colors.blue,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                decoration: TextDecoration.none,
                decorationThickness: 0,
              ),
              onChanged: (value){
                if(value.isNotEmpty){
                  isShowX = true;
                }else {
                  isShowX = false;
                }
                setState(() {
                });
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
                  icon: Icon(CupertinoIcons.multiply)
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: ListView.builder(
            itemCount: 6,
            itemBuilder: (BuildContext context, int index){
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/patty.png"),
                        backgroundColor: Colors.black ,
                        radius: 20,
                      ),
                    ),
                    SizedBox(width: 8,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sawyer Fredericks",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "@SawyerFrdrx",
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
              );
            }
        ),
      )
    );
  }
}
