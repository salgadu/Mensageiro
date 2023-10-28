import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/infra/datasource/i_chat_datasource.dart';
import 'package:mensageiro/app/features/home/chat/infra/model/chat_model.dart';

class FirebaseDatasourceChats implements IChatDatasource {
  final FirebaseFirestore firestore;

  FirebaseDatasourceChats(this.firestore);

  @override
  Future<List<ChatModel>> getChats(String id) async {
    final chats = await firestore.collection('chats').get();
    return chats.docs.map((e) => ChatModel.fromMap(e.data())).toList();
  }

  @override
  Future<List<Chat>> sendChat(String id, Chat chat) async {
    try {
      await firestore.collection('chats').doc(id).update({
        'messages': FieldValue.arrayUnion([chat.toMap()])
      });
      return getChats(id);
    } catch (e) {
      throw Exception();
    }  
  }
}