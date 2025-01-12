// lib/services/coingecko_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/crypto_data.dart';

class CoinGeckoService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  // Mapping direct des symboles aux IDs CoinGecko
  static const Map<String, String> symbolToId = {
    'BTC': 'bitcoin',
    'ETH': 'ethereum',
    'BNB': 'binancecoin',
    'EGLD': 'multiversx-egld',
  };

  static Future<List<CryptoData>> getCryptoData(List<String> symbols) async {
    try {
      print('Récupération des prix pour: ${symbols.join(", ")}');

      final ids = symbols
          .map((symbol) => symbolToId[symbol.toUpperCase()])
          .where((id) => id != null)
          .join(',');

      print('IDs CoinGecko: $ids');

      if (ids.isEmpty) {
        print('Aucun ID CoinGecko trouvé pour les symboles');
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/coins/markets?vs_currency=eur&ids=$ids&order=market_cap_desc&sparkline=false&price_change_percentage=24h,7d'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Timeout lors de la requête CoinGecko');
          throw Exception('Timeout de la requête');
        },
      );

      print('Statut de la réponse CoinGecko: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final cryptoData = data.map((json) => CryptoData.fromJson(json)).toList();
        print('Données récupérées avec succès: ${cryptoData.length} cryptos');
        return cryptoData;
      }
      else if (response.statusCode == 429) {
        print('Rate limit atteint, utilisation du cache');
        return [];
      } else {
        print('Erreur API: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la récupération des prix: $e');
      return [];
    }
  }
}