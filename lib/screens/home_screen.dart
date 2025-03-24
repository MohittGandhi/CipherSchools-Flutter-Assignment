// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/bar_chart.dart';
import '../widgets/transaction_list.dart';
import '../services/auth_service.dart';
import 'add_transactions_screeen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          // Aggregate data for summary.
          double totalIncome = transactionProvider.transactions
              .where((tx) => tx.type == 'income')
              .fold(0.0, (sum, tx) => sum + tx.amount);
          double totalExpense = transactionProvider.transactions
              .where((tx) => tx.type == 'expense')
              .fold(0.0, (sum, tx) => sum + tx.amount);
          double activeBalance = totalIncome - totalExpense;

          final Map<String, double> incomeData = {};
          final Map<String, double> expenseData = {};

          for (var tx in transactionProvider.transactions) {
            if (tx.type == 'income') {
              incomeData.update(tx.category, (value) => value + tx.amount,
                  ifAbsent: () => tx.amount);
            } else if (tx.type == 'expense') {
              expenseData.update(tx.category, (value) => value + tx.amount,
                  ifAbsent: () => tx.amount);
            }
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Active Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\₹${activeBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        color: activeBalance >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Income and Expense Summary.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Income',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('\₹${totalIncome.toStringAsFixed(2)}'),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Expenses',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('\₹${totalExpense.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 300,
                child: IncomeExpenseBarChart(
                  incomeData: incomeData,
                  expenseData: expenseData,
                ),
              ),
              // Transaction list.
              Expanded(
                child: TransactionList(
                  transactions: transactionProvider.transactions,
                  onDelete: (int id) {
                    transactionProvider.deleteTransaction(id);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AddTransactionScreen()));
        },
      ),
    );
  }
}

