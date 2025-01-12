import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';
import '../services/coingecko_service.dart';
import '../services/github_service.dart';
import '../models/crypto_data.dart';

class CryptoProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<CryptoData> _cryptoData = [];
  bool _isLoading = false;
  DateTime? _lastRefresh;
  static const refreshCooldown = Duration(seconds: 30);
  static const Duration cacheValidity = Duration(minutes: 5);

  // Getters
  List<Transaction> get transactions => _transactions;
  List<CryptoData> get cryptoData => _cryptoData;
  bool get isLoading => _isLoading;

  // Initialiser les boxes Hive
  final Box<CryptoData> _cryptoCache = Hive.box('crypto_cache');
  final Box<Transaction> _transactionsCache = Hive.box('transactions_cache');

  Future<void> loadAllData({bool isInitialLoad = false}) async {
    // Vérification du cooldown seulement si ce n'est pas le chargement initial
    if (!_isLoading && !isInitialLoad && _lastRefresh != null) {
      final now = DateTime.now();
      if (now.difference(_lastRefresh!) < refreshCooldown) {
        throw Exception('Veuillez attendre ${refreshCooldown.inSeconds} secondes entre chaque actualisation');
      }
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Essayer de charger depuis le cache d'abord
      if (isInitialLoad && isCacheValid()) {
        print('Chargement depuis le cache');
        final cachedTransactions = _transactionsCache.values.toList();
        final cachedCryptoData = _cryptoCache.values.toList();

        if (cachedTransactions.isNotEmpty && cachedCryptoData.isNotEmpty) {
          _transactions = cachedTransactions;
          _cryptoData = cachedCryptoData;
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      print('Chargement depuis l\'API');
      // Charger les nouvelles données
      final loadedTransactions = await GitHubService.loadTransactions();
      _transactions = loadedTransactions;

      // Mettre à jour le cache des transactions
      await _transactionsCache.clear();
      for (var transaction in loadedTransactions) {
        await _transactionsCache.add(transaction);
      }

      // Extraire les symboles uniques
      final symbols = loadedTransactions.map((t) => t.symbol).toSet().toList();

      // Charger les données de prix
      final prices = await CoinGeckoService.getCryptoData(symbols);
      _cryptoData = prices;

      // Mettre à jour le cache des crypto données
      await _cryptoCache.clear();
      for (var crypto in prices) {
        await _cryptoCache.add(crypto);
      }

      _lastRefresh = DateTime.now();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Erreur dans loadAllData: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Vérifier si le cache est valide
  bool isCacheValid() {
    if (_lastRefresh == null) return false;
    final cacheAge = DateTime.now().difference(_lastRefresh!);
    final isValid = cacheAge < cacheValidity;
    print('Cache age: ${cacheAge.inMinutes} minutes, isValid: $isValid');
    return isValid;
  }

  // Nettoyer le provider lors de sa destruction
  @override
  void dispose() {
    _cryptoCache.close();
    _transactionsCache.close();
    super.dispose();
  }
}