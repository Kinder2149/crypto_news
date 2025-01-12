import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String symbol;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final double quantity;

  @HiveField(5)
  final String orderType;

  @HiveField(6)
  final DateTime date;

  Transaction({
    required this.name,
    required this.symbol,
    required this.price,
    required this.amount,
    required this.quantity,
    required this.orderType,
    required this.date,
  });
}