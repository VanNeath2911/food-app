import 'package:flutter/material.dart';
import 'package:food_app/cartprovider.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({super.key, required this.title});
  final String title;
  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> with AutomaticKeepAliveClientMixin {
  final List<Map<String, String>> drinks = const [
    {'name': 'Brown Sugar', 'image': 'assets/drinks/brownsugar.png'},
    {'name': 'Coke', 'image': 'assets/drinks/coke.png'},
    {'name': 'Iced Cappuccino', 'image': 'assets/drinks/icedcappuccino.png'},
    {'name': 'Coffee', 'image': 'assets/drinks/coffee.png'},
    {'name': 'Matcha', 'image': 'assets/drinks/matcha.png'},
    {'name': 'Passion Cream', 'image': 'assets/drinks/passioncream.png'},
    {'name': 'Water', 'image': 'assets/drinks/water.png'},
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFF66B2C3),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Text(
                "Drinks Menu",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final int crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: constraints.maxWidth > 900 ? 0.78 : 0.65,
                    ),
                    itemCount: drinks.length,
                    itemBuilder: (context, index) {
                      return DrinkItemCard(name: drinks[index]['name']!, imagePath: drinks[index]['image']!);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrinkItemCard extends StatefulWidget {
  final String name;
  final String imagePath;
  const DrinkItemCard({super.key, required this.name, required this.imagePath});
  @override
  State<DrinkItemCard> createState() => _DrinkItemCardState();
}

class _DrinkItemCardState extends State<DrinkItemCard> {
  String selectedSize = 'S';
  static const double basePrice = 2.00;
  static const Map<String, double> priceAdjustments = {'S': 0.00, 'M': 0.75, 'L': 1.50};

  @override
  Widget build(BuildContext context) {
    final double totalPrice = basePrice + priceAdjustments[selectedSize]!;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(child: Image.asset(widget.imagePath, fit: BoxFit.contain)),
          Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          DropdownButton<String>(
            value: selectedSize,
            onChanged: (newValue) => setState(() => selectedSize = newValue!),
            items: ['S', 'M', 'L'].map((v) => DropdownMenuItem(value: v, child: Text("Size $v"))).toList(),
          ),
          Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 19, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: () {
              CartProvider().addItem(
                CartItem(
                  id: '${widget.name}_$selectedSize',
                  name: widget.name,
                  category: 'drink',
                  size: selectedSize,
                  price: totalPrice,
                  imagePath: widget.imagePath,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.name} added!")));
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text("Add"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
