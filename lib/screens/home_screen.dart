import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'money_screen.dart';
import 'thoughts_entry_screen.dart';
import 'theme_settings_screen.dart';
import 'wallpaper_screen.dart';
import 'about_screen.dart';
import 'donate_screen.dart';
import '../widgets/cyberpunk_text.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // A global key that gives us access to the Scaffold's state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the global key here
      appBar: AppBar(
        title: CyberpunkText(text: "Book't"),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Use the ScaffoldState to open the endDrawer
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      // Right-side drawer
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: const Center(
                child: Text(
                  "Book't Menu",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.palette, color: Colors.white),
              title: const Text("Theme"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ThemeSettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallpaper, color: Colors.white),
              title: const Text("Wallpaper"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WallpaperScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text("About Us"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.white),
              title: const Text("Donate"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DonateScreen()),
                );
              },
            ),
            const Spacer(),
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title:
                  const Text("Log Out", style: TextStyle(color: Colors.white)),
              onTap: () async {
                // Capture Navigator before the async call
                final nav = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                if (nav.canPop()) {
                  nav.pop();
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MoneyScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error: No user logged in!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('\$ Money'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ThoughtsEntryScreen()),
                );
              },
              child: const Text('? Thoughts'),
            ),
          ],
        ),
      ),
    );
  }
}
