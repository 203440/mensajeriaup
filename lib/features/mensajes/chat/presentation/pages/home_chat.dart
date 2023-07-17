import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/bloc/bloc/message_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  File? selectedPdf;
  late MessageBloc _messageBloc;
  Location location = Location();
  LocationData? currentLocation;
  CameraPosition? initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _messageBloc = MessageBloc();
    _messageBloc.dispatch(LoadMessagesEvent());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageBloc.dispose();
    super.dispose();
  }

  Future<void> deleteAllFiles() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference rootRef = storage.ref();

    final ListResult result = await rootRef.listAll();

    for (final Reference ref in result.items) {
      await ref.delete();
    }
  }

  FutureOr<void> selectImage() async {
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

  Future<void> selectPdf() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedPdf = File(result.files.single.path!);
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

    // Subir archivos y obtener las URL de descarga antes de enviar el mensaje

    await uploadSelectedFiles(message);

    _messageBloc.dispatch(SendMessageEvent(message));
    _clearFields();
  }

  Future<void> uploadSelectedFiles(Message message) async {
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

      if (selectedPdf != null) {
        final pdfUrl = await uploadFile(selectedPdf!);
        message.pdfUrl = pdfUrl;
      }
    } catch (e) {
      // Manejar errores de carga de archivos si es necesario
      print('Error al cargar los archivos: $e');
    }
  }

  Future<void> sendLocationMessage() async {
    try {
      currentLocation = await location.getLocation();
      if (currentLocation != null) {
        setState(() {
          initialCameraPosition = CameraPosition(
            target: LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
            zoom: 15,
          );
        });
      }
    } catch (e) {
      // Maneja cualquier error al obtener la ubicación
    }

    if (currentLocation != null) {
      final message = Message(
        text: 'Mi ubicación',
        timestamp: DateTime.now().toString(),
        latitude: currentLocation!.latitude,
        longitude: currentLocation!.longitude,
      );

      // Subir archivos y obtener las URL de descarga antes de enviar el mensaje
      await uploadSelectedFiles(message);

      _messageBloc.dispatch(SendMessageEvent(message));
      _clearFields();
    }
  }

  void _clearFields() {
    setState(() {
      selectedImage = null;
      selectedVideo = null;
      selectedAudio = null;
      selectedGif = null;
      selectedPdf = null;
      initialCameraPosition = null;
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(71, 134, 250, 1),
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => deleteAllFiles(),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<MessageState>(
            stream: _messageBloc.chatStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final state = snapshot.data!;
                if (state is LoadingState) {
                  return CircularProgressIndicator();
                } else if (state is LoadedState) {
                  final messages = state.messages;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(137, 212, 172, 1),
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
                                      Container(
                                        width: 300,
                                        child: AspectRatio(
                                          aspectRatio: 16 / 10,
                                          child: VideoPlayerWidget(
                                            videoUrl: message.videoUrl!,
                                          ),
                                        ),
                                      ),
                                    if (message.audioUrl != null)
                                      Container(
                                        width: 250,
                                        child: AudioPlayerWidget(
                                          audioUrl: message.audioUrl!,
                                        ),
                                      ),
                                    if (message.gifUrl != null)
                                      Container(
                                        width: 300,
                                        child: AspectRatio(
                                          aspectRatio: 16 / 10,
                                          child: VideoPlayerWidget(
                                            videoUrl: message.gifUrl!,
                                          ),
                                        ),
                                      ),
                                    if (message.pdfUrl != null)
                                      Container(
                                        height: 300,
                                        child: PdfViewerWidget(
                                          pdfUrl: message.pdfUrl!,
                                        ),
                                      ),
                                    if (message.text != null)
                                      Text(message.text!),
                                    if (message.latitude != null &&
                                        message.longitude != null)
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MapScreen(
                                                latitude: message.latitude!,
                                                longitude: message.longitude!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text('Ver ubicación'),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is ErrorState) {
                  return Text(state.errorMessage);
                }
              }
              return Container();
            },
          ),
          if (initialCameraPosition != null)
            Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition!,
                markers: {
                  Marker(
                    markerId: MarkerId('currentLocation'),
                    position: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                  ),
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
                  icon: Icon(Icons.audio_file),
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
                  icon: Icon(Icons.attach_file),
                  onPressed: () => selectPdf(),
                ),
                IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () => sendLocationMessage(),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          )
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
        Text('Audio'),
      ],
    );
  }
}

class PdfViewerWidget extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerWidget({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: pdfUrl,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      pageSnap: true,
      defaultPage: 0,
      fitPolicy: FitPolicy.BOTH,
      preventLinkNavigation: false,
      onError: (error) {
        // Maneja cualquier error si es necesario
      },
      onPageError: (page, error) {
        // Maneja errores de página si es necesario
      },
    );
  }
}

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapScreen({
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(latitude, longitude),
          ),
        },
      ),
    );
  }
}
