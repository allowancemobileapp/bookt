part of 'money_bloc.dart';

abstract class MoneyEvent {}

class AddMoneyEntry extends MoneyEvent {
  final double amount;
  final String reason;
  final String userId;
  final bool isCredit;
  final String? details; // optional

  AddMoneyEntry({
    required this.amount,
    required this.reason,
    required this.userId,
    required this.isCredit,
    this.details,
  });
}
