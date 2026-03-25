import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_notifier.dart';
import '../theme/cyberpunk_theme.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define six theme options.
    final themeOptions = [
      {
        'name': 'Cyberpunk Blue',
        'theme': cyberpunkTheme,
      },
      {
        'name': 'Neon Pink',
        'theme': ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          primaryColor: const Color(0xFFFF009D),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        ),
      },
      {
        'name': 'Deep Purple',
        'theme': ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          primaryColor: Colors.deepPurple,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        ),
      },
      {
        'name': 'Vibrant Red',
        'theme': ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          primaryColor: Colors.redAccent,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        ),
      },
      {
        'name': 'Emerald Green',
        'theme': ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          primaryColor: Colors.greenAccent,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        ),
      },
      {
        'name': 'Golden',
        'theme': ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          primaryColor: Colors.amber,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        ),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme Settings"),
      ),
      body: ListView.builder(
        itemCount: themeOptions.length,
        itemBuilder: (context, index) {
          final option = themeOptions[index];
          final String name = option['name'] as String;
          final ThemeData theme = option['theme'] as ThemeData;

          return ListTile(
            leading: Icon(
              Icons.circle,
              color: theme.primaryColor,
            ),
            title: Text(name),
            onTap: () {
              Provider.of<ThemeNotifier>(context, listen: false)
                  .setTheme(theme);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name theme applied!')),
              );
            },
          );
        },
      ),
    );
  }
}
