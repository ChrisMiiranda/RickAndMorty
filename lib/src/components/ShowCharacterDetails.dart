import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';
import 'package:test_rm_api/src/helper/size_config.dart';

void showCharacterDetails(Character character, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text(character.name)),
        content: Wrap(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: heightPercent(20),
                    width: heightPercent(20),
                    child: Image.network(
                      character.image,
                    ),
                  ),
                  SizedBox(
                    height: heightPercent(4),
                  ),
                  Text("Status: ${character.status.toString().replaceAll('Status.', '')}"),
                  SizedBox(
                    height: heightPercent(2),
                  ),
                  Text("Espécie: ${character.species.toString().replaceAll('Species.', '')}"),
                  SizedBox(
                    height: heightPercent(2),
                  ),
                  Text("Gênero: ${character.gender.toString().replaceAll('Gender.', '')}"),
                  SizedBox(
                    height: heightPercent(2),
                  ),
                  Text("Origem: ${character.origin.name}"),
                  SizedBox(
                    height: heightPercent(2),
                  ),
                  Text("Localização: ${character.location.name}"),
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
