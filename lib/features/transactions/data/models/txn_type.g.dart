// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TxnTypeAdapter extends TypeAdapter<TxnType> {
  @override
  final int typeId = 3;

  @override
  TxnType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TxnType.income;
      case 1:
        return TxnType.expense;
      default:
        return TxnType.income;
    }
  }

  @override
  void write(BinaryWriter writer, TxnType obj) {
    switch (obj) {
      case TxnType.income:
        writer.writeByte(0);
        break;
      case TxnType.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TxnTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
