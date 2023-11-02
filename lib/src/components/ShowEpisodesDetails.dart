import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';

void showEpisodesDetails(Episode episode, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 50,
        child: AlertDialog(
          title: Center(child: Text(episode.name)),
          content: Wrap(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text("Episódio: ${episode.episode}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Data de Lançamento: ${episode.airDate}"),
                    SizedBox(
                      height: 10,
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
        ),
      );
    },
  );
}
