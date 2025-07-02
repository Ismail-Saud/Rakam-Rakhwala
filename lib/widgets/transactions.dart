import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ShowTransactions extends StatefulWidget {
  const ShowTransactions({super.key});

  @override
  State<ShowTransactions> createState() => _ShowTransactionsState();
}

class _ShowTransactionsState extends State<ShowTransactions> {
  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    fetchRecentTransactions();
  }

  Future<void> fetchRecentTransactions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .orderBy('timestamp', descending: true)
            .limit(5)
            .get();

    setState(() {
      recentTransactions = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Recent Transactions:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        if (recentTransactions.isEmpty)
          const Text("No transactions found.")
        else
          Column(
            children:
                recentTransactions.map((txn) {
                  final amount = (txn['amount'] ?? 0).toDouble();
                  final isIncome = amount >= 0;
                  final category = txn['category'] ?? "Unknown";

                  return ListTile(
                    title: Text("$category", style: TextStyle(fontSize: 16)),
                    trailing: Text(
                      "Rs $amount",
                      style: TextStyle(
                        fontSize: 16,
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
          ),
        SizedBox(height: 10),
        Divider(thickness: 2, color: Color(0XFF321B15)),
        SizedBox(height: 10),
      ],
    );
  }
}

