import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
//import 'package:video_player/video_player.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:video_player/video_player.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HomeChatScreen extends StatefulWidget {
  @override
  _HomeChatScreenState createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  File? selectedImage;
  File? selectedVideo;
  File? selectedAudio;
  File? selectedGif;
  List<Message> _messages = [];
  String _errorMessage = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final snapshot =
          await _firestore.collection('messages').orderBy('timestamp').get();
      final messages =
          snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList();
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los mensajes :(';
      });
    }
  }

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> selectVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedVideo = File(result.files.single.path!);
      });
    }
  }

  Future<void> selectAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedAudio = File(result.files.single.path!);
      });
    }
  }

  Future<void> selectGif() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['gif']);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedGif = File(result.files.single.path!);
      });
    }
  }

  Future<String> uploadFile(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final destination = 'uploads/$fileName';
    final task = await FirebaseStorage.instance.ref(destination).putFile(file);
    if (task.state == TaskState.success) {
      final url = await task.ref.getDownloadURL();
      return url;
    } else {
      throw Exception('Error al subir el archivo');
    }
  }

  Future<void> _sendMessage() async {
    final currentTime = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);

    final message = Message(
      text: _messageController.text,
      timestamp: formattedTime,
    );

    try {
      if (selectedImage != null) {
        final imageUrl = await uploadFile(selectedImage!);
        message.imageUrl = imageUrl;
      }

      if (selectedVideo != null) {
        final videoUrl = await uploadFile(selectedVideo!);
        message.videoUrl = videoUrl;
      }

      if (selectedAudio != null) {
        final audioUrl = await uploadFile(selectedAudio!);
        message.audioUrl = audioUrl;
      }

      if (selectedGif != null) {
        final gifUrl = await uploadFile(selectedGif!);
        message.gifUrl = gifUrl;
      }

      await _firestore.collection('messages').add(message.toMap());

      setState(() {
        selectedImage = null;
        selectedVideo = null;
        selectedAudio = null;
        selectedGif = null;
      });

      _messageController.clear();
      _loadMessages();
    } catch (e) {
      // Handle any error while sending the message to Firestore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(71, 134, 250, 1),
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(137, 212, 172,
                              1), // Cambia el color según tus preferencias
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.imageUrl != null)
                              Image.network(
                                message.imageUrl!,
                                height: 250,
                                width: 250,
                              ),
                            if (message.videoUrl != null)
                              AspectRatio(
                                aspectRatio: 16 / 10,
                                child: VideoPlayerWidget(
                                    videoUrl: message.videoUrl!),
                              ),
                            if (message.audioUrl != null)
                              AudioPlayerWidget(audioUrl: message.audioUrl!),
                            if (message.gifUrl != null)
                              VideoPlayerWidget(videoUrl: message.gifUrl!),
                            if (message.text != null) Text(message.text!),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          message.timestamp ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () => selectAudio(),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => selectImage(),
                ),
                IconButton(
                  icon: Icon(Icons.video_library),
                  onPressed: () => selectVideo(),
                ),
                IconButton(
                  icon: Icon(Icons.gif),
                  onPressed: () => selectGif(),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController!,
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({required this.audioUrl});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  ConcatenatingAudioSource? _audioSource;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudioSource();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadAudioSource() async {
    _audioSource = ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(widget.audioUrl)),
    ]);
    await _audioPlayer.setAudioSource(_audioSource!);
  }

  Future<void> _playAudio() async {
    await _audioPlayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (_isPlaying) {
              _pauseAudio();
            } else {
              _playAudio();
            }
          },
        ),
        Text('Audio Player'),
      ],
    );
  }
}
