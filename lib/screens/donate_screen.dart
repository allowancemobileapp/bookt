import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  static const walletAddress = "0xea1480a809d62d04b8e5836e6b965804a0ee700c";

  Future<void> _openEtherscan() async {
    final Uri url = Uri.parse('https://etherscan.io/address/$walletAddress');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _openBscScan() async {
    final Uri url = Uri.parse('https://bscscan.com/address/$walletAddress');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "If you appreciate Book't, please consider donating USDT to support development.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            const Text(
              "USDT Address:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),

            SelectableText(
              walletAddress,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // 🔥 Clickable links
            GestureDetector(
              onTap: _openEtherscan,
              child: const Text(
                "View on Ethereum (ERC20)",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: _openBscScan,
              child: const Text(
                "View on BNB Smart Chain (BEP20)",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
