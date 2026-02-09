// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatelessWidget {
  final String userId;
  const OrderHistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History"), backgroundColor: const Color(0xFF66B2C3)),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("collection_credential").doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || !snapshot.data!.exists) return const Center(child: Text("No history found."));

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List orders = data["orders"] ?? [];
          if (orders.isEmpty) return const Center(child: Text("No orders yet."));

          final reversedOrders = orders.reversed.toList();

          return ListView.builder(
            itemCount: reversedOrders.length,
            itemBuilder: (context, index) {
              final order = reversedOrders[index];
              // ដំណោះស្រាយ FIX Error: ប្រើ ?? [] ដើម្បីការពារ Null
              final List items = order["items"] ?? [];
              final timestamp = order["timestamp"] as Timestamp?;
              String date = timestamp != null
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate())
                  : "Unknown Date";

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ExpansionTile(
                  title: Text("Order #${reversedOrders.length - index} | Total: \$${order['total_bill'] ?? '0.00'}"),
                  subtitle: Text("Date: $date"),
                  trailing: const Text(
                    "Paid",
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  children: items.map((item) {
                    return ListTile(
                      title: Text(item["name"] ?? "Unknown"),
                      subtitle: Text("Size: ${item["size"]} x ${item["quantity"]}"),
                      trailing: Text("\$${(item["total"] ?? 0.0).toStringAsFixed(2)}"),
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
