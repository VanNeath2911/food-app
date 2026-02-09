import 'package:flutter/material.dart';
import 'package:food_app/cartprovider.dart';

class Bergerpage extends StatefulWidget {
  const Bergerpage({super.key, required this.title});
  final String title;

  @override
  State<Bergerpage> createState() => _BergerpageState();
}

class _BergerpageState extends State<Bergerpage> with AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => true;

  void _handleAddToCart(String name, String size, double price, String imagePath) {
    CartProvider().addItem(
      CartItem(
        id: '${name.replaceAll(' ', '_')}_$size',
        name: name,
        category: 'burger',
        size: size,
        price: price,
        imagePath: imagePath,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name ($size) added to cart!'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 102, 178, 195),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Text(
                "Burger Menu",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: 320,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return BurgerItemCard(
                  name: burgers[index]['name']!,
                  imagePath: burgers[index]['image']!,
                  onAddToCart: _handleAddToCart,
                );
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
  final Function(String, String, double, String) onAddToCart;

  const BurgerItemCard({super.key, required this.name, required this.imagePath, required this.onAddToCart});

  @override
  State<BurgerItemCard> createState() => _BurgerItemCardState();
}

class _BurgerItemCardState extends State<BurgerItemCard> {
  String selectedSize = 'S';
  final double basePrice = 6.50;
  final Map<String, double> priceAdjustments = {'S': 0.00, 'M': 2.00, 'L': 4.00};

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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSize,
                      isDense: true,
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
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onAddToCart(widget.name, selectedSize, totalPrice, widget.imagePath);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Add to Cart"),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
