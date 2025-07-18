import 'package:bankapp3/features/alert/data/datasource/paymentremotedatasource.dart';
import 'package:bankapp3/features/alert/domain/repositories/paymentrepositories.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final Paymetremotedatasource remote;
  PaymentRepositoryImpl(this.remote);

  @override
  Future<void> approvePayment(String userId, double amount, String cardNumber) {
    return remote.approve(userId, amount, cardNumber);
  }

  @override
  Future<void> rejectPayment(String userId, double amount, String cardNumber) {
    return remote.reject(userId, amount, cardNumber);
  }
}
