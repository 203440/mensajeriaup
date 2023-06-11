// lib/domain/models/message.dart

// class Message {
//   final String id;
//   final String text;

//   Message({required this.id, required this.text});
// }

// lib/domain/models/message.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Message {
  String id;
  String text;
  String? videoUrl;
  String? audioUrl;
  String? imageUrl;
  String? gifUrl;

  Message({
    required this.id,
    required this.text,
    this.videoUrl,
    this.audioUrl,
    this.imageUrl,
    this.gifUrl,
  });
}
