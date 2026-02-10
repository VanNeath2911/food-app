// ignore_for_file: use_super_parameters
import 'package:flutter/material.dart';
import 'package:food_app/bergerpage.dart';
import 'package:food_app/drinkpage.dart';
import 'package:food_app/homepage.dart';
import 'package:food_app/orderhistory.dart';
import 'package:food_app/pizzapage.dart';
import 'package:food_app/accountpage.dart';
import 'package:food_app/cartpage.dart';

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

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const DrinkPage(title: 'Drinks'),
      const Bergerpage(title: 'Burgers'),
      const PizzaPage(title: 'Pizzas'),
      // បញ្ជូន Username និង Password ទៅ CartPage ដើម្បីរក្សាទុកក្នុង Doc តែមួយ
      CartPage(userId: widget.userId, password: widget.password),
      OrderHistoryPage(userId: widget.userId),
      AccountPage(userId: widget.userId),
    ];
  }

  void _onItemTapped(int index) {
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
