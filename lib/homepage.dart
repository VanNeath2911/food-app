// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE2FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CategoryHighlight(
              title: 'Refreshments',
              autoSlideDuration: Duration(seconds: 3),
              foodData: [
                {'name': 'Brown Sugar', 'image': 'assets/drinks/brownsugar.png'},
                {'name': 'Coffee', 'image': 'assets/drinks/coffee.png'},
                {'name': 'Coke', 'image': 'assets/drinks/coke.png'},
                {'name': 'Iced Cappuccino', 'image': 'assets/drinks/icedcappuccino.png'},
                {'name': 'Matcha', 'image': 'assets/drinks/matcha.png'},
                {'name': 'Passion Cream', 'image': 'assets/drinks/passioncream.png'},
                {'name': 'Water', 'image': 'assets/drinks/water.png'},
              ],
            ),
            SizedBox(height: 20),
            CategoryHighlight(
              title: 'Hot Pizza',
              autoSlideDuration: Duration(seconds: 5),
              foodData: [
                {'name': 'Garden Veggie Pizza', 'image': 'assets/pizza/pizza.png'},
                {'name': 'Personal Pepperoni Pizza', 'image': 'assets/pizza/ISPizza.png'},
                {'name': 'Pizza Bianca Pizza', 'image': 'assets/pizza/pizza3.png'},
                {'name': 'Quattro Formaggi Pizza', 'image': 'assets/pizza/pizza4.png'},
                {'name': 'Deluxe pizza', 'image': 'assets/pizza/pizza5.png'},
                {'name': 'Vegetarian Pizza', 'image': 'assets/pizza/pizza6.png'},
                {'name': 'Margherita Pizza', 'image': 'assets/pizza/pizza7.png'},
              ],
            ),
            SizedBox(height: 20),
            CategoryHighlight(
              title: 'Delicious Burgers',
              autoSlideDuration: Duration(seconds: 5),
              foodData: [
                {'name': 'The Classic Cheeseburger', 'image': 'assets/burger/berger.png'},
                {'name': 'Bacon Barbecue Burger', 'image': 'assets/burger/baconbarbecue.png'},
                {'name': 'Breakfast Bap', 'image': 'assets/burger/breakfastbap.png'},
                {'name': 'Double Smash Burger', 'image': 'assets/burger/doublesmash.png'},
                {'name': 'Mushroom Swiss Burger', 'image': 'assets/burger/mushroomswiss.png'},
                {'name': 'Spicy Zinger Burger', 'image': 'assets/burger/spicyzinger.png'},
                {'name': 'The Hawaiian Burger', 'image': 'assets/burger/theawaiian.png'},
                {'name': 'Truffle Deluxe Burger', 'image': 'assets/burger/truffledeluxe.png'},
                {'name': 'Wagyu Beef Burger', 'image': 'assets/burger/wagyubeef.png'},
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryHighlight extends StatefulWidget {
  final String title;
  final List<Map<String, String>> foodData;
  final Duration autoSlideDuration;

  const CategoryHighlight({super.key, required this.title, required this.foodData, required this.autoSlideDuration});

  @override
  State<CategoryHighlight> createState() => _CategoryHighlightState();
}

class _CategoryHighlightState extends State<CategoryHighlight> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Reduced fraction to 0.22 to bring cards very close together
    _pageController = PageController(viewportFraction: 0.22, keepPage: true);

    _timer = Timer.periodic(widget.autoSlideDuration, (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.foodData.length;
      });
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 200, // Reduced height so cards don't look "tall/heavy"
          child: PageView.builder(
            controller: _pageController,
            padEnds: false, // Keeps the first item aligned to the left
            itemCount: widget.foodData.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              bool isHighlighted = _currentIndex == index;
              return AnimatedScale(
                scale: isHighlighted ? 1.0 : 0.9,
                duration: const Duration(milliseconds: 500),
                child: _buildItemCard(widget.foodData[index], isHighlighted),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, String> item, bool isHighlighted) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(isHighlighted ? 0.9 : 0.5),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                item['image']!,
                fit: BoxFit.contain, // Ensures image doesn't get cut off
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))],
            ),
          ),
        ],
      ),
    );
  }
}
