// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClaimModelAdapter extends TypeAdapter<ClaimModel> {
  @override
  final int typeId = 2;

  @override
  ClaimModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClaimModel(
        id: fields[0] as String?,
        employeeId: fields[1] as String?,
        description: fields[2] as String?,
        amount: fields[3] as double?,
        date: fields[4] as DateTime?,
        receiptFileName: fields[7] as String?,
        reviewerId: fields[8] as String?,
        reviewDate: fields[9] as DateTime?,
        reviewComments: fields[10] as String?,
        createdAt: fields[11] as DateTime?,
      )
      .._categoryValue = fields[5] as String?
      .._statusValue = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, ClaimModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.employeeId)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj._categoryValue)
      ..writeByte(6)
      ..write(obj._statusValue)
      ..writeByte(7)
      ..write(obj.receiptFileName)
      ..writeByte(8)
      ..write(obj.reviewerId)
      ..writeByte(9)
      ..write(obj.reviewDate)
      ..writeByte(10)
      ..write(obj.reviewComments)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClaimModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
