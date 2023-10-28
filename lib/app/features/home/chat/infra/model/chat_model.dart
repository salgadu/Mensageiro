import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required super.id,
    required super.message,
    required super.timestamp,
    required super.userId,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      message: map['message'],
      timestamp: map['timestamp'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp,
      'userId': userId,
    };
  }
}
