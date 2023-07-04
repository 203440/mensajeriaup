import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:video_player/video_player.dart';

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
      final snapshot = await _firestore.collection('messages').get();
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
        print(selectedImage);
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

  Future<void> _sendMessage() async {
    final currentTime = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);

    final message = Message(
      text: _messageController.text,
      imageUrl: selectedImage != null ? selectedImage!.path : null,
      videoUrl: selectedVideo != null ? selectedVideo!.path : null,
      audioUrl: selectedAudio != null ? selectedAudio!.path : null,
      gifUrl: selectedGif != null ? selectedGif!.path : null,
      timestamp: formattedTime,
    );

    try {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.imageUrl != null)
                        Image.file(File(message.imageUrl!)),
                      if (message.videoUrl != null)
                        VideoPlayerController.file(File(message.videoUrl!))
                                .value
                                .isInitialized
                            ? AspectRatio(
                                aspectRatio: VideoPlayerController.file(
                                        File(message.videoUrl!))
                                    .value
                                    .aspectRatio,
                                child: VideoPlayer(
                                  VideoPlayerController.file(
                                      File(message.videoUrl!)),
                                ),
                              )
                            : Container(),
                      if (message.audioUrl != null)
                        // Renderizar el reproductor de audio
                        Container(), // Aquí debes implementar la lógica para reproducir el audio
                      if (message.gifUrl != null)
                        Image.file(File(message.gifUrl!)),
                      if (message.text != null) Text(message.text!),
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


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
// import 'package:mensajeriaup/features/mensajes/chat/presentation/widget/message_list.dart';
// import 'package:video_player/video_player.dart';
// import 'package:audioplayers/audioplayers.dart';

// class HomeChatScreen extends StatefulWidget {
//   @override
//   _HomeChatScreenState createState() => _HomeChatScreenState();
// }

// class _HomeChatScreenState extends State<HomeChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   File? selectedImage;
//   File? selectedVideo;
//   File? selectedAudio;
//   File? selectedGif;
//   List<Message> _messages = [];
//   String _errorMessage = '';
//   bool _isOffline = false;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadMessages() async {
//     try {
//       final snapshot = await _firestore.collection('messages').get();
//       final messages =
//           snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList();
//       setState(() {
//         _messages = messages;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error al cargar los mensajes :(';
//       });
//     }
//   }

//   Future<void> selectImage() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         selectedImage = File(result.files.single.path!);
//         print(selectedImage);
//       });
//     }
//   }

//   Future<void> selectVideo() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.video);
//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         selectedVideo = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<void> selectAudio() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.audio);
//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         selectedAudio = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<void> selectGif() async {
//     final result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['gif']);
//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         selectedGif = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<void> _sendMessage() async {
//     final currentTime = DateTime.now();
//     final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);

//     final message = Message(
//       text: _messageController.text,
//       imageUrl: selectedImage,
//       videoUrl: selectedVideo,
//       audioUrl: selectedAudio,
//       gifUrl: selectedGif,
//       timestamp: formattedTime,
//     );

//     try {
//       await _firestore.collection('messages').add(message.toMap());
//       setState(() {
//         selectedImage = null;
//         selectedVideo = null;
//         selectedAudio = null;
//         selectedGif = null;
//       });
//       _messageController.clear();
//       _loadMessages();
//     } catch (e) {
//       // Handle any error while sending the message to Firestore
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(71, 134, 250, 1),
//         title: Text(
//           'Chat',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 return ListTile(
//                   title: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       MessageBubble(message: message),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           message.timestamp ?? '',
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Ingrese un mensaje...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.attach_file),
//                   onPressed: () => selectAudio(),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.camera_alt),
//                   onPressed: () => selectImage(),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.video_library),
//                   onPressed: () => selectVideo(),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.gif),
//                   onPressed: () => selectGif(),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () => _sendMessage(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
