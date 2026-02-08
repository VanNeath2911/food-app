// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:food_app/bergerpage.dart';
import 'package:food_app/drinkpage.dart';
import 'package:food_app/homepage.dart';
import 'package:food_app/pizzapage.dart';
import 'package:food_app/accountpage.dart';
import 'package:food_app/cartpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _showSearch = false;

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

  final List<Widget Function()> _pageBuilders = [
    () => const HomePage(),
    () => const DrinkPage(title: 'Drinks Page'),
    () => const Bergerpage(title: 'Burgers Page'),
    () => const PizzaPage(title: 'Pizza Page'),
    () => const CartPage(title: 'Cart Page'),
    () => const AccountPage(title: 'Account Page'),
    () => const AboutUsPage(),
  ];

  final Map<int, Widget> _pageCache = {};
  Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = _buildPage(0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildPage(int index) {
    if (_pageCache.containsKey(index)) {
      return _pageCache[index]!;
    }

    final page = _pageBuilders[index]();
    _pageCache[index] = page;
    return page;
  }

  void _navigateToPage(int index) {
    if (index == selectedIndex) {
      setState(() {
        _showSearch = false;
        _searchQuery = "";
        _searchController.clear();
      });
      return;
    }

    setState(() {
      selectedIndex = index;
      _currentPage = _buildPage(index);
      _showSearch = false;
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
        title: !_showSearch
            ? Row(
                children: [
                  Icon(Icons.fastfood, color: Colors.white, size: isDesktop ? 35 : 24),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showSearch = true;
                        });
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: const Row(
                          children: [
                            SizedBox(width: 15),
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 10),
                            Text('Search...', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showSearch = false;
                        _searchQuery = "";
                        _searchController.clear();
                      });
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
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
                child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: _currentPage),
              ),
            ],
          ),

          if (_showSearch && _searchQuery.isNotEmpty)
            SearchSuggestions(
              query: _searchQuery,
              pizzas: allPizzasnames,
              burgers: allburgersnames,
              drinks: allDrinkNames,
              onNavigate: _navigateToPage,
              isDesktop: isDesktop,
              onHide: () {
                setState(() {
                  _showSearch = false;
                  _searchQuery = "";
                  _searchController.clear();
                });
              },
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

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info, size: 100, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                'About Us',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to our Food App! We provide delicious burgers, pizzas, and drinks.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Learn More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchSuggestions extends StatelessWidget {
  final String query;
  final List<String> pizzas;
  final List<String> burgers;
  final List<String> drinks;
  final Function(int) onNavigate;
  final bool isDesktop;
  final VoidCallback onHide;

  const SearchSuggestions({
    Key? key,
    required this.query,
    required this.pizzas,
    required this.burgers,
    required this.drinks,
    required this.onNavigate,
    required this.isDesktop,
    required this.onHide,
  }) : super(key: key);

  List<Map<String, dynamic>> _getSuggestions() {
    final lowerQuery = query.toLowerCase().trim();
    if (lowerQuery.isEmpty) return [];

    final List<Map<String, dynamic>> allItems = [];

    for (final pizza in pizzas) {
      if (pizza.toLowerCase().contains(lowerQuery)) {
        allItems.add({'name': pizza, 'type': 'pizza'});
      }
    }

    for (final burger in burgers) {
      if (burger.toLowerCase().contains(lowerQuery)) {
        allItems.add({'name': burger, 'type': 'burger'});
      }
    }

    for (final drink in drinks) {
      if (drink.toLowerCase().contains(lowerQuery)) {
        allItems.add({'name': drink, 'type': 'drink'});
      }
    }

    allItems.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _getSuggestions();

    if (suggestions.isEmpty) {
      return Positioned(
        left: isDesktop ? 88 : 0,
        right: 0,
        top: kToolbarHeight,
        child: Container(
          height: 50,
          color: Colors.white,
          alignment: Alignment.center,
          child: const Text('No results found'),
        ),
      );
    }

    return Positioned(
      left: isDesktop ? 88 : 0,
      right: 0,
      top: kToolbarHeight,
      child: Container(
        color: Colors.white,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final item = suggestions[index];
            final name = item['name'] as String;
            final type = item['type'] as String;

            IconData icon;
            switch (type) {
              case 'pizza':
                icon = Icons.local_pizza;
                break;
              case 'burger':
                icon = Icons.lunch_dining;
                break;
              case 'drink':
                icon = Icons.local_drink;
                break;
              default:
                icon = Icons.fastfood;
            }

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(icon, size: 24),
              title: Text(name, style: const TextStyle(fontSize: 16)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                child: Text(
                  type.toUpperCase(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
              ),
              onTap: () {
                onHide();
                if (type == 'pizza') {
                  onNavigate(3);
                } else if (type == 'burger') {
                  onNavigate(2);
                } else if (type == 'drink') {
                  onNavigate(1);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
