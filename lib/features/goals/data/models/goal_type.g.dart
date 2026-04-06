// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalTypeAdapter extends TypeAdapter<GoalType> {
  @override
  final int typeId = 4;

  @override
  GoalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalType.monthlySavings;
      case 1:
        return GoalType.budgetLimit;
      case 2:
        return GoalType.noSpendChallenge;
      case 3:
        return GoalType.weeklyTarget;
      default:
        return GoalType.monthlySavings;
    }
  }

  @override
  void write(BinaryWriter writer, GoalType obj) {
    switch (obj) {
      case GoalType.monthlySavings:
        writer.writeByte(0);
        break;
      case GoalType.budgetLimit:
        writer.writeByte(1);
        break;
      case GoalType.noSpendChallenge:
        writer.writeByte(2);
        break;
      case GoalType.weeklyTarget:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
