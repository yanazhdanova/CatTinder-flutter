import 'package:flutter/material.dart';

import '../models/breed.dart';
import '../services/cat_api_service.dart';
import 'breed_details_screen.dart';

class BreedListScreen extends StatelessWidget {
  const BreedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список пород'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Breed>>(
        future: CatApiService.fetchBreeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Ошибка загрузки пород:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final breeds = snapshot.data ?? [];

          if (breeds.isEmpty) {
            return const Center(
              child: Text('Список пород пуст'),
            );
          }

          return ListView.separated(
            itemCount: breeds.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final breed = breeds[index];
              return ListTile(
                title: Text(breed.name),
                subtitle: Text(
                  breed.origin,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BreedDetailsScreen(breed: breed),
                    ),
                  );
                },
              );

            },
          );
        },
      ),
    );
  }
}
