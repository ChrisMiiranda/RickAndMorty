import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';

void showCharacterDetails(Character character, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 50,
        child: AlertDialog(
          title: Center(child: Text(character.name)),
          content: Wrap(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 75,
                      width: 75,
                      child: Image.network(
                        character.image,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Status: ${character.status.toString().replaceAll('Status.', '')}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Espécie: ${character.species.toString().replaceAll('Species.', '')}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Gênero: ${character.gender.toString().replaceAll('Gender.', '')}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Origem: ${character.origin.name}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Status: ${character.location.name}"),
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
