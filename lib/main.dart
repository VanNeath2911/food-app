// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:food_app/bergerpage.dart';
import 'package:food_app/drinkpage.dart';
import 'package:food_app/homepage.dart';
import 'package:food_app/pizzapage.dart';

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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  late PageController _pageController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Data lists for search logic
  final List<String> allPizzasnames = [
    'Personal Pepperoni Pizza',
    'Margherita Pizza',
    'Pizza Bianca',
    'Garden Veggie Pizza',
    'Quattro Formaggi Pizza',
    'Deluxe pizza',
    'Vegetarian Pizza',
  ];
  final List<String> allburgersnames = [
    'The Classic Cheeseburger',
    'Bacon Barbecue Burger',
    'Breakfast Bap',
    'Double Smash Burger',
    'Mushroom Swiss Burger',
    'Spicy Zinger Burger',
    'The Hawaiian Burger',
    'Truffle Deluxe Burger',
    'Wagyu Beef Burger',
  ];
  final List<String> allDrinkNames = [
    'Brown Sugar',
    'Coke',
    'Iced Cappuccino',
    'coffee',
    'matcha',
    'Passion Cream',
    'Water',
  ];

  // pages index 4 is Cart, index 5 is About Us
  final List<Widget> pages = const [
    HomePage(),
    DrinkPage(title: 'Drinks Page'),
    Bergerpage(title: 'Burgers Page'),
    PizzaPage(title: 'Pizza Page'),
    Center(child: Text('Shopping Cart Page', style: TextStyle(fontSize: 24))), // Index 4
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, size: 100, color: Colors.orange),
          Text('About Us Page', style: TextStyle(fontSize: 24)),
        ],
      ),
    ), // Index 5
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // --- ASYNC NAVIGATION HELPER ---
  Future<void> _navigateToPage(int index) async {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
      _searchQuery = "";
      _searchController.clear();
    });

    // Wait for the page transition to complete
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 700;

    List<String> suggestions = [];
    if (_searchQuery.isNotEmpty) {
      suggestions = [
        ...allPizzasnames.where((food) => food.toLowerCase().contains(_searchQuery.toLowerCase())),
        ...allburgersnames.where((food) => food.toLowerCase().contains(_searchQuery.toLowerCase())),
        ...allDrinkNames.where((food) => food.toLowerCase().contains(_searchQuery.toLowerCase())),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 105, 206, 184),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.fastfood, color: Colors.white, size: isDesktop ? 35 : 24),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              if (isDesktop) ...[
                NavigationRail(
                  selectedIndex: selectedIndex == 5 ? null : selectedIndex,
                  onDestinationSelected: _navigateToPage,
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: Color.fromARGB(255, 96, 171, 198), size: 30),
                  // Pushing About Us to the bottom
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: InkWell(
                          onTap: () => _navigateToPage(5), // Index 5
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info,
                                color: selectedIndex == 5 ? const Color.fromARGB(255, 96, 171, 198) : Colors.grey,
                              ),
                              const Text('About Us', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.local_drink_outlined),
                      selectedIcon: Icon(Icons.local_drink),
                      label: Text('Drinks'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.lunch_dining_outlined),
                      selectedIcon: Icon(Icons.lunch_dining),
                      label: Text('Burgers'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.local_pizza_outlined),
                      selectedIcon: Icon(Icons.local_pizza),
                      label: Text('Pizza'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.shopping_cart_outlined),
                      selectedIcon: Icon(Icons.shopping_cart),
                      label: Text('Cart'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
              ],
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              ),
            ],
          ),
          // Suggestions Overlay
          if (suggestions.isNotEmpty)
            Positioned(
              top: 5,
              left: isDesktop ? 90 : 20,
              right: 20,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(15),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final result = suggestions[index];
                    return ListTile(
                      title: Text(result),
                      onTap: () {
                        if (allDrinkNames.contains(result))
                          _navigateToPage(1);
                        else if (allburgersnames.contains(result))
                          _navigateToPage(2);
                        else if (allPizzasnames.contains(result))
                          _navigateToPage(3);
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: _navigateToPage,
              selectedItemColor: const Color.fromARGB(255, 96, 171, 198),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_drink_outlined),
                  activeIcon: Icon(Icons.local_drink),
                  label: "Drinks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.lunch_dining_outlined),
                  activeIcon: Icon(Icons.lunch_dining),
                  label: "Burgers",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_pizza_outlined),
                  activeIcon: Icon(Icons.local_pizza),
                  label: "Pizza",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  activeIcon: Icon(Icons.shopping_cart),
                  label: "Cart",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline),
                  activeIcon: Icon(Icons.info),
                  label: "About Us",
                ),
              ],
            ),
    );
  }
}
