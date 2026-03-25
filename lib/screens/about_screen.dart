import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Book\'t'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "Book't was created to help you keep track of your thoughts and financial entries. "
            "It is built with Flutter and Firebase and designed in a sleek cyberpunk style. "
            "For any questions or feedback, please reach out on Twitter: @mrjamesofficia "
            "(https://x.com/mrjamesofficia?t=f0twY4X_ZWG1SIya6h8mow&s=09).",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
