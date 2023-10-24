import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:mensageiro/app_widget.dart';
import 'package:mensageiro/features/auth/auth_module.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

class AppModule extends Module {
  @override
  void binds(i) {
    i.addInstance(FirebaseAuth.instance);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
    r.module('/auth', module: AuthModule());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => Modular.to.navigate('/auth/login'),
                child: const Text('Login')),
            ElevatedButton(
              onPressed: () => Modular.to.navigate('/auth/register'),
              child: const Text('register'),
            )
          ],
        ),
      ),
    );
  }
}
