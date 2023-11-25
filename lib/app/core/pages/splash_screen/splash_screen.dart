import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mensageiro/app/core/infra/notification/firebase_message_service.dart';
import 'package:mensageiro/app/core/infra/notification/notification_service.dart';
import 'package:mensageiro/app/core/store/auth/auth_status.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthStore authStore;
  @override
  void initState() {
    super.initState();
    authStore = Modular.get<AuthStore>();
    initializeFirebaseMessaging();
    checkNotifications();
    initAutoLogin().then((value) => value);
  }

  Future<void> initAutoLogin() async {
    await authStore.authLogin();
    if (authStore.authStatus == AuthStatus.START ||
        authStore.authStatus == null) {
      Modular.to.pushReplacementNamed('/home/');
    }
  }

  initializeFirebaseMessaging() async {
    await Modular.get<FirebaseMessageService>().initialize();
  }

  checkNotifications() async {
    await Modular.get<NotificationService>().checkForNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints:
                    const BoxConstraints(maxHeight: 300, maxWidth: 300),
                child: SvgPicture.asset('assets/europlus.svg'),
              ),
              const Text('MENSAGEIRO',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(
                height: 35,
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
