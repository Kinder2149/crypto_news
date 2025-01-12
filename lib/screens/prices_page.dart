// lib/screens/prices_page.dart
import 'package:flutter/material.dart';
import '../models/crypto_data.dart';

class PricesPage extends StatelessWidget {
  final List<CryptoData> cryptoData;

  const PricesPage({
    super.key,
    required this.cryptoData,
  });

  @override
  Widget build(BuildContext context) {
    if (cryptoData.isEmpty) {
      return const Center(
        child: Text('Aucune donnée disponible'),
      );
    }

    return ListView.builder(
      itemCount: cryptoData.length,
      itemBuilder: (context, index) {
        final crypto = cryptoData[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.network(
                crypto.image,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.currency_bitcoin),
              ),
            ),
            title: Text(
              '${crypto.name} (${crypto.symbol.toUpperCase()})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rang: #${crypto.marketCapRank}'),
                Text('Cap. marché: ${(crypto.marketCap / 1000000).toStringAsFixed(2)}M€'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${crypto.currentPrice.toStringAsFixed(2)}€',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${crypto.priceChangePercentage24h.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: crypto.priceChangePercentage24h >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}