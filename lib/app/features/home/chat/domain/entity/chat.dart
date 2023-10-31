class Chat {
  final String? id;
  String message;
  final String timestamp;
  String userId;
  final String typeMessage;
  final String? audioUrl;

  Chat({
    this.id,
    this.message = '',
    required this.timestamp,
    this.userId = '',
    required this.typeMessage,
    this.audioUrl = '',
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "message": message,
        "timestamp": timestamp,
        "userId": userId,
        "typeMessage": typeMessage,
      };
}
