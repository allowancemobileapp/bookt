import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'money_event.dart';
part 'money_state.dart';

class MoneyBloc extends Bloc<MoneyEvent, MoneyState> {
  MoneyBloc() : super(MoneyInitial()) {
    on<AddMoneyEntry>((event, emit) async {
      try {
        await FirebaseFirestore.instance.collection('money').add({
          'amount': event.amount,
          'reason': event.reason,
          'timestamp': DateTime.now(),
          'userId': event.userId,
          'isCredit': event.isCredit, // optional
          'details': event.details, // optional
        });
        emit(MoneyEntryAdded());
      } catch (e) {
        emit(MoneyError(e.toString()));
      }
    });
  }
}
