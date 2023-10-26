import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthStore authStore = Modular.get<AuthStore>();
  @override
  void initState() {
    super.initState();
    authStore.authLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.blue),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  constraints:
                      const BoxConstraints(maxHeight: 200, maxWidth: 200),
                  child: Image.asset('assets/menssageiro1.png')),
              Text('MENSAGEIRO',
                  style: GoogleFonts.spaceGrotesk().copyWith(fontSize: 30)),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
