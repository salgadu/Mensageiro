import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/features/auth/login/login_module.dart';
import 'package:mensageiro/features/auth/register/register_module.dart';

class AuthModule extends Module {
  @override
  void binds(i) {
    i.addInstance(FirebaseAuth.instance);
  }

  @override
  void routes(r) {
    r.module('/login/', module: LoginModule());
    r.module('/register/', module: RegisterModule());
  }
}
