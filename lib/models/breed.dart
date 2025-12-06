class Breed {
  final String id;
  final String name;
  final String description;
  final String temperament;
  final String origin;
  final String lifeSpan;
  final int intelligence;
  final int affectionLevel;
  final int energyLevel;
  final int childFriendly;
  final int dogFriendly;
  final int socialNeeds;

  Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    required this.intelligence,
    required this.affectionLevel,
    required this.energyLevel,
    required this.childFriendly,
    required this.dogFriendly,
    required this.socialNeeds,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      temperament: json['temperament'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      lifeSpan: json['life_span'] as String? ?? '',

      intelligence: json['intelligence'] as int? ?? 0,
      affectionLevel: json['affection_level'] as int? ?? 0,
      energyLevel: json['energy_level'] as int? ?? 0,
      childFriendly: json['child_friendly'] as int? ?? 0,
      dogFriendly: json['dog_friendly'] as int? ?? 0,
      socialNeeds: json['social_needs'] as int? ?? 0,
    );
  }
}
