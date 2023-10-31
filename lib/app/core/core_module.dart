import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/core/infra/notification/firebase_message_service.dart';
import 'package:mensageiro/app/core/infra/notification/notification_service.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';

class CoreModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AuthStore>(AuthStore.new);
    i.addInstance<FirebaseAuth>(FirebaseAuth.instance);
    i.addInstance<FirebaseFirestore>(FirebaseFirestore.instance);
    i.addInstance<FirebaseMessaging>(FirebaseMessaging.instance);
    i.addInstance<FirebaseStorage>(FirebaseStorage.instance);
    i.addInstance(NotificationService());
    i.add(FirebaseMessageService.new);
  }
}
