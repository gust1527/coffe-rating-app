import 'package:coffe_rating_app_impl/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanTypeList.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/pages/home_page.dart';
import 'package:provider/provider.dart';

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
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const NordicHomePage(),
    const NordicCoffeBeanTypeList(showMachineActions: true),
    const NordicCoffeBeanTypeList(showMachineActions: false),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CoffeBeanDBProvider>(
          create: (_) => CoffeBeanDBProvider()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'Nordic Bean',
        theme: NordicTheme.lightTheme,
        home: Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: NordicColors.background,
            selectedItemColor: NordicColors.textPrimary,
            unselectedItemColor: NordicColors.textSecondary,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.coffee_maker_outlined),
                label: 'Machine',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.coffee_outlined),
                label: 'My Roasts',
              ),
            ],
          ),
        ),
      ),
    );
  }
}