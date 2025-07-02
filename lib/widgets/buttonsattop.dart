import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IncomeorExpenseButtons extends StatefulWidget {
  const IncomeorExpenseButtons({super.key});

  @override
  State<IncomeorExpenseButtons> createState() => _IncomeorExpenseButtonsState();
}

class _IncomeorExpenseButtonsState extends State<IncomeorExpenseButtons> {
  double income = 0;
  double expenses = 0;
  double balance = 0;

  bool showTotals = false;

  @override
  void initState() {
    super.initState();
    fetchMonthlyTotals();
  }

  Future<void> fetchMonthlyTotals() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .where('timestamp', isGreaterThanOrEqualTo: firstDayOfMonth)
            .get();

    double totalIncome = 0;
    double totalExpenses = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      double amount = (data['amount'] ?? 0).toDouble();
      if (amount > 0) {
        totalIncome += amount;
      } else {
        totalExpenses += amount;
      }
    }

    setState(() {
      income = totalIncome;
      expenses = totalExpenses.abs();
      balance = totalIncome + totalExpenses;
      showTotals = true; // trigger UI update
    });
  }

  Future<void> fetchAlltimeTotals() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .get();

    double totalIncome = 0;
    double totalExpenses = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      double amount = (data['amount'] ?? 0).toDouble();
      if (amount > 0) {
        totalIncome += amount;
      } else {
        totalExpenses += amount;
      }
    }

    setState(() {
      income = totalIncome;
      expenses = totalExpenses.abs();
      balance = totalIncome + totalExpenses;
      showTotals = true;
    });
  }

  int selectedIndex = 0;

  void changeState(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  fetchMonthlyTotals();
                  changeState(0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndex == 0
                          ? Color(0XFF321B15)
                          : Color(0XFFECE5D8),
                  foregroundColor:
                      selectedIndex == 0
                          ? Color(0XFFECE5D8)
                          : Color(0XFF321B15),
                ),
                child: Text("This Month"),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchAlltimeTotals();
                  changeState(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndex == 1
                          ? Color(0XFF321B15)
                          : Color(0XFFECE5D8),
                  foregroundColor:
                      selectedIndex == 1
                          ? Color(0XFFECE5D8)
                          : Color(0XFF321B15),
                ),
                child: Text("All Time"),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(thickness: 2, color: Color(0XFF321B15)),
          SizedBox(height: 10),
          if (showTotals)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Income: Rs $income",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Expenses: Rs $expenses",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Balance: Rs $balance",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          SizedBox(height: 10),
          Divider(thickness: 2, color: Color(0XFF321B15)),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
