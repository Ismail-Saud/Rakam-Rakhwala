import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DeletePage extends StatelessWidget {
  const DeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeleteEntriesScreen(); 
  }
}


class DeleteEntriesScreen extends StatelessWidget {
  const DeleteEntriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE5D8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF321B15),
        title: Center(
          child: const Text(
            'Delete Income or Expense',
            style: TextStyle(
              color: Color.fromARGB(255, 221, 214, 199),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: const DeleteEntriesBody(),
    );
  }
}

class DeleteEntriesBody extends StatefulWidget {
  const DeleteEntriesBody({super.key});

  @override
  State<DeleteEntriesBody> createState() => _DeleteEntriesBodyState();
}

class _DeleteEntriesBodyState extends State<DeleteEntriesBody> {
  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    fetchRecentTransactions();
  }

  Future<void> fetchRecentTransactions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      debugPrint("No user is logged in");
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      recentTransactions = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: recentTransactions.length,
            itemBuilder: (context, index) {
              final txn = recentTransactions[index];
              final amount = (txn['amount'] ?? 0).toDouble();
              final isIncome = amount >= 0;
              final category = txn['category'] ?? "Unknown";
          
              return Card(
                color: Color.fromARGB(255, 241, 237, 226),
                child: ListTile(
                  title: Text(category),
                  subtitle: Text(
                    "Rs $amount",
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final docId = txn['id'];
                      final uid = FirebaseAuth.instance.currentUser?.uid;
          
                      if (uid == null || docId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Missing user ID or document ID"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
          
                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('transactions')
                            .doc(docId)
                            .delete();
          
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Transaction deleted"),
                            backgroundColor: Colors.green,
                          ),
                        );
          
                        fetchRecentTransactions(); // Refresh list
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            Navigator.pushNamed(context, "/homepage");
          },
          style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF321B15),
                  foregroundColor: Color(0XFFECE5D8),
                ),
          child: const Text("Back to Home"),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
