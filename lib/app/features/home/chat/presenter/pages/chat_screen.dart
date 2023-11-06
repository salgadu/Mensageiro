import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mensageiro/app/core/infra/call/signalling_service.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/presenter/pages/chat_controller.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import "package:cached_network_image/cached_network_image.dart";

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
  late VideoPlayerController _videoPlayerController;
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

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
                  return Stack(
                    children: [_buildMessagesList(snapshot.data!)],
                  );
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
          return BubbleNormalAudio(
            color: const Color(0xFFE8E8EE),
            duration: duration.inSeconds.toDouble(),
            position: position.inSeconds.toDouble(),
            isPlaying: isPlaying,
            isLoading: isLoading,
            isPause: isPause,
            onSeekChanged: _changeSeek,
            onPlayPauseButtonClick: () async {
              _playAudio(audioLink: message.message);
            },
            sent: true,
          );
        } else if (message.typeMessage == 'P') {
          return BubbleNormalImage(
            id: message.id ?? message.timestamp,
            image: _image(message.message),
            color: Colors.purpleAccent,
            tail: true,
            delivered: true,
          );
        } else if (message.typeMessage == 'V') {
          return _buildVideoMessage(message);
        } else if (message.typeMessage == 'D') {
          return _buildDocumentMessage(message);
        }
        return BubbleNormal(
          text: message.message,
          isSender: message.userId != widget.contact.id,
          color: const Color(0xFF1B97F3),
          tail: true,
          textStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        );
      },
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
    await widget.controller.sendAudio(widget.contact.id);
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
                  // _sendVideo();
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
  await widget.controller.sendImage(widget.contact.id);
  }

  Future<void> _sendDocuments() async {
   await widget.controller.sendDocument(widget.contact.id);
  }

  Widget _image(String image) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: image,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void _playAudio({required String audioLink}) async {
    final url = audioLink;
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    } else if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPause = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      await audioPlayer.play(UrlSource(url));
      setState(() {
        isPlaying = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        duration = new Duration();
        position = new Duration();
      });
    });
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(new Duration(seconds: value.toInt()));
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
