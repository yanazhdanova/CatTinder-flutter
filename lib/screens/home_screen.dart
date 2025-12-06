import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/cat_image.dart';
import '../services/cat_api_service.dart';
import 'cat_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CatImage? _currentCat;
  int _likeCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRandomCat();
  }

  Future<void> _loadRandomCat() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cat = await CatApiService.fetchRandomCatImage();
      setState(() {
        _currentCat = cat;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadRandomCat();
              },
              child: const Text('Повторить'),
            ),
          ],
        );
      },
    );
  }

  void _onLike() {
    setState(() {
      _likeCount++;
    });
    _loadRandomCat();
  }

  void _onDislike() {
    _loadRandomCat();
  }

  void _openDetails() {
    final cat = _currentCat;
    if (cat == null || cat.breed == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CatDetailsScreen(cat: cat),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cat = _currentCat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кототиндер'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _isLoading
                ? const CircularProgressIndicator()
                : _errorMessage != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Произошла ошибка'),
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadRandomCat,
                  child: const Text('Повторить'),
                ),
              ],
            )
                : cat == null
                ? const Text('Нет данных о котике')
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Лайки: $_likeCount',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Dismissible(
                    key: ValueKey(cat.id),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction ==
                          DismissDirection.endToStart) {
                        _onDislike();
                      } else {

                        _onLike();
                      }
                    },
                    child: GestureDetector(
                      onTap: _openDetails,
                      child: Card(
                        elevation: 4,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: cat.url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const Center(
                                  child:
                                  CircularProgressIndicator(),
                                ),
                                errorWidget:
                                    (context, url, error) =>
                                const Icon(
                                  Icons.error,
                                  size: 40,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                cat.breed?.name ??
                                    'Порода неизвестна',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _onDislike,
                        icon: const Icon(Icons.close),
                        label: const Text('Дизлайк'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _onLike,
                        icon: const Icon(Icons.favorite),
                        label: const Text('Лайк'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
