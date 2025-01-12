// lib/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/crypto_data.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final CryptoData? cryptoData;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.cryptoData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Logo
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 12),
                  child: cryptoData?.image != null && cryptoData!.image.isNotEmpty
                      ? Image.network(
                    cryptoData!.image,
                    errorBuilder: (_, __, ___) => _buildFallbackIcon(transaction.symbol),
                  )
                      : _buildFallbackIcon(transaction.symbol),
                ),
                // Nom et symbole
                Expanded(
                  child: Text(
                    '${transaction.name} (${transaction.symbol})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Date
                Text(
                  transaction.date.toString().split(' ')[0],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Détails de la transaction
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prix: ${transaction.price}€',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Montant: ${transaction.amount}€',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Quantité: ${transaction.quantity}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                // Type d'ordre (Achat/Vente)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: transaction.orderType == 'Achat' ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    transaction.orderType,
                    style: TextStyle(
                      color: transaction.orderType == 'Achat' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(String symbol) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          symbol.substring(0, 1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}