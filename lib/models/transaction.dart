
class TransactionEntry {
  int? id;
  final double amount;
  final String category;
  final DateTime date;
  final String type;
  final String uid;

  TransactionEntry({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type,
      'uid': uid,
    };
  }

  factory TransactionEntry.fromMap(Map<String, dynamic> map) {
    return TransactionEntry(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      type: map['type'],
      uid: map['uid'],
    );
  }
}

