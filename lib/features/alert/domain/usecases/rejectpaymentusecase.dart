import 'package:bankapp3/features/alert/domain/repositories/paymentrepositories.dart';

class RejectPayment {
  final PaymentRepository repository;
  RejectPayment(this.repository);
  Future<void> execute(String userId, double amount, String cardNumber) {
    return repository.rejectPayment(userId, amount, cardNumber);
  }
}
