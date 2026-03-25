part of 'money_bloc.dart';

abstract class MoneyState {}

class MoneyInitial extends MoneyState {}

class MoneyEntryAdded extends MoneyState {}

class MoneyError extends MoneyState {
  final String message;
  MoneyError(this.message);
}
