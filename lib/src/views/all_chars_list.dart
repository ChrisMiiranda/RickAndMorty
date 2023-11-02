import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';
import 'package:test_rm_api/src/components/ShowCharacterDetails.dart';

import '../globals.dart';

var _filters = CharacterFilters();
var genderOptions = ['Masculino', 'Feminino', 'Desconhecido', '-----'];
var specieOptions = ['Humano', 'Alienígena', '-----'];
var statusOptions = ['Vivo', 'Morto', 'Desconhecido', '-----'];
var genderValue = "-----";
var specieValue = "-----";
var statusValue = "-----";
final _name = TextEditingController();

class CharacterListView extends StatefulWidget {
  @override
  State<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: charactersClass.getFilteredCharacters(_filters),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Text('Error Loading Data.'));
        } else {
          var characters = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Text("Filtros:"),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Gênero"),
                          DropdownButton(
                            value: genderValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: genderOptions.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                genderValue = newValue!;
                                _filters = _getFilters();
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status"),
                          DropdownButton(
                            value: statusValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: statusOptions.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                statusValue = newValue!;
                                _filters = _getFilters();
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Espécie"),
                          DropdownButton(
                            value: specieValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: specieOptions.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                specieValue = newValue!;
                                _filters = _getFilters();
                              });
                            },
                          ),
                        ],
                      ),
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
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showCharacterDetails(characters[index], context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.5, color: Colors.black87),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  characters[index].image,
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(characters[index].name),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      height: 10,
                      width: double.infinity,
                    ),
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
    return CharacterFilters(
        name: _name.text,
        species: loadSpecie(specieValue),
        gender: loadGender(genderValue),
        status: loadStatus(statusValue));
  }

  loadGender(String gender) {
    if (gender == 'Masculino') {
      return CharacterGender.male;
    }
    if (gender == 'Feminino') {
      return CharacterGender.female;
    }
    if (gender == 'Desconhecido') {
      return CharacterGender.unknown;
    } else {
      return CharacterGender.empty;
    }
  }

  loadSpecie(String specie) {
    if (specie == 'Humano') {
      return CharacterSpecies.human;
    }
    if (specie == 'Alienígena') {
      return CharacterSpecies.alien;
    } else {
      return CharacterSpecies.empty;
    }
  }

  loadStatus(String status) {
    if (status == 'Vivo') {
      return CharacterStatus.alive;
    }
    if (status == 'Morto') {
      return CharacterStatus.dead;
    }
    if (status == 'Desconhecido') {
      return CharacterStatus.unknown;
    } else {
      return CharacterStatus.empty;
    }
  }
}
