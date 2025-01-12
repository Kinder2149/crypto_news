// lib/services/github_service.dart
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'dart:io';
import 'dart:convert';
import '../models/transaction.dart';  // Ajout de l'import du modèle

class GitHubService {
  static const String fileUrl = 'https://raw.githubusercontent.com/tezcatlypoca/CoinTracker/main/TestFile.ods';

  static Future<List<Transaction>> loadTransactions() async {
    try {
      print('Début du téléchargement du fichier');

      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        print('Fichier téléchargé avec succès');

        // Décodage du fichier ODS
        final decoder = SpreadsheetDecoder.decodeBytes(response.bodyBytes);
        final table = decoder.tables[decoder.tables.keys.first]!;

        print('Nombre de lignes: ${table.rows.length}');

        List<Transaction> transactions = [];

        // Ignorer la première ligne (en-têtes)
        for (var row = 1; row < table.rows.length; row++) {
          try {
            final currentRow = table.rows[row];
            if (currentRow.length >= 7 && currentRow[0] != null) {
              print('Traitement ligne $row: ${currentRow.join(", ")}');

              // Nettoyer et parser les valeurs numériques
              String priceStr = currentRow[2].toString().replaceAll('€', '').replaceAll(' ', '').trim();
              String amountStr = currentRow[3].toString().replaceAll('€', '').replaceAll(' ', '').trim();
              String quantityStr = currentRow[4].toString().replaceAll(',', '.').trim();

              transactions.add(Transaction(
                name: currentRow[0].toString(),
                symbol: currentRow[1].toString(),
                price: double.tryParse(priceStr.replaceAll(',', '.')) ?? 0,
                amount: double.tryParse(amountStr.replaceAll(',', '.')) ?? 0,
                quantity: double.tryParse(quantityStr) ?? 0,
                orderType: currentRow[5].toString(),
                date: DateTime.tryParse(currentRow[6].toString()) ?? DateTime.now(),
              ));
            }
          } catch (e) {
            print('Erreur lors du parsing de la ligne $row: $e');
          }
        }

        print('Nombre de transactions chargées: ${transactions.length}');
        return transactions;
      } else {
        print('Erreur lors du téléchargement: ${response.statusCode}');
        throw Exception('Impossible de télécharger le fichier: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur globale: $e');
      return [];
    }
  }
}