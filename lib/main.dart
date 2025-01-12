import 'package:flutter/material.dart';
import 'services/github_service.dart';
import 'services/coingecko_service.dart';
import 'models/transaction.dart';
import 'screens/prices_page.dart';
import 'screens/history_page.dart';
import 'package:provider/provider.dart';
import 'providers/crypto_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/crypto_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Hive
  await Hive.initFlutter();

  // Enregistrer les adaptateurs
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CryptoDataAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TransactionAdapter());
  }

  // Ouvrir les boxes
  await Hive.openBox<CryptoData>('crypto_cache');
  await Hive.openBox<Transaction>('transactions_cache');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CryptoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<CryptoProvider>().loadAllData(isInitialLoad: true)
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CryptoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                await provider.loadAllData();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
        index: _selectedIndex,
        children: [
          PricesPage(cryptoData: provider.cryptoData),
          HistoryPage(
            transactions: provider.transactions,
            cryptoData: provider.cryptoData,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_bitcoin),
            label: 'Cours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}