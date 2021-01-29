import 'package:flutter/material.dart';
import 'package:sqlite/screens/today_screen.dart';
import 'package:sqlite/screens/monthly_screen.dart';
import 'package:sqlite/screens/weekly_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Work List',
            style: TextStyle(fontSize: 30),
          ),
          elevation: 0.7,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'TODAY',
              ),
              Tab(
                text: 'WEEKLY',
              ),
              Tab(
                text: 'MONTHLY',
              ),
            ],
          ),
          actions: <Widget>[
            Icon(Icons.search),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
            ),
            Icon(Icons.more_vert)
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            TodayScreen(),
            WeeklyScreen(),
            MonthlyScreen(),
          ],
        ),
      ),
    );
  }
}
