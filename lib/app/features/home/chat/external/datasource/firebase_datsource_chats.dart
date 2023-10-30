import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mensageiro/app/core/utils/rash_id.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/infra/datasource/i_chat_datasource.dart';
import 'package:mensageiro/app/features/home/chat/infra/model/chat_model.dart';

class FirebaseDatasourceChats implements IChatDatasource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseDatasourceChats({required this.firestore, required this.storage});

  @override
  Stream<List<ChatModel>> getMessages(String id) {
    return firestore
        .collection('chats')
        .doc(id.calculateHash())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ChatModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  @override
  Future<void> sendChat(String id, Chat chat) async {
    try {
      final chatCollection = firestore
          .collection('chats')
          .doc(id.calculateHash())
          .collection('messages');
      await chatCollection.add({
        'message': chat.message,
        'timestamp': chat.timestamp,
        'userId': chat.userId,
      });
    } catch (e) {
      print("Error adding message: $e");
      throw ChatException("Error adding message: $e");
    }
  }

  @override
  Future<void> sendAudio(String audioData, Chat chat) async {
    try {
      final audioRef = firestore
          .collection('chats')
          .doc(chat.id?.calculateHash())
          .collection('audio')
          .doc();
      final audioStorageRef =
          storage.ref().child('audio_messages/${audioRef.id}.mp3');

      await audioRef.set({
        'message': chat.message,
        'timestamp': chat.timestamp,
        'userId': chat.userId,
      });

      await audioStorageRef.putData(audioData as Uint8List);
      final downloadUrl = await audioStorageRef.getDownloadURL();

      await audioRef.update({'audio': downloadUrl});
    } catch (error) {
      print("Error uploading audio file: $error");
      throw ChatException("Error adding audio: $error");
    }
  }
}

class ChatException implements Exception {
  final String message;

  ChatException(this.message);

  @override
  String toString() {
    return 'ChatException: $message';
  }
}
