import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ThoughtsListScreen extends StatefulWidget {
  const ThoughtsListScreen({super.key});

  @override
  State<ThoughtsListScreen> createState() => _ThoughtsListScreenState();
}

class _ThoughtsListScreenState extends State<ThoughtsListScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to see your thoughts')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Thoughts"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('thoughts')
            .where('userId', isEqualTo: user.uid) // ← ONLY YOUR THOUGHTS
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading thoughts"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No thoughts yet"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final text = data['text'] ?? '';
              final imagePath = data['imagePath'];
              final audioPath = data['audioPath'];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(text),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imagePath != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.file(
                            File(imagePath),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (audioPath != null)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () async {
                                await _audioPlayer
                                    .play(DeviceFileSource(audioPath));
                              },
                            ),
                            const Text("Play Audio"),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
