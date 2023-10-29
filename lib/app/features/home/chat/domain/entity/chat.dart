class Chat {
  final String? id;
  final String message;
  final String timestamp;
  String userId;
  final String typeMessage;

  Chat({
    this.id,
    required this.message,
    required this.timestamp,
    this.userId = '',
    required this.typeMessage,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "message": message,
        "timestamp": timestamp,
        "userId": userId,
        "typeMessage": typeMessage
      };
}
