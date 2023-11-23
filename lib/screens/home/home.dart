import 'package:flutter/material.dart';
import 'package:twitter/widgets/tweet.dart';

import '../../shared/app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            TabBarView(
                controller: _tabController,
                children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black,
                      padding: EdgeInsets.only(top: 88),
                      child: ListView(
                        children: [
                          Tweet(),
                          // Tweet(),
                          // Tweet(),
                          // Tweet(),
                          SizedBox(height: 50,)
                        ],
                      ),
                    ),
                    Center(
                        child: Text('following', style: TextStyle(color: Colors.black))
                    )
                ]
            ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: MyAppBar(currentPage: 0)
            ),
            Positioned(
                top: 48,
                right: 0,
                left: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(width: 0.14, color: Theme.of(context).dividerColor)
                    )
                  ),
                  child: TabBar(
                    unselectedLabelColor: Color.fromRGBO(170, 184, 194, 1),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    controller: _tabController,
                    tabs: const [
                      Text('For you'),
                      Text('Following')
                    ],
                  ),
                )
            ),
          ]

      );
  }
}
