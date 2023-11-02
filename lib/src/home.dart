import 'package:flutter/material.dart';

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
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5CAD4A),
          title: Text('Rick And Morty API'),
          bottom: TabBar(
            indicatorColor: Color(0xFFF0F2EB),
            isScrollable: true,
            tabs: [for (final tab in _tabs) Tab(child: Text(tab))],
          ),
        ),
        body: TabBarView(
          physics: ClampingScrollPhysics(),
          children: [
            CharacterListView(),
            EpisodeListView(),
          ],
        ),
      ),
    );
  }
}
