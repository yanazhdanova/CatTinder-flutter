import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/breed.dart';
import '../models/cat_image.dart';

class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1';

  static List<Breed>? _cachedBreeds;
  static final Random _random = Random();


  static Future<CatImage> fetchRandomCatImage() async {

    if (_cachedBreeds == null || _cachedBreeds!.isEmpty) {
      _cachedBreeds = await fetchBreeds();
    }

    if (_cachedBreeds == null || _cachedBreeds!.isEmpty) {
      throw Exception('Не удалось загрузить список пород');
    }

    final breed = _cachedBreeds![_random.nextInt(_cachedBreeds!.length)];


    final uri = Uri.parse(
      '$_baseUrl/images/search?breed_ids=${breed.id}&limit=1',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки котика: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    if (data.isEmpty) {
      throw Exception('Сервер вернул пустой список котиков');
    }

    final Map<String, dynamic> imageJson =
    data.first as Map<String, dynamic>;


    return CatImage(
      id: imageJson['id'] as String? ?? '',
      url: imageJson['url'] as String? ?? '',
      breed: breed,
    );
  }

  static Future<List<Breed>> fetchBreeds() async {
    final uri = Uri.parse('$_baseUrl/breeds');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки пород: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((json) => Breed.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
