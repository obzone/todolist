import 'package:flutter/material.dart';
import 'package:todolist/viewmodels/list/list.dart';
import 'package:todolist/views/todolist/pool.dart';
import 'package:todolist/views/todolist/today.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePageView();
  }
}

class _HomePageView extends State<HomePageView> with SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller
  List tabs = ["today list", "todo pool"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withAlpha(200),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          indicatorColor: Colors.transparent,
          controller: _tabController,
          tabs: tabs.map((tabTitle) => Tab(text: tabTitle)).toList(),
        ),
        leading: IconButton(
          icon: Icon(Icons.perm_identity),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TodayListView(viewModel: TodoListViewModel.getInstance()),
          TodoPoolView(viewModel: TodoListViewModel.getInstance()),
        ],
      ),
    );
  }
}
