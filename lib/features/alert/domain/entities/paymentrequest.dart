class PaymentRequest {
  final String userId;
  final double amount;
  final String cardNumber;

  PaymentRequest({
    required this.userId,
    required this.amount,
    required this.cardNumber,
  });
}
