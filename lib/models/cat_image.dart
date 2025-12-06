import 'breed.dart';


class CatImage {
  final String id;
  final String url;
  final Breed? breed;

  CatImage({
    required this.id,
    required this.url,
    this.breed,
  });


  factory CatImage.fromJson(Map<String, dynamic> json) {
    final breedsJson = json['breeds'] as List<dynamic>?;

    Breed? breed;

    if (breedsJson != null && breedsJson.isNotEmpty) {
      final breedJson = breedsJson.first as Map<String, dynamic>;
      breed = Breed.fromJson(breedJson);
    }

    return CatImage(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      breed: breed,
    );
  }
}
