import 'package:flutter/material.dart';

class Bergerpage extends StatefulWidget {
  const Bergerpage({super.key, required this.title});
  final String title;

  @override
  State<Bergerpage> createState() => _BergerpageState();
}

class _BergerpageState extends State<Bergerpage> {
  final List<Map<String, String>> burgers = [
    {'name': 'The Classic Cheeseburger', 'image': 'assets/burger/berger.png'},
    {'name': 'Bacon Barbecue Burger', 'image': 'assets/burger/baconbarbecue.png'},
    {'name': 'Breakfast Bap', 'image': 'assets/burger/breakfastbap.png'},
    {'name': 'Double Smash Burger', 'image': 'assets/burger/doublesmash.png'},
    {'name': 'Mushroom Swiss Burger', 'image': 'assets/burger/mushroomswiss.png'},
    {'name': 'Spicy Zinger Burger', 'image': 'assets/burger/spicyzinger.png'},
    {'name': 'The Hawaiian Burger', 'image': 'assets/burger/theawaiian.png'},
    {'name': 'Truffle Deluxe Burger', 'image': 'assets/burger/truffledeluxe.png'},
    {'name': 'Wagyu Beef Burger', 'image': 'assets/burger/wagyubeef.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 102, 178, 195),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Text("Burger Menu", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: 320, // keep your card height
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = burgers[index];
                return BurgerItemCard(name: item['name'] ?? '', imagePath: item['image'] ?? '');
              }, childCount: burgers.length),
            ),
          ),
        ],
      ),
    );
  }
}

class BurgerItemCard extends StatefulWidget {
  final String name;
  final String imagePath;

  const BurgerItemCard({super.key, required this.name, required this.imagePath});

  @override
  State<BurgerItemCard> createState() => _BurgerItemCardState();
}

class _BurgerItemCardState extends State<BurgerItemCard> {
  String selectedSize = 'S';

  final double basePrice = 5.50;
  final Map<String, double> priceAdjustments = {'S': 0.00, 'M': 2.00, 'L': 4.50};

  @override
  Widget build(BuildContext context) {
    final double totalPrice = basePrice + (priceAdjustments[selectedSize] ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                  cacheWidth: 300, // smoother scrolling
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.lunch_dining_rounded, size: 60, color: Colors.orange.withOpacity(0.3)),
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

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSize,
                  isDense: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    if (newValue == null) return;
                    setState(() => selectedSize = newValue);
                  },
                  items: ['S', 'M', 'L']
                      .map(
                        (size) => DropdownMenuItem(
                          value: size,
                          child: Text("Size $size", style: const TextStyle(fontSize: 13)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 46, 125, 50),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.name} ($selectedSize) added to cart!'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
