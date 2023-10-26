import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';
import 'package:mensageiro/app/features/auth/auth_module.dart';
import 'package:mensageiro/app/features/home/home_module.dart';
import 'package:mensageiro/app/home_page.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(i) {
    i.addSingleton<AuthStore>(AuthStore.new);
    i.addInstance<FirebaseAuth>(FirebaseAuth.instance);
    i.addInstance<FirebaseFirestore>(FirebaseFirestore.instance);
  }
}

class AppModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: HomeModule());
  }
}
