import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensetracker/pages/graphpage.dart';

class ButtonatBottom extends StatefulWidget {
  const ButtonatBottom({super.key});

  @override
  State<ButtonatBottom> createState() => _ButtonatBottomState();
}

class _ButtonatBottomState extends State<ButtonatBottom> {
  Future<Map<String, dynamic>> fetchGraphData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return {};

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .get();

    double totalIncome = 0;
    double totalExpenses = 0;
    Map<String, double> categoryTotals = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] ?? 0).toDouble();
      final category = data['category'] ?? 'Unknown';

      if (amount > 0) {
        totalIncome += amount;
      } else {
        totalExpenses += amount;
      }

      categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
    }

    return {
      'income': totalIncome,
      'expenses': totalExpenses.abs(),
      'categories': categoryTotals,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/addie");
              },
              child: Text("Add Income or Expense"),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/delent");
              },
              child: Text("Delete Income or Expense"),
            ),
          ],
        ),
        SizedBox(height: 15),
        Divider(thickness: 2, color: Color(0XFF321B15)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid == null) return;
            
                final snapshot =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('transactions')
                        .get();
            
                Map<String, double> incomeTotals = {};
                Map<String, double> expenseTotals = {};
            
                for (var doc in snapshot.docs) {
                  final data = doc.data();
                  String category = data['category'] ?? 'Other';
                  double amount = (data['amount'] ?? 0).toDouble();
            
                  if (amount > 0) {
                    incomeTotals[category] = (incomeTotals[category] ?? 0) + amount;
                  } else {
                    expenseTotals[category] =
                        (expenseTotals[category] ?? 0) + amount.abs();
                  }
                }
            
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => GraphsPage(
                          incomeCategoryTotals: incomeTotals,
                          expenseCategoryTotals: expenseTotals,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF321B15),
                foregroundColor: const Color(0xFFECE5D8),
              ),
              child: const Text("View Bar Graph"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Divider(thickness: 2, color: Color(0XFF321B15)),
      ],
    );
  }
}
