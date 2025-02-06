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
  {'label': 'Personagens', 'icon': Icons.person},
  {'label': 'Episódios', 'icon': Icons.tv},
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5CAD4A), Color(0xFF3E8E41)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: heightPercent(12)),
              ],
            ),
          ),
          bottom: TabBar(
            indicator: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              for (final tab in _tabs)
                Tab(
                  icon: Icon(tab['icon'] as IconData?, size: 24),
                  text: tab['label'] as String,
                ),
            ],
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
