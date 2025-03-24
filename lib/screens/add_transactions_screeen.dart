import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final ValueNotifier<String> typeNotifier = ValueNotifier<String>('expense');
  final ValueNotifier<DateTime> dateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddTransactionScreen({Key? key}) : super(key: key);

  void _submitData(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final double amount = double.parse(amountController.text);
    final String category = categoryController.text;
    final String type = typeNotifier.value;
    final DateTime selectedDate = dateNotifier.value;

    // Get the current user id.
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final newTransaction = TransactionEntry(
      amount: amount,
      category: category,
      date: selectedDate,
      type: type,
      uid: uid,
    );

    Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(newTransaction);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || double.tryParse(val) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              ValueListenableBuilder<String>(
                valueListenable: typeNotifier,
                builder: (context, currentType, child) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Type'),
                    value: currentType,
                    items: [
                      DropdownMenuItem(
                        child: Text('Expense'),
                        value: 'expense',
                      ),
                      DropdownMenuItem(
                        child: Text('Income'),
                        value: 'income',
                      ),
                    ],
                    onChanged: (String? newVal) {
                      if (newVal != null) {
                        typeNotifier.value = newVal;
                      }
                    },
                  );
                },
              ),
              ValueListenableBuilder<DateTime>(
                valueListenable: dateNotifier,
                builder: (context, selectedDate, child) {
                  return ListTile(
                    title: Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        dateNotifier.value = pickedDate;
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Transaction'),
                onPressed: () => _submitData(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

