// lib/screens/history_page.dart
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/crypto_data.dart';
import '../widgets/transaction_card.dart';

class HistoryPage extends StatelessWidget {
  final List<Transaction> transactions;
  final List<CryptoData> cryptoData;

  const HistoryPage({
    super.key,
    required this.transactions,
    required this.cryptoData,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final cryptoInfo = cryptoData.firstWhere(
              (crypto) => crypto.symbol.toUpperCase() == transaction.symbol,
          orElse: () => CryptoData(
            id: '',
            symbol: transaction.symbol,
            name: transaction.name,
            image: '',
            currentPrice: 0,
            priceChangePercentage24h: 0,
            priceChangePercentage7d: 0,
            marketCap: 0,
            marketCapRank: 0,
          ),
        );

        return TransactionCard(
          transaction: transaction,
          cryptoData: cryptoInfo,
        );
      },
    );
  }
}