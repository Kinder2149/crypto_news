// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CryptoDataAdapter extends TypeAdapter<CryptoData> {
  @override
  final int typeId = 0;

  @override
  CryptoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CryptoData(
      id: fields[0] as String,
      symbol: fields[1] as String,
      name: fields[2] as String,
      image: fields[3] as String,
      currentPrice: fields[4] as double,
      priceChangePercentage24h: fields[5] as double,
      priceChangePercentage7d: fields[6] as double,
      marketCap: fields[7] as double,
      marketCapRank: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CryptoData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.currentPrice)
      ..writeByte(5)
      ..write(obj.priceChangePercentage24h)
      ..writeByte(6)
      ..write(obj.priceChangePercentage7d)
      ..writeByte(7)
      ..write(obj.marketCap)
      ..writeByte(8)
      ..write(obj.marketCapRank);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CryptoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
