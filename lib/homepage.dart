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
      backgroundColor: const Color.fromARGB(255, 102, 178, 195),
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
                {'name': 'Pizza Bianca', 'image': 'assets/pizza/pizza3.png'},
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
    _pageController = PageController(viewportFraction: 0.22, keepPage: true);
    _startTimer(); // Start the initial timer
  }

  // --- ADDED: Timer logic separated to a function for easier restarting ---
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoSlideDuration, (timer) {
      if (!mounted) return;
      _animateToNextPage();
    });
  }

  void _animateToNextPage() {
    if (_pageController.hasClients) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.foodData.length;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // --- ADDED: Method to handle user interaction ---
  void _handleUserInteraction() {
    _timer?.cancel(); // Stop auto-slide immediately
    // Wait 3 seconds, then restart the periodic timer
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _startTimer();
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
          height: 200,
          // --- ADDED: NotificationListener detects when user starts scrolling ---
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _handleUserInteraction();
              }
              return true;
            },
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
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
              child: Image.asset(item['image']!, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              item['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
