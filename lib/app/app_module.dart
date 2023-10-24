import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';
import 'package:mensageiro/app/features/auth/auth_module.dart';
import 'package:mensageiro/app/features/home/contact/contatcts_module.dart';
import 'package:mensageiro/app/home_page.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addInstance(AuthStore());
    i.addInstance(FirebaseAuth.instance);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: ContatctsModule());
  }
}
