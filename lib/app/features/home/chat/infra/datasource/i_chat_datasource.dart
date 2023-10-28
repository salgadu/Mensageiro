import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';

abstract class IChatDatasource {
  Future<List<Chat>> getChats(String id);
  Future<List<Chat>> sendChat(String id, Chat chat);
}
