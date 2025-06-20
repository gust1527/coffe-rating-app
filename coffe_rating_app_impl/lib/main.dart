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
import 'package:coffe_rating_app_impl/core/utils/coffee_logger.dart';
import 'package:coffe_rating_app_impl/pages/profile_page.dart';
import 'package:coffe_rating_app_impl/pages/coffee_bean_details_page.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanInMachine.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

// Global factory instance
late CoffeeBeanFactory coffeeBeanFactory;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CoffeeLogger.info('Starting Nordic Coffee Bean app');

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
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    CoffeeLogger.info('Initializing app state');
  }

  @override
  void dispose() {
    CoffeeLogger.info('Disposing app state');
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthStrategy>(
          create: (_) {
            CoffeeLogger.info('Creating auth strategy provider');
            return coffeeBeanFactory.authStrategy;
          },
        ),
        ChangeNotifierProvider<FirebaseDBStrategy>(
          create: (_) {
            CoffeeLogger.info('Creating database strategy provider');
            return coffeeBeanFactory.dbStrategy as FirebaseDBStrategy;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Nordic Coffee Bean',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: NordicColors.caramel,
            background: NordicColors.background,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: NordicColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: NordicColors.background,
            foregroundColor: NordicColors.textPrimary,
            elevation: 0,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          CoffeeLogger.info('Generating route: ${settings.name}');
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const NordicHomePage(),
              );
            case '/profile':
              return MaterialPageRoute(
                builder: (_) => const ProfilePage(),
              );
            case '/bean-details':
              final beanId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) {
                  final provider = Provider.of<FirebaseDBStrategy>(context, listen: false);
                  final bean = provider.coffeeBeans.firstWhere(
                    (bean) => bean.id == beanId,
                    orElse: () => CoffeBeanType(
                      id: beanId,
                      beanMaker: 'Unknown',
                      beanType: 'Unknown',
                      beanRating: [],
                      isInMachine: false,
                    ),
                  );
                  return CoffeeBeanDetailsPage(bean: bean);
                },
              );
            case '/machine':
              return MaterialPageRoute(
                builder: (_) => const CoffeBeanInMachine(),
              );
            case '/beans':
              return MaterialPageRoute(
                builder: (_) => const NordicCoffeBeanTypeList(),
              );
            default:
              CoffeeLogger.error('Unknown route: ${settings.name}');
              return MaterialPageRoute(
                builder: (_) => const NordicHomePage(),
              );
          }
        },
      ),
    );
  }
}