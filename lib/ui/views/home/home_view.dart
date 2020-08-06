import 'package:flutter/material.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/home/home_viewmodel.dart';
import 'package:librebook/ui/views/search/book_search.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          key: scaffoldKey,
          drawer: Drawer(),
          body: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.grey[300],
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    pinned: true,
                    elevation: 2,
                    snap: true,
                    forceElevated: true,
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorWeight: 3,
                      unselectedLabelColor: Colors.grey[600],
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
                      tabs: [
                        Tab(text: "My library"),
                        Tab(text: "Downloads"),
                      ],
                    ),
                    title: Hero(
                      tag: 'search',
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              // TODO: Implement search
                              showSearch(
                                  context: context, delegate: BookSearch());
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.menu),
                                        onPressed: () => scaffoldKey
                                            .currentState
                                            .openDrawer(),
                                      ),
                                      horizontalSpaceTiny,
                                      Text(
                                        'Search for book',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    floating: true,
                  ),
                  SliverFillRemaining(
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.right,
                      color: Colors.grey[300],
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          Center(child: Text('My library')),
                          Center(child: Text('Download')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
