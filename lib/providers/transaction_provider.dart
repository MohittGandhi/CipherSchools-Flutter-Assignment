
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart';
import '../services/db_helper.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionEntry> _transactions = [];

  List<TransactionEntry> get transactions => _transactions;

  Future<void> fetchTransactions() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _transactions = await DBHelper.getTransactions(uid);
      notifyListeners();
    }
  }

  // Add a new transaction for the current user.
  Future<void> addTransaction(TransactionEntry entry) async {
    await DBHelper.insertTransaction(entry);
    await fetchTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DBHelper.deleteTransaction(id);
    await fetchTransactions();
  }
}
