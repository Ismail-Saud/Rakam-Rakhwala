// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expensetracker/pages/addinex.dart';
// import 'package:expensetracker/pages/deleteentries.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/widgets/transactions.dart';
import 'package:expensetracker/widgets/buttonsattop.dart';
import 'package:expensetracker/widgets/buttonsatbottom.dart';
// import 'package:expensetracker/pages/graphpage.dart';
// import 'package:expensetracker/pages/settings.dart';
// import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF321B15),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'E-Khata App',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 221, 214, 199),
              ),
            ),
            Image.asset("2.png", width: 70),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [IncomeorExpenseButtons(), ShowTransactions(), ButtonatBottom(),]),
      ),
    );
  }
}


// class BottomNavPage extends StatefulWidget {
//   @override
//   _BottomNavPageState createState() => _BottomNavPageState();
// }

// class _BottomNavPageState extends State<BottomNavPage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     HomePage(),     // 0
//     DeleteEntriesScreen(),   // 1
//     AddIncomeExpense(),      // 2
//     Placeholder(),    // 3
//     SettingsScreen(), // 4
//   ];

//  void _onTap(int index) async {
//   if (index == 3) {
//     // Graph tab tapped – fetch Firestore data and navigate
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     final snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('transactions')
//         .get();

//     Map<String, double> incomeTotals = {};
//     Map<String, double> expenseTotals = {};

//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       String category = data['category'] ?? 'Other';
//       double amount = (data['amount'] ?? 0).toDouble();

//       if (amount > 0) {
//         incomeTotals[category] = (incomeTotals[category] ?? 0) + amount;
//       } else {
//         expenseTotals[category] =
//             (expenseTotals[category] ?? 0) + amount.abs();
//       }
//     }

//     // Navigate to GraphsPage with parameters
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => GraphsPage(
//           incomeCategoryTotals: incomeTotals,
//           expenseCategoryTotals: expenseTotals,
//         ),
//       ),
//     );
//     } else {
//       // For other tabs, just switch the screen
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }


//   // Bottom nav item builder
//   BottomNavigationBarItem buildItem(IconData icon, String label) {
//     return BottomNavigationBarItem(
//       icon: Icon(icon),
//       label: label,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed, // Must be fixed for 5+ items
//         currentIndex: _selectedIndex,
//         onTap: _onTap,
//         selectedItemColor: Colors.deepPurple,
//         unselectedItemColor: Colors.grey,
//         items: [
//           buildItem(Icons.home, 'Home'),
//           buildItem(Icons.delete, 'Delete'),
//           buildItem(Icons.add_circle, 'Add'),
//           buildItem(Icons.bar_chart, 'Graph'),
//           buildItem(Icons.settings, 'Settings'),
//         ],
//       ),
//     );
//   }
// }