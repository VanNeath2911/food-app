import 'package:flutter/material.dart';

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
      // Added SingleChildScrollView so the Header and Grid scroll together
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- NEW: Drinks Menu Title (Scrolls with the grid) ---
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Text(
                "Drinks Menu",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
              ),
            ),

            // --- YOUR ORIGINAL FEATURE (LayoutBuilder & GridView) ---
            LayoutBuilder(
              builder: (context, constraints) {
                final int crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    // These two lines are added so the Grid doesn't conflict with the ScrollView
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    cacheExtent: 800,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: constraints.maxWidth > 900 ? 0.78 : 0.65,
                    ),
                    itemCount: drinks.length,
                    itemBuilder: (context, index) {
                      final drink = drinks[index];
                      return DrinkItemCard(name: drink['name']!, imagePath: drink['image']!);
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

// --- YOUR ORIGINAL DrinkItemCard (UNTOUCHED) ---
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            /// Drink Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.low,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.local_drink_rounded, size: 55, color: Colors.deepPurple.withOpacity(0.25));
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Drink Name
            Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            /// Size Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSize,
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.deepPurple),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  onChanged: (String? newValue) {
                    if (newValue == null) return;
                    setState(() => selectedSize = newValue);
                  },
                  items: const ['S', 'M', 'L']
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text("Size $value", style: const TextStyle(fontSize: 13)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// Price
            Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Color(0xFF2E7D32)),
            ),

            const SizedBox(height: 12),

            /// Add Button
            SizedBox(
              width: double.infinity,
              height: 40,
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
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                label: const Text("Add"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
