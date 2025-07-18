class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final String userId;
  final double amount;
  final String cardNumber;
  final bool? isAccepted;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.amount,
    required this.cardNumber,
    this.isAccepted,
  });
}
