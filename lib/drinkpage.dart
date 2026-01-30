// ignore_for_file: camel_case_types, deprecated_member_use

import 'package:flutter/material.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({super.key, required this.title});
  final String title;

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  final List<Map<String, String>> drinks = [
    {'name': 'Brown Sugar', 'image': 'assets/drinks/brownsugar.png'},
    {'name': 'Coke', 'image': 'assets/drinks/coke.png'},
    {'name': 'Iced Cappuccino', 'image': 'assets/drinks/icedcappuccino.png'},
    {'name': 'Coffee', 'image': 'assets/drinks/coffee.png'},
    {'name': 'Matcha', 'image': 'assets/drinks/matcha.png'},
    {'name': 'Passion Cream', 'image': 'assets/drinks/passioncream.png'},
    {'name': 'Water', 'image': 'assets/drinks/water.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 102, 178, 195),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      // Adjusting aspect ratio slightly for desktop to keep cards looking good
                      childAspectRatio: constraints.maxWidth > 900 ? 0.75 : 0.62,
                    ),
                    itemCount: drinks.length,
                    itemBuilder: (context, index) {
                      return DrinkItemCard(name: drinks[index]['name']!, imagePath: drinks[index]['image']!);
                    },
                  ),
                ),
              ],
            ),
          );
        },
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
  final double basePrice = 2.00;
  final Map<String, double> priceAdjustments = {'S': 0.00, 'M': 0.75, 'L': 1.50};

  @override
  Widget build(BuildContext context) {
    double totalPrice = basePrice + priceAdjustments[selectedSize]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Image section
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.local_drink_rounded, size: 50, color: Colors.deepPurple.withOpacity(0.3));
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Size Choice Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSize,
                  isDense: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSize = newValue!;
                    });
                  },
                  items: ['S', 'M', 'L'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text("Size $value", style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Price Tag
            Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 46, 125, 50),
              ),
            ),

            const SizedBox(height: 10),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.name} ($selectedSize) added!'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text("Add"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
