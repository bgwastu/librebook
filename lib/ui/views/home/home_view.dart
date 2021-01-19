import 'package:flutter/material.dart';
import 'package:librebook/app_localizations.dart';
import 'package:librebook/ui/shared/theme.dart';
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
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
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
                  floating: true,
                  elevation: 2,
                  snap: true,
                  forceElevated: true,
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: MD2Indicator(
                      indicatorHeight: 3,
                      indicatorColor: secondaryColor,
                      indicatorSize: MD2IndicatorSize.full,
                    ),
                    unselectedLabelColor: Colors.grey[600],
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
                    tabs: [
                      Tab(text: AppLocalizations.of(context).translate("downloads")),
                      Tab(text: AppLocalizations.of(context).translate("settings")),
                    ],
                  ),
                  title: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      elevation: 5,
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
                                    onPressed: () => scaffoldKey.currentState.openDrawer(),
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
                      )),
                ),
                SliverFillRemaining(
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.right,
                    color: Colors.grey[300],
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        DownloadView(),
                        SettingView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
