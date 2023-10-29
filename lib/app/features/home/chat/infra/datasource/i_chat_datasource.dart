import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';

abstract class IChatDatasource {
  Stream<List<Chat>> getMessages(String id);
  Future<void> sendChat(String id, Chat chat);
}
