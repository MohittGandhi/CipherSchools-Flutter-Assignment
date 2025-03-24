// widgets/transaction_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionEntry> transactions;
  final Function onDelete;

  const TransactionList({
    Key? key,
    required this.transactions,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, index) {
        final tx = transactions[index];
        return Dismissible(
          key: ValueKey(tx.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onDelete(tx.id);
          },
          child: ListTile(
            title: Text(tx.category),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(tx.date.toLocal())),
            trailing: Text('${tx.type == 'expense' ? '-' : '+'}\₹${tx.amount.toStringAsFixed(2)}'),
          ),
        );
      },
    );
  }
}
