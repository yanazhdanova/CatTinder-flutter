import 'package:flutter/material.dart';

import '../models/breed.dart';

class BreedDetailsScreen extends StatelessWidget {
  final Breed breed;

  const BreedDetailsScreen({super.key, required this.breed});

  Widget buildCharacteristic(String title, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(title),
          ),
          Expanded(
            child: Row(
              children: List.generate(
                5,
                    (index) => Icon(
                  index < value ? Icons.star : Icons.star_border,
                  size: 20,
                  color: Colors.amber,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                breed.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              Text(
                'Описание:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(breed.description),
              const SizedBox(height: 16),

              Text(
                'Темперамент:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(breed.temperament),
              const SizedBox(height: 16),

              Text(
                'Характеристики:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              buildCharacteristic('Интеллект', breed.intelligence),
              buildCharacteristic('Ласковость', breed.affectionLevel),
              buildCharacteristic('Энергия', breed.energyLevel),
              buildCharacteristic('Отношения с детьми', breed.childFriendly),
              buildCharacteristic('Отношения с собаками', breed.dogFriendly),
              buildCharacteristic('Социальность', breed.socialNeeds),
            ],
          ),
        ),
      ),
    );
  }
}
