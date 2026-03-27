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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // --- LOGO ALIGNMENT ---
        centerTitle: false, // Set to false to align logo to the left
        title: Image.asset(
          'assets/icons/app_icon.png',
          height: 35,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              CyberpunkText(text: "BOOK'T"),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary.withOpacity(0.5)),
              ),
              child: const Icon(Icons.menu_open_rounded),
            ),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: 10),
        ],
      ),
      endDrawer:
          _buildEndDrawer(context), // Calling the updated left-aligned drawer
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "HELLO,",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              user?.email?.split('@')[0].toUpperCase() ?? "USER",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 2, width: 60, color: colorScheme.primary),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: [
                  _ActionCard(
                    title: "MONEY",
                    subtitle: "Manage Finances",
                    icon: Icons.account_balance_wallet_outlined,
                    color: colorScheme.primary,
                    onTap: () {
                      if (user?.uid != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => MoneyScreen()));
                      } else {
                        _showLoginError(context);
                      }
                    },
                  ),
                  _ActionCard(
                    title: "THOUGHTS",
                    subtitle: "Journal Entry",
                    icon: Icons.psychology_outlined,
                    color: colorScheme.secondary,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ThoughtsEntryScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UPDATED HELPER: DRAWER (Now also left-aligned) ---
  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Left-aligned header
                children: [
                  Image.asset(
                    'assets/icons/app_icon.png',
                    height: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.settings_suggest_outlined, size: 50),
                  ),
                  const SizedBox(height: 15),
                  CyberpunkText(text: "SYSTEM MENU"),
                ],
              ),
            ),
            _drawerTile(context, "Theme", Icons.palette_outlined,
                () => const ThemeSettingsScreen()),
            _drawerTile(context, "Wallpaper", Icons.wallpaper_rounded,
                () => const WallpaperScreen()),
            _drawerTile(context, "About Us", Icons.info_outline_rounded,
                () => const AboutScreen()),
            _drawerTile(context, "Donate", Icons.card_giftcard_rounded,
                () => const DonateScreen()),
            const Spacer(),
            const Divider(indent: 20, endIndent: 20),
            ListTile(
              leading:
                  const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text("TERMINATE SESSION",
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () async {
                final nav = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                if (nav.canPop()) nav.pop();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- HELPER: DRAWER TILE ---
  Widget _drawerTile(BuildContext context, String title, IconData icon,
      Widget Function() screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen()));
      },
    );
  }

  // --- HELPER: ERROR MESSAGE ---
  void _showLoginError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error: No user logged in!'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// --- CUSTOM REUSABLE ACTION CARD ---
class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.12), color.withOpacity(0.01)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 36),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
