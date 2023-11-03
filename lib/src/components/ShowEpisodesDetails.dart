import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';
import 'package:test_rm_api/src/helper/size_config.dart';

void showEpisodesDetails(Episode episode, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text(episode.name)),
        content: Wrap(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: heightPercent(4),
                  ),
                  Text("Episódio: ${episode.episode}"),
                  SizedBox(
                    height: heightPercent(2),
                  ),
                  Text("Data de Lançamento: ${episode.airDate}"),
                  SizedBox(
                    height: heightPercent(2),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
