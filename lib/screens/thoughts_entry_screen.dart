import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'thoughts_list_screen.dart';

class ThoughtsEntryScreen extends StatefulWidget {
  const ThoughtsEntryScreen({super.key});

  @override
  State<ThoughtsEntryScreen> createState() => _ThoughtsEntryScreenState();
}

class _ThoughtsEntryScreenState extends State<ThoughtsEntryScreen> {
  final TextEditingController _textController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (!mounted) return;

    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission not granted')),
      );
      return;
    }
    await _recorder.openRecorder();
    if (!mounted) return;

    _isRecorderInitialized = true;
  }

  @override
  void dispose() {
    _textController.dispose();
    if (_isRecorderInitialized) _recorder.closeRecorder();
    super.dispose();
  }

  Future<void> _saveThought() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text first.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No user logged in!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('thoughts').add({
        'text': text,
        'timestamp': DateTime.now(),
        'imagePath': _pickedImage?.path,
        'audioPath': _recordedFilePath,
        'userId': user.uid, // ← THIS IS THE IMPORTANT NEW LINE
      });

      if (!mounted) return;

      _textController.clear();
      setState(() {
        _pickedImage = null;
        _recordedFilePath = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thought saved!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving thought: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;

    if (pickedFile != null) {
      setState(() => _pickedImage = pickedFile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image selected!')),
      );
    }
  }

  Future<void> _toggleRecording() async {
    if (!_isRecorderInitialized) return;

    if (_isRecording) {
      final path = await _recorder.stopRecorder();
      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _recordedFilePath = path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording saved!')),
      );
    } else {
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder.startRecorder(toFile: fileName, codec: Codec.aacADTS);
      if (!mounted) return;

      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Thought'),
        actions: [
          IconButton(onPressed: _saveThought, icon: const Icon(Icons.save)),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThoughtsListScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_pickedImage != null)
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            Expanded(
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'What are you thinking?',
                  hintStyle: TextStyle(color: Color(0xFF08F7FE)),
                  border: InputBorder.none,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Color(0xFF08F7FE)),
                ),
                IconButton(
                  onPressed: _toggleRecording,
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: const Color(0xFF08F7FE),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
