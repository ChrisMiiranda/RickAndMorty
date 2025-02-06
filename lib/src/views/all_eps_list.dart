import 'package:flutter/material.dart';
import 'package:rick_and_morty_api/rick_and_morty_api.dart';
import 'package:test_rm_api/src/components/ShowEpisodesDetails.dart';
import 'package:test_rm_api/src/helper/size_config.dart';

import '../globals.dart';

class EpisodeListView extends StatefulWidget {
  @override
  State<EpisodeListView> createState() => _EpisodeListViewState();
}

class _EpisodeListViewState extends State<EpisodeListView> {
  final _nameController = TextEditingController();
  final _episodeController = TextEditingController();
  var _filters = EpisodeFilters();

  @override
  void dispose() {
    _nameController.dispose();
    _episodeController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filters = EpisodeFilters(
        name: _nameController.text,
        episode: _episodeController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(
          child: FutureBuilder<List<Episode>>(
            future: episodeClass.getFilteredEpisodes(_filters),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Nenhum episódio encontrado! Verifique os filtros.',
                        textAlign: TextAlign.center),
                  ),
                );
              }

              return _buildEpisodeGrid(snapshot.data!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filtros:"),
          const SizedBox(height: 10),
          _buildFilterField("Nome", _nameController),
          const SizedBox(height: 10),
          _buildFilterField("Episódio", _episodeController, withButton: true),
        ],
      ),
    );
  }

  Widget _buildFilterField(String label, TextEditingController controller, {bool withButton = false}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              TextFormField(
                controller: controller,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        if (withButton) ...[
          const SizedBox(width: 10),
          IconButton(
            onPressed: _applyFilters,
            icon: const Icon(Icons.search),
          ),
        ],
      ],
    );
  }

  Widget _buildEpisodeGrid(List<Episode> episodes) {
    return GridView.builder(
      padding: EdgeInsets.all(heightPercent(2)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(context),
        childAspectRatio: widthPercent(0.4),
      ),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        return _buildEpisodeCard(episodes[index]);
      },
    );
  }

  Widget _buildEpisodeCard(Episode episode) {
    return GestureDetector(
      onTap: () => showEpisodesDetails(episode, context),
      child: Card(
        elevation: heightPercent(1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                episode.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                episode.episode,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 2;
    } else if (screenWidth < 900) {
      return 3;
    } else {
      return 4;
    }
  }
}
