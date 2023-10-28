import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/features/home/chat/presenter/pages/chat_screen.dart';

class ChatModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => ChatPage(controller: Modular.get()));
  }
}
