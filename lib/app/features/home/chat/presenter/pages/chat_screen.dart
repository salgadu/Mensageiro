import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mensageiro/app/core/infra/call/signalling_service.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/presenter/pages/chat_controller.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _videoPlayerController = VideoPlayerController.network('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              _startVideoCall();
            },
          ),
        ],
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
        final message = messages[index];
        if (message.typeMessage == 'A') {
          return _buildAudioMessage(message);
        } else if (message.typeMessage == 'P') {
          return _buildPhotoMessage(message);
        } else if (message.typeMessage == 'V') {
          return _buildVideoMessage(message);
        } else if (message.typeMessage == 'D') {
          return _buildDocumentMessage(message);
        }
        return _buildTextMessage(message);
      },
    );
  }

  Widget _buildAudioMessage(Chat message) {
    return ListTile(
      title: InkWell(
        child: Text("Audio Message"),
        onTap: () {
          _playAudio(message.message);
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

  Widget _buildPhotoMessage(Chat message) {
    return ListTile(
      title: Image.asset(
        message.message, // Replace with the actual asset path
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildVideoMessage(Chat message) {
    return ListTile(
      title: AspectRatio(
        aspectRatio: 16 /
            9, // You can adjust the aspect ratio based on your video dimensions
        child: VideoPlayer(_videoPlayerController),
      ),
    );
  }

  Widget _buildDocumentMessage(Chat message) {
    return ListTile(
      title: Text("Document: ${message.message}"),
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

  void _startVideoCall() {
    final signallingService = SignallingService.instance;
    signallingService.socket?.emit('startVideosCall', {
      'callerId': widget.contact.id,
      'calleeId': widget.contact.id,
    });
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
          pathUrl: audioFile.path,
        );
        widget.controller.sendAudio(widget.contact.id, chat, audioData);
      } catch (error) {
        print('Error uploading audio: $error');
      }
    }
  }

  void _playAudio(String audioUrl) async {
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
                'Fotos',
                () {
                  _sendPhoto();
                },
              ),
              _buildAttachmentOption(
                Icon(Icons.videocam),
                'Vídeos',
                () {
                  _sendVideo();
                },
              ),
              _buildAttachmentOption(
                Icon(Icons.insert_drive_file),
                'Documentos',
                () {
                  _sendDocuments();
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

  Future<void> _sendPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final photoFile = result.files.first;
      try {
        final photoData = photoFile.bytes;
        if (photoData == null) {
          print('Photo not selected');
          return;
        }
        final chat = Chat(
          message: photoFile.name,
          timestamp: DateTime.now().toString(),
          typeMessage: 'P',
          pathUrl: photoFile.path,
        );
        widget.controller.sendImage(widget.contact.id, chat, photoData);
      } catch (error) {
        print('Error uploading photo: $error');
      }
    }
  }

  Future<void> _sendVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final videoFile = result.files.first;
      try {
        final videoData = videoFile.bytes;
        if (videoData == null) {
          print('Video not selected');
          return;
        }
        final chat = Chat(
          message: videoFile.name,
          timestamp: DateTime.now().toString(),
          typeMessage: 'V',
          pathUrl: videoFile.path,
        );
        widget.controller.sendVideo(widget.contact.id, chat, videoData);
      } catch (error) {
        print('Error uploading video: $error');
      }
    }
  }

  Future<void> _sendDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final documentFile = result.files.first;
      try {
        final documentData = documentFile.bytes;
        if (documentData == null) {
          print('Document not selected');
          return;
        }
        final chat = Chat(
          message: documentFile.name,
          timestamp: DateTime.now().toString(),
          typeMessage: 'D',
          pathUrl: documentFile.path,
        );
        widget.controller.sendDocument(widget.contact.id, chat, documentData);
      } catch (error) {
        print('Error uploading document: $error');
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
