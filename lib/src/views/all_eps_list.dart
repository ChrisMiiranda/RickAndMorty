import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';
import 'package:test_rm_api/src/components/ShowEpisodesDetails.dart';

import '../globals.dart';

var _filters = EpisodeFilters();
final _name = TextEditingController();
final _ep = TextEditingController();

class EpisodeListView extends StatefulWidget {
  @override
  State<EpisodeListView> createState() => _EpisodeListViewState();
}

class _EpisodeListViewState extends State<EpisodeListView> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Episode>>(
      future: episodeClass.getFilteredEpisodes(_filters),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Text('Error Loading Data.'));
        } else {
          var episodes = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Text("Filtros:"),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome"),
                            TextFormField(
                              scrollPadding: EdgeInsets.all(200),
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.characters,
                              controller: _name,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.all(15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Episódio"),
                            TextFormField(
                              scrollPadding: EdgeInsets.all(200),
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.characters,
                              controller: _ep,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.all(15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      IconButton(onPressed: () {
                        setState(() {
                          _filters = _getFilters();
                        });
                      }, icon: Icon(Icons.search)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        Container(height: 10, width: double.infinity),
                    itemCount: episodes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showEpisodesDetails(episodes[index], context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.5, color: Colors.black87),
                          ),
                          child: ListTile(
                            title: Text(episodes[index].name),
                            subtitle: Text(episodes[index].episode),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _getFilters() {
    return EpisodeFilters(
      name: _name.text,
      episode: _ep.text
    );
  }
}
