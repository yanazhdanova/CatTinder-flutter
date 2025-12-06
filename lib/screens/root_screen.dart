import 'package:flutter/material.dart';

import 'breed_list_screen.dart';
import 'home_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const BreedListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Кототиндер',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Породы',
          ),
        ],
      ),
    );
  }
}
