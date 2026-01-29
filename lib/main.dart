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
      home: const MyHomePage(title: 'Food Menu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(title: 'Home'),
    DrinkPage(title: 'Drinks Page'),
    Bergerpage(title: 'Burgers Page'),
    pizza.PizzaPage(title: 'Pizza Page'),
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
      appBar: AppBar(
        title: Text(pages[selectedIndex] is HomePage ? 'Food Menu' : (pages[selectedIndex] as dynamic).title),
        centerTitle: true,
      ),

      body: isDesktop
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.local_drink), label: Text('Drinks')),
                    NavigationRailDestination(icon: Icon(Icons.lunch_dining), label: Text('Burgers')),
                    NavigationRailDestination(icon: Icon(Icons.local_pizza), label: Text('Pizza')),
                  ],
                ),
                const VerticalDivider(width: 1),
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
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: "Drinks"),
                BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: "Burgers"),
                BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: "Pizza"),
              ],
            ),
    );
  }
}
