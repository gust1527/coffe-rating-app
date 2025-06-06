import 'package:coffe_rating_app_impl/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanTypeList.dart';
import 'package:coffe_rating_app_impl/core/database/firebase_db_strategy.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/pages/home_page.dart';
import 'package:coffe_rating_app_impl/pages/machine_tab.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/core/factory/coffee_bean_factory.dart';
import 'package:coffe_rating_app_impl/core/enums.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProviderInterface.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

// Global factory instance
late CoffeeBeanFactory coffeeBeanFactory;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the factory with PocketBase for auth and Firebase for beans
  coffeeBeanFactory = CoffeeBeanFactory(
    BackendType.pocketBase,
    isProduction: false, // Set to true for production
  );

  // Initialize the database
  await coffeeBeanFactory.initializeDatabase();
  
  // Try to restore authentication state
  try {
    await coffeeBeanFactory.authStrategy.loginWithToken();
  } catch (e) {
    if (kDebugMode) {
      print('Failed to restore auth state: $e');
    }
  }
  
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
    const MachineTab(),
    const NordicCoffeBeanTypeList(),
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
        ChangeNotifierProvider<FirebaseDBStrategy>(
          create: (_) => coffeeBeanFactory.dbStrategy as FirebaseDBStrategy,
        ),
        ChangeNotifierProvider<AuthStrategy>(
          create: (_) => coffeeBeanFactory.authStrategy,
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
                label: 'All Beans',
              ),
            ],
          ),
        ),
      ),
    );
  }
}