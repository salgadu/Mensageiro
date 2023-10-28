import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/features/home/chat/external/datasource/firebase_datsource_chats.dart';
import 'package:mensageiro/app/features/home/chat/infra/datasource/i_chat_datasource.dart';

class ChatModule extends Module {
  @override
  void binds(i) {
    i.add<IChatDatasource>(FirebaseDatasourceChats.new);
  }

  @override
  void routes(r) {
    r.module('/chat', module: ChatModule());
  }
}
