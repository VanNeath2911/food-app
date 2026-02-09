import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("users_orders").doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("មិនមានប្រវត្តិ"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List orders = data["orders"] ?? [];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final order = orders[i];
              final items = order["items"] as List;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  title: Text("Order ${i + 1}  |  \$${order['total_price']}"),
                  subtitle: const Text("ចុចដើម្បីមើលលម្អិត"),
                  children: items.map((item) {
                    return ListTile(
                      title: Text(item["name"]),
                      subtitle: Text("Size: ${item["size"]} x${item["quantity"]}"),
                      trailing: Text("\$${item["price"]}"),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
