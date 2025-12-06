import 'package:flutter/material.dart';
import '../models/cat_image.dart';
import 'breed_details_screen.dart';

class CatDetailsScreen extends StatelessWidget {
  final CatImage cat;

  const CatDetailsScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final breed = cat.breed;

    return Scaffold(
      appBar: AppBar(
        title: Text(breed?.name ?? 'Порода неизвестна'),
        centerTitle: true,
      ),
      body: breed == null
          ? const Center(
        child: Text('Нет информации о породе'),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                cat.url,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              breed.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              'Темперамент:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(breed.temperament),

            const SizedBox(height: 12),

            Text(
              'Описание:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(breed.description),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BreedDetailsScreen(breed: breed),
                  ),
                );
              },
              child: const Text('Показать полную информацию о породе'),
            ),
          ],
        ),
      ),
    );
  }
}
