import 'package:flutter_modular/flutter_modular.dart';

class ChatModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module('/chat', module: ChatModule());
  }
}
