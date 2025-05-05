class Transaction {
  final String id;
  final String title;
  final String amount;
  final String type; // "income" or "expense"
  final String date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> jsonData) {
    return Transaction(
      id: jsonData['id'],
      title: jsonData['title'],
      amount: jsonData['amount'],
      type: jsonData['type'],
      date: jsonData['currentDate'],
    );
  }
}
