import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/features/home/contact/contatcts_module.dart';

class HomeModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module('/contacts', module: ContatctsModule());
  }
}
