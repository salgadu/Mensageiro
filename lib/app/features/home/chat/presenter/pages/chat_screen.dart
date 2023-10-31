import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/presenter/pages/chat_controller.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatPage extends StatefulWidget {
  final ChatController controller;
  final Contact contact;

  const ChatPage({Key? key, required this.controller, required this.contact})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final player = AudioPlayer();
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
        if (messages[index].typeMessage == 'A') {
          return _buildAudioMessage(messages[index].message);
        }
        return _buildTextMessage(messages[index]);
      },
    );
  }

  Widget _buildAudioMessage(String audioPath) {
    return ListTile(
      title: InkWell(
        child: Text("Audio Message"),
        onTap: () {
          _playAudio(audioPath);
        },
      ),
    );
  }

  Widget _buildTextMessage(Chat message) {
    return ListTile(
      title: Text(
        message.message,
        textAlign: message.userId == widget.contact.id
            ? TextAlign.left
            : TextAlign.right,
      ),
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
    _messageController.clear();
  }

  Future<void> _sendAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final audioFile = result.files.first;
      try {
        final audioData = audioFile.bytes;
        if (audioData == null) {
          print('Audio not recorded');
          return;
        }
        final chat = Chat(
          message: audioFile.name,
          timestamp: DateTime.now().toString(),
          typeMessage: 'A',
          audioUrl: audioFile.path,
        );
        widget.controller.sendAudio(widget.contact.id, chat, audioData);
      } catch (error) {
        print('Error uploading audio: $error');
      }
    }
  }

  void _playAudio(String audioUrl) async{
    await player.play(audioUrl as Source);
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildAttachmentOption(
                Icon(Icons.photo_camera),
                'Fotos e Vídeos',
                () {
                  _pickMedia(context);
                },
              ),
              _buildAttachmentOption(
                Icon(Icons.insert_drive_file),
                'Documento',
                () {
                  _pickDocument(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildAttachmentOption(Icon icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> _pickMedia(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );
    if (result != null) {}
    Navigator.pop(context);
  }

  Future<void> _pickDocument(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
    );
    if (result != null) {}
    Navigator.pop(context);
  }
}
