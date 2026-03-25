import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Screens
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'theme/cyberpunk_theme.dart';
import 'bloc/money_bloc.dart';
import 'theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BooktApp());
}

class BooktApp extends StatelessWidget {
  const BooktApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => MoneyBloc()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier(cyberpunkTheme)),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Bookt',
            theme: themeNotifier.themeData,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!snapshot.hasData) {
                  return AuthScreen();
                }
                return HomeScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
