import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initializeAuthState(),
          lazy: false, 
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Laravel Auth',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: AuthWrapper(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Tampilkan splash screen saat checking auth state
    if (authProvider.isLoading) {
      return SplashScreen();
    }

    // Redirect berdasarkan auth state
    return authProvider.isAuthenticated ? HomeScreen() : LoginScreen();
  }
}