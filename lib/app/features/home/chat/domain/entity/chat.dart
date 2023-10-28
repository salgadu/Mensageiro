class Chat {
  final String id;
  final String message;
  final String timestamp;
  final String userId;

  Chat({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "message": message,
        "timestamp": timestamp,
        "userId": userId,
      };
}