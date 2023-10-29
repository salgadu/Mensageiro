import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensageiro/app/core/utils/rash_id.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/infra/datasource/i_chat_datasource.dart';
import 'package:mensageiro/app/features/home/chat/infra/model/chat_model.dart';

class FirebaseDatasourceChats implements IChatDatasource {
  final FirebaseFirestore firestore;

  FirebaseDatasourceChats(this.firestore);

  @override
  Stream<List<ChatModel>> getMessages(String id) {
    return firestore
        .collection('chats')
        .doc(id.calculateHash())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ChatModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  @override
  Future<void> sendChat(String id, Chat chat) async {
    try {
      await firestore
          .collection('chats')
          .doc(id.calculateHash())
          .collection('messages')
          .add({
        'message': chat.message,
        'timestamp': chat.timestamp,
        'userId': chat.userId,
      });
    } catch (e) {
      print("Erro ao adicionar mensagem: $e");
      throw Exception("Erro ao adicionar mensagem");
    }
  }
}
