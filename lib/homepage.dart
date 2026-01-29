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
                {'name': 'drinks', 'image': 'assets/drinks/drinks.png', 'price': '\$2.50'},
                {'name': 'brownsugar', 'image': 'assets/drinks/brownsugar.png', 'price': '\$4.50'},
                {'name': 'coffee', 'image': 'assets/drinks/coffee.png', 'price': '\$3.00'},
                {'name': 'coke', 'image': 'assets/drinks/coke.png', 'price': '\$2.00'},
                {'name': 'icedcappuccino', 'image': 'assets/drinks/icedcappuccino.png', 'price': '\$4.00'},
              ],
            ),
            SizedBox(height: 20),
            CategoryHighlight(
              title: 'Hot Pizza',
              autoSlideDuration: Duration(seconds: 5),
              foodData: [
                {'name': 'pizza', 'image': 'assets/pizza/pizza.png', 'price': '\$12.00'},
                {'name': 'ISPizza', 'image': 'assets/pizza/ISPizza.png', 'price': '\$15.00'},
                {'name': 'pizza3', 'image': 'assets/pizza/pizza3.png', 'price': '\$14.00'},
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
              children: [
                Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                Text(item['price']!, style: const TextStyle(color: Colors.orange, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
