import 'package:flutter/material.dart';
import 'package:todolist/viewmodels/list/list.dart';
import 'package:todolist/views/common/flip_clock.dart';
import 'package:todolist/views/todolist/pool.dart';
import 'package:todolist/views/todolist/today.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePageView();
  }
}

class _HomePageView extends State<HomePageView> with TickerProviderStateMixin {
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
      drawer: Drawer(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                child: SafeArea(
                  child: Container(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: Icon(
                  Icons.view_headline,
                  color: Colors.white,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                        return FlipClockView(
                          bengin: (DateTime.now().hour * 3600 + DateTime.now().minute * 60 + DateTime.now().second).floor(),
                          duration: 60 * 60 * 24,
                          title: '',
                          decline: false,
                        );
                      },
                    ),
                  );
                },
                title: Text('flip clock'),
              ),
              Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
              ListTile(
                title: Text('version: 1.0.0'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withAlpha(200),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          indicatorColor: Colors.transparent,
          controller: _tabController,
          tabs: tabs.map((tabTitle) {
            return Tab(text: tabTitle);
          }).toList(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.perm_identity),
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
