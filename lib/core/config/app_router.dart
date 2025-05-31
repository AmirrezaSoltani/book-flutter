import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/books/presentation/pages/books_page.dart';
import '../../features/books/presentation/pages/my_library_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/reading/presentation/pages/reading_page.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String login = '/login';
  static const String books = '/books';
  static const String profile = '/profile';
  static const String reading = '/reading';
  static const String myLibrary = '/my-library';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case books:
        return MaterialPageRoute(builder: (_) => const BooksPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case reading:
        return MaterialPageRoute(builder: (_) => const ReadingPage());
      case myLibrary:
        return MaterialPageRoute(builder: (_) => const MyLibraryPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 