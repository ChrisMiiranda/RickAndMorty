import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';
import 'package:test_rm_api/src/components/ShowEpisodesDetails.dart';
import 'package:test_rm_api/src/helper/size_config.dart';

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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Container(
            height: heightPercent(14),
            child: Row(
              children: [
                Text("Filtros:"),
                SizedBox(width: widthPercent(2)),
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
                SizedBox(width: widthPercent(5)),
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
                Expanded(
                  child: IconButton(onPressed: () {
                    setState(() {
                      _filters = _getFilters();
                    });
                  }, icon: Icon(Icons.search)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Episode>>(
            future: episodeClass.getFilteredEpisodes(_filters),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || snapshot.data == null) {
                return Center(child: Column(
                  children: [
                    Text('Episódio não encontrado!'),
                    Text("Verifique os filtros.")
                  ],
                ));
              } else {
                var episodes = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _calculateCrossAxisCount(context),
                          childAspectRatio: widthPercent(.1)
                        ),
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(5),
                            child: GestureDetector(
                              onTap: () {
                                showEpisodesDetails(episodes[index], context);
                              },
                              child: Material(
                                elevation: heightPercent(1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.5, color: Colors.black87),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ListTile(
                                        title: Text(episodes[index].name, textAlign: TextAlign.center,),
                                        subtitle: Text(episodes[index].episode, textAlign: TextAlign.center),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        padding: EdgeInsets.all(heightPercent(2)),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 3;
    } else if (screenWidth < 900) {
      return 4;
    } else {
      return 5;
    }
  }

  _getFilters() {
    return EpisodeFilters(
      name: _name.text,
      episode: _ep.text
    );
  }
}
