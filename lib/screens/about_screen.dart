import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchX() async {
    final Uri url = Uri.parse('https://x.com/mrjamesofficia');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Book't"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 16),
              children: [
                const TextSpan(
                  text:
                      "Book't was created to help you keep track of your thoughts and financial entries. "
                      "It is built with Flutter and Firebase and designed in a sleek cyberpunk style. "
                      "For any questions or feedback, please reach out on X: ",
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: _launchX,
                    child: const Text(
                      '@mrjamesofficia',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: " (https://x.com/mrjamesofficia)."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
