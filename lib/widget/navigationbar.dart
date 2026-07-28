// ignore_for_file: use_super_parameters
import 'package:flutter/material.dart';
import 'package:food_app/food/bergerpage.dart';
import 'package:food_app/food/drinkpage.dart';
import 'package:food_app/home/homepage.dart';
import 'package:food_app/history/orderhistory.dart';
import 'package:food_app/food/pizzapage.dart';
import 'package:food_app/auth/accountpage.dart';
import 'package:food_app/food/cartpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  final String userId;
  final String password;
  const MainPage({Key? key, required this.userId, required this.password}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // បញ្ជីទំព័រដែលត្រូវបង្ហាញតាម Tabs
  late final List<Widget> _pages;

  Future<void> _loadSelectedPage() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _selectedIndex = prefs.getInt("selectedIndex") ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();

    _pages = [
      const HomePage(),
      const DrinkPage(title: 'Drinks'),
      const Bergerpage(title: 'Burgers'),
      const PizzaPage(title: 'Pizzas'),
      CartPage(userId: widget.userId, password: widget.password),
      OrderHistoryPage(userId: widget.userId),
      AccountPage(userId: widget.userId),
    ];
    _loadSelectedPage();
  }

  Future<void> _onItemTapped(int index) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("selectedIndex", index);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF66B2C3),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: 'Drinks'),
          BottomNavigationBarItem(icon: Icon(Icons.lunch_dining), label: 'Burgers'),
          BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: 'Pizzas'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
