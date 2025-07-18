import 'package:bankapp3/features/alert/domain/entities/notificationentity.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String userId;
  final double amount;
  final String cardNumber;
  final bool? isAccepted;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.amount,
    required this.cardNumber,
    this.isAccepted,
  });

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      userId: entity.userId,
      amount: entity.amount,
      cardNumber: entity.cardNumber,
      isAccepted: entity.isAccepted,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      userId: userId,
      amount: amount,
      cardNumber: cardNumber,
      isAccepted: isAccepted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'amount': amount,
      'cardNumber': cardNumber,
      'isAccepted': isAccepted == null ? null : (isAccepted! ? 1 : 0),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      userId: map['userId'],
      amount: map['amount'],
      cardNumber: map['cardNumber'],
      isAccepted: map['isAccepted'] == null ? null : map['isAccepted'] == 1,
    );
  }
}
