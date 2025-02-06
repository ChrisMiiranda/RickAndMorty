import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';
import 'package:test_rm_api/src/components/ShowCharacterDetails.dart';
import 'package:test_rm_api/src/helper/size_config.dart';

import '../globals.dart';

class CharacterListView extends StatefulWidget {
  @override
  State<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  var _filters = CharacterFilters();
  var genderOptions = ['Masculino', 'Feminino', 'Desconhecido', '-----'];
  var specieOptions = ['Humano', 'Alienígena', '-----'];
  var statusOptions = ['Vivo', 'Morto', 'Desconhecido', '-----'];
  var genderValue = "-----";
  var specieValue = "-----";
  var statusValue = "-----";
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(child: _buildCharacterGrid()),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Wrap(
        spacing: widthPercent(2),
        children: [
          _buildDropdownFilter("Gênero", genderOptions, genderValue, (newValue) {
            setState(() {
              genderValue = newValue!;
              _filters = _getFilters();
            });
          }),
          _buildDropdownFilter("Status", statusOptions, statusValue, (newValue) {
            setState(() {
              statusValue = newValue!;
              _filters = _getFilters();
            });
          }),
          _buildDropdownFilter("Espécie", specieOptions, specieValue, (newValue) {
            setState(() {
              specieValue = newValue!;
              _filters = _getFilters();
            });
          }),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(
      String label, List<String> options, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: options.map((String items) {
            return DropdownMenuItem(value: items, child: Text(items));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nome"),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _name,
                decoration: InputDecoration(contentPadding: EdgeInsets.all(15)),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _filters = _getFilters();
                });
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCharacterGrid() {
    return FutureBuilder<List<Character>>(
      future: charactersClass.getFilteredCharacters(_filters),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Text('Personagem não encontrado! Verifique os filtros.'));
        } else {
          var characters = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _calculateCrossAxisCount(context),
              childAspectRatio: widthPercent(.1),
            ),
            itemCount: characters.length,
            itemBuilder: (context, index) => _buildCharacterCard(characters[index]),
          );
        }
      },
    );
  }

  Widget _buildCharacterCard(Character character) {
    return GestureDetector(
      onTap: () => showCharacterDetails(character, context),
      child: Card(
        elevation: heightPercent(1),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: heightPercent(18),
              width: heightPercent(18),
              child: Image.network(character.image),
            ),
            ListTile(title: Text(character.name, textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 600 ? 3 : screenWidth < 900 ? 4 : 5;
  }

  CharacterFilters _getFilters() {
    return CharacterFilters(
      name: _name.text,
      species: loadSpecie(specieValue),
      gender: loadGender(genderValue),
      status: loadStatus(statusValue),
    );
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
