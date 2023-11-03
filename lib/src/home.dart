import 'package:flutter/material.dart';
import 'package:test_rm_api/src/helper/size_config.dart';

import 'views/all_chars_list.dart';
import 'views/all_eps_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final _tabs = [
  'PERSONAGENS',
  'EPISÓDIOS',
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5CAD4A),
          title: Padding(
            padding: EdgeInsets.only(top: 10),
            child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(child: Image.asset('assets/images/logo.png', height: heightPercent(15),)),
                  SizedBox(child: Image.asset('assets/images/portal.png', height: heightPercent(15),)),
                ],
              )
            ,
          ),
          bottom: TabBar(
            indicatorColor: Color(0xFFF0F2EB),
            isScrollable: true,
            tabs: [for (final tab in _tabs) Tab(child: Text(tab))],
          ),
        ),
        body: TabBarView(
          children: [
            CharacterListView(),
            EpisodeListView(),
          ],
        ),
      ),
    );
  }
}
