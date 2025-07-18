// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bankapp3/features/alert/domain/repositories/paymentrepositories.dart';

class Approvepaymentusecase {
  PaymentRepository paymentRepository;
  Approvepaymentusecase({required this.paymentRepository});
  Future<void> execute(String userId, double amount, String cardNumber) {
    return paymentRepository.approvePayment(userId, amount, cardNumber);
  }
}
