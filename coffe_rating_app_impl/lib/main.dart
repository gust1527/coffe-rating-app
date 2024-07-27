import 'package:coffe_rating_app_impl/firebase_options.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanInMachine.dart';
import 'package:flutter/material.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanTypeList.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key, Key? key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CoffeBeanInMachine(),
    const CoffeBeanTypeList(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Rating App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee_maker_outlined),
              label: 'Current Coffee',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee_outlined),
              label: 'Coffee List',
            ),
          ],
        ),
      ),
    );
  }
}