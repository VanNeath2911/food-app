import 'package:flutter/material.dart';
import 'package:food_app/provider/cartprovider.dart';

class PizzaPage extends StatefulWidget {
  const PizzaPage({super.key, required this.title});
  final String title;

  @override
  State<PizzaPage> createState() => _PizzaPageState();
}

class _PizzaPageState extends State<PizzaPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, String>> pizzas = const [
    {'name': 'Personal Pepperoni Pizza', 'image': 'assets/pizza/ISPizza.png'},
    {'name': 'Margherita Pizza', 'image': 'assets/pizza/pizza.png'},
    {'name': 'Pizza Bianca', 'image': 'assets/pizza/pizza3.png'},
    {'name': 'Garden Veggie Pizza', 'image': 'assets/pizza/pizza4.png'},
    {'name': 'Quattro Formaggi Pizza', 'image': 'assets/pizza/pizza5.png'},
    {'name': 'Deluxe pizza', 'image': 'assets/pizza/pizza6.png'},
    {'name': 'Vegetarian Pizza', 'image': 'assets/pizza/pizza7.png'},
  ];

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
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                "Pizza Menu",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
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
                      childAspectRatio: 0.72,
                    ),
                    itemCount: pizzas.length,
                    itemBuilder: (context, index) {
                      return PizzaItemCard(name: pizzas[index]['name']!, imagePath: pizzas[index]['image']!);
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

class PizzaItemCard extends StatefulWidget {
  final String name;
  final String imagePath;
  const PizzaItemCard({super.key, required this.name, required this.imagePath});

  @override
  State<PizzaItemCard> createState() => _PizzaItemCardState();
}

class _PizzaItemCardState extends State<PizzaItemCard> {
  String selectedSize = 'S';
  final double basePrice = 8.50;
  final Map<String, double> priceAdjustments = {'S': 0.00, 'M': 3.50, 'L': 6.00};

  @override
  Widget build(BuildContext context) {
    final double totalPrice = basePrice + priceAdjustments[selectedSize]!;

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(widget.imagePath, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFF3F3F9), borderRadius: BorderRadius.circular(20)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSize,
                      isDense: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                      onChanged: (val) => setState(() => selectedSize = val!),
                      items: ['S', 'M', 'L'].map((s) => DropdownMenuItem(value: s, child: Text("Size $s"))).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  CartProvider().addItem(
                    CartItem(
                      id: '${widget.name.replaceAll(' ', '_')}_$selectedSize',
                      name: widget.name,
                      category: 'pizza',
                      size: selectedSize,
                      price: totalPrice,
                      imagePath: widget.imagePath,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.name} ($selectedSize) added!'),
                      backgroundColor: Colors.black,
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                label: const Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
