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
    return MaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange), useMaterial3: true),
      home: const HomePage(title: 'Food Menu'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9F2), Color(0xFFFDE2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100, bottom: 40),
          child: Column(
            children: const [
              CategoryHighlight(
                title: 'Refreshments',
                images: ['assets/drinks.png', 'assets/drinks2.png', 'assets/drinks3.png'],
                mobileHeight: 350,
                desktopHeight: 400,
                aspectRatio: 0.7,
              ),
              SizedBox(height: 30),
              CategoryHighlight(
                title: 'Hot Pizza',
                images: ['assets/aizza.png', 'assets/aizza2.png', 'assets/aizza3.png'],
                mobileHeight: 300,
                desktopHeight: 350,
                aspectRatio: 1.0,
              ),
              SizedBox(height: 30),
              CategoryHighlight(
                title: 'Gourmet Burgers',
                images: ['assets/berger.png', 'assets/berger2.png', 'assets/berger3.png'],
                mobileHeight: 250,
                desktopHeight: 300,
                aspectRatio: 1.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryHighlight extends StatefulWidget {
  final String title;
  final List<String> images;
  final double mobileHeight;
  final double desktopHeight;
  final double aspectRatio;

  const CategoryHighlight({
    super.key,
    required this.title,
    required this.images,
    required this.mobileHeight,
    required this.desktopHeight,
    required this.aspectRatio,
  });

  @override
  State<CategoryHighlight> createState() => _CategoryHighlightState();
}

class _CategoryHighlightState extends State<CategoryHighlight> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  bool _isDesktop = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isDesktop && mounted) {
        _currentPage++;
        if (_currentPage >= widget.images.length) _currentPage = 0;

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        _isDesktop = constraints.maxWidth >= 700;
        double currentHeight = _isDesktop ? widget.desktopHeight : widget.mobileHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(widget.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: currentHeight,
              child: _isDesktop
                  // Desktop: horizontal scrolling list
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) => _buildImageCard(
                        widget.images[index],
                        currentHeight * widget.aspectRatio,
                        currentHeight,
                        true,
                      ),
                    )
                  // Mobile: carousel slider
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) =>
                          _buildImageCard(widget.images[index], double.infinity, currentHeight, false),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageCard(String path, double width, double height, bool isDesktop) {
    return Container(
      width: isDesktop ? width : null,
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 10 : 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.fastfood, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
