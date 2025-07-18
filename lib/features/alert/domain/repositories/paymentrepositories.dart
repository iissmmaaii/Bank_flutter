abstract class PaymentRepository {
  Future<void> approvePayment(String userId, double amount, String cardNumber);
  Future<void> rejectPayment(String userId, double amount, String cardNumber);
}
