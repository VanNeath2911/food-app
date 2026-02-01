// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:food_app/bergerpage.dart';
import 'package:food_app/drinkpage.dart';
import 'package:food_app/homepage.dart';
import 'package:food_app/pizzapage.dart';
import 'package:food_app/accountpage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  late PageController _pageController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

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

  // --- FIXED INDEXING ---
  // Pages are now ordered 0-6 to match the BottomNav/Rail perfectly
  final List<Widget> pages = [
    const HomePage(), // 0
    const DrinkPage(title: 'Drinks Page'), // 1
    const Bergerpage(title: 'Burgers Page'), // 2
    const PizzaPage(title: 'Pizza Page'), // 3
    const Center(child: Text('Shopping Cart Page', style: TextStyle(fontSize: 24))), // 4
    const AccountPage(title: 'Account Page'), // 5 (Matches Account Icon)
    const Center(
      // 6 (About Us)
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, size: 100, color: Colors.orange),
          Text('About Us Page', style: TextStyle(fontSize: 24)),
        ],
      ),
    ),
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

  void _navigateToPage(int index) {
    if (index == selectedIndex) return;

    _pageController.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);

    setState(() {
      selectedIndex = index;
      _searchQuery = "";
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 700;

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
                  // FIXED: Index 6 is the "About Us" button in trailing, so Rail index stops at 5
                  selectedIndex: selectedIndex > 5 ? null : selectedIndex,
                  onDestinationSelected: _navigateToPage,
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: Color.fromARGB(255, 96, 171, 198), size: 30),
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
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Account'),
                    ),
                  ],
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: InkWell(
                          onTap: () => _navigateToPage(6),
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info,
                                // Indicator for About Us page
                                color: selectedIndex == 6 ? const Color.fromARGB(255, 96, 171, 198) : Colors.grey,
                              ),
                              const Text('About Us', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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

          /// 🔍 SEARCH SUGGESTIONS (PRESERVED)
          SearchSuggestions(
            query: _searchQuery,
            pizzas: allPizzasnames,
            burgers: allburgersnames,
            drinks: allDrinkNames,
            onNavigate: _navigateToPage,
            isDesktop: isDesktop,
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
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: "Account",
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

// SearchSuggestions widget definition (basic placeholder)
class SearchSuggestions extends StatelessWidget {
  final String query;
  final List<String> pizzas;
  final List<String> burgers;
  final List<String> drinks;
  final Function(int) onNavigate;
  final bool isDesktop;

  const SearchSuggestions({
    Key? key,
    required this.query,
    required this.pizzas,
    required this.burgers,
    required this.drinks,
    required this.onNavigate,
    required this.isDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();

    final List<String> suggestions = [
      ...pizzas.where((p) => p.toLowerCase().contains(query.toLowerCase())),
      ...burgers.where((b) => b.toLowerCase().contains(query.toLowerCase())),
      ...drinks.where((d) => d.toLowerCase().contains(query.toLowerCase())),
    ];

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Positioned(
      left: isDesktop ? 250 : 0,
      right: 0,
      top: kToolbarHeight,
      child: Material(
        elevation: 4,
        child: ListView(
          shrinkWrap: true,
          children: suggestions
              .map(
                (s) => ListTile(
                  title: Text(s),
                  onTap: () {
                    // Example: navigate to Pizza, Burger, or Drink page
                    if (pizzas.contains(s)) {
                      onNavigate(3); // Pizza page index
                    } else if (burgers.contains(s)) {
                      onNavigate(2); // Burger page index
                    } else if (drinks.contains(s)) {
                      onNavigate(1); // Drink page index
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
