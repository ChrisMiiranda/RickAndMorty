import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';
import 'package:test_rm_api/src/components/ShowCharacterDetails.dart';
import 'package:test_rm_api/src/helper/size_config.dart';

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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Wrap(
            children: [
              Container(
                child: Wrap(
                  // alignment: WrapAlignment.start,
                  spacing: widthPercent(2),
                  children: [
                    Text("Filtros:"),
                    SizedBox(width: widthPercent(2)),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nome"),
                        Container(
                          constraints: BoxConstraints(maxWidth: widthPercent(30)),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
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
                              ),
                              IconButton(onPressed: () {
                                setState(() {
                                  _filters = _getFilters();
                                });
                              }, icon: Icon(Icons.search)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        FutureBuilder<List<Character>>(
          future: charactersClass.getFilteredCharacters(_filters),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Column(
                children: [
                  Text('Personagem não encontrado!'),
                  Text("Verifique os filtros.")
                ],
              ));
            } else {
              var characters = snapshot.data!;
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _calculateCrossAxisCount(context),
                    childAspectRatio: widthPercent(.1),
                  ),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          showCharacterDetails(characters[index], context);
                        },
                        child: Material(
                          elevation: heightPercent(1),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.5, color: Colors.black87),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: heightPercent(18),
                                  width: heightPercent(18),
                                  child: Image.network(
                                    characters[index].image,
                                  ),
                                ),
                                ListTile(
                                  title: Text(characters[index].name, textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              );
            }
          },
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
