import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/app_localizations.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/home/download_view.dart';
import 'package:librebook/ui/views/home/settings_view.dart';
import 'package:librebook/ui/views/search/book_search.dart';
import 'package:librebook/ui/widgets/custom_search_widget.dart' as customSearch;
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

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
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                        automaticallyImplyLeading: false,
                        pinned: true,
                        floating: true,
                        elevation: 1,
                        snap: true,
                        forceElevated: true,
                        toolbarHeight: 60,
                        bottom: TabBar(
                          controller: _tabController,
                          indicatorWeight: 3,
                          indicatorSize: TabBarIndicatorSize.label,
                          
                          indicator: MD2Indicator(
                            indicatorHeight: 3,
                            indicatorColor: Theme.of(context).accentColor,
                            indicatorSize: MD2IndicatorSize.full,
                          ),
                          unselectedLabelColor: Colors.grey[600],
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 16),
                          tabs: [
                            Tab(text: AppLocalizations.of(context).translate("downloads")),
                            Tab(text: AppLocalizations.of(context).translate("settings")),
                          ],
                        ),
                        title: _searchBox()),
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                DownloadView(),
                SettingView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            customSearch.showSearch(context: context, delegate: BookSearch());
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: null,
                    ),
                    horizontalSpaceTiny,
                    Text(
                      AppLocalizations.of(context).translate('search-book'),
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
        ));
  }
}
