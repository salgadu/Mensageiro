import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/core/core_module.dart';
import 'package:mensageiro/app/core/pages/splash_screen/splash_screen.dart';
import 'package:mensageiro/app/features/auth/auth_module.dart';
<<<<<<< HEAD
import 'package:mensageiro/app/features/home/chat/chat_module.dart';
=======
import 'package:mensageiro/app/features/home/chat/infra/chat_module.dart';
>>>>>>> c5a558980a008bcb7a7b058b5b9dbc63dd64403b
import 'package:mensageiro/app/features/home/home_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void routes(r) {
    r.child('/', child: (context) => const SplashScreen());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: HomeModule());
  }
}
