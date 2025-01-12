import 'package:hive/hive.dart';

part 'crypto_data.g.dart';

@HiveType(typeId: 0)
class CryptoData extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String symbol;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final double currentPrice;

  @HiveField(5)
  final double priceChangePercentage24h;

  @HiveField(6)
  final double priceChangePercentage7d;

  @HiveField(7)
  final double marketCap;

  @HiveField(8)
  final int marketCapRank;

  CryptoData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.priceChangePercentage7d,
    required this.marketCap,
    required this.marketCapRank,
  });

  factory CryptoData.fromJson(Map<String, dynamic> json) {
    return CryptoData(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      priceChangePercentage7d: (json['price_change_percentage_7d'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
    );
  }
}