import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Follow extends StatefulWidget {
  Follow({super.key});

  @override
  State<Follow> createState() => _FollowState();
}

class _FollowState extends State<Follow> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  late ScrollController _scrollController;
  double top = 0;
  double previousScroll = 0;
  bool isShow = true;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() {
      if(previousScroll>_scrollController.offset){
        top = top - (_scrollController.offset - previousScroll);
        if(top >= -20){
          top = -0;
          isShow = true;
        }
      }else {
        top = top + (previousScroll - _scrollController.offset);
        if(top< -20){
          top = -40;
          isShow = false;
        }
      }
      previousScroll = _scrollController.offset;
      setState(() {
      });
      print("scroll" + _scrollController.offset.toString());
    });
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(() {setState(() {
    });});

    super.initState();
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
            elevation: 0,
            title:Text(
              "Following"
            ),
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: Icon(CupertinoIcons.person_add)
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top:40 +top),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('Content for Tab 1'),
                _buildTabContent('Content for Tab 2'),
              ],
            ),
          ),
          // SingleChildScrollView(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Flexible(
          //         flex: 1,
          //           child: _getTabView(_tabController.index)
          //       )
          //     ],
          //   ),
          // ),
          // TabBarView(
          //     controller: _tabController,
          //     physics: BouncingScrollPhysics(),
          //     children: [
          //       Center(
          //           child: Text('Replies', style: TextStyle(color: Colors.white))
          //       ),
          //       Center(
          //           child: Text('Highlights', style: TextStyle(color: Colors.white))
          //       ),
          //     ]
          // ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
              left: 0,
              top: top,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color:Colors.black,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.1
                    )
                  )
                ),
                child: TabBar(
                  unselectedLabelColor: Color.fromRGBO(170, 184, 194, 1),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  isScrollable: false,
                  controller: _tabController,
                  tabs: const [
                    Text('Verified'),
                    Text('All')
                  ],
                ),
              ),
          )
        ]

      )
    );
  }
  Widget _buildTabContent(String text) {
    return ListView.builder(
      controller: _scrollController,
      key: PageStorageKey<String>(text),
      itemCount: 50,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('$text - Item $index', style: TextStyle(color: Colors.white),),
        );
      },
    );
  }
}
