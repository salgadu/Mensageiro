import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/presenter/pages/chat_controller.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';

class ChatPage extends StatefulWidget {
  final ChatController controller;
  final Contact contact;

  const ChatPage({Key? key, required this.controller, required this.contact})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Chat>>(
              stream: widget.controller.messages(widget.contact.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildMessagesList(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          _buildMessageComposer(context),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<Chat> messages) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            messages[index].message,
            textAlign: messages[index].userId == widget.contact.id
                ? TextAlign.left
                : TextAlign.right,
          ),
        );
      },
    );
  }

  Widget _buildMessageComposer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions(context);
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration:
                  const InputDecoration(hintText: 'Digite uma mensagem...'),
              onSubmitted: _sendMessage,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(_messageController.text);
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              _sendAudio();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    widget.controller.sendMessage(
      widget.contact.id,
      Chat(
        message: message,
        timestamp: DateTime.now().toString(),
        typeMessage: 'M',
      ),
    );
    _messageController.clear(); // Limpa o campo de mensagem após o envio
  }

 Future<void> _sendAudio() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.audio,
    allowMultiple: false,
  );

  if (result != null && result.files.isNotEmpty) {
    final audioFile = result.files.first;
    try {
      final audioData = audioFile.bytes!;
      final chat = Chat(
        message: audioFile.name,
        timestamp: DateTime.now().toString(),
        userId: widget.contact.id,
        typeMessage: 'A',
      );
      widget.controller.sendAudio(audioData as String, chat);
    } catch (error) {
      print('Error uploading audio: $error');
    }
  }
  Navigator.pop(context);
}


  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Fotos e Vídeos'),
                onTap: () {
                  _pickMedia(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Documento'),
                onTap: () {
                  _pickDocument(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.contacts),
                title: Text('Contato'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMedia(BuildContext context) async {
    // Lógica para escolher fotos e vídeos aqui
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );
    if (result != null) {}
    Navigator.pop(context);
  }

  Future<void> _pickDocument(BuildContext context) async {
    // Lógica para escolher documentos aqui
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
    );
    if (result != null) {}
    Navigator.pop(context);
  }
}

