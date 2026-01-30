import 'package:flutter/material.dart';
import 'package:food_app/bergerpage.dart';
import 'package:food_app/drinkpage.dart';
import 'package:food_app/pizzapage.dart' as pizza;
import 'package:food_app/homepage.dart';

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

  // Updated list of titles including the new "Settings" option
  final List<String> pageTitles = const ['Food Menu', 'Drinks', 'Burgers', 'Pizza', 'Settings'];

  // Updated list of pages to match the new button
  final List<Widget> pages = const [
    HomePage(),
    DrinkPage(title: 'Drinks Page'),
    Bergerpage(title: 'Burgers Page'),
    pizza.PizzaPage(title: 'Pizza Page'),
    // Placeholder for the new Settings page
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 100, color: Colors.orange),
          Text('Settings Page', style: TextStyle(fontSize: 24)),
        ],
      ),
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[selectedIndex]), centerTitle: true, elevation: 2),

      body: isDesktop
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: Colors.orange),
                  selectedLabelTextStyle: const TextStyle(color: Colors.orange),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.local_drink), label: Text('Drinks')),
                    NavigationRailDestination(icon: Icon(Icons.lunch_dining), label: Text('Burgers')),
                    NavigationRailDestination(icon: Icon(Icons.local_pizza), label: Text('Pizza')),
                    NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: pages[selectedIndex]),
              ],
            )
          : pages[selectedIndex],

      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
              // Fixed type ensures all 5 icons and labels are visible simultaneously
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: "Drinks"),
                BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: "Burgers"),
                BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: "Pizza"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
              ],
            ),
    );
  }
}
