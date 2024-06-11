import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cart_item_data_model.freezed.dart';

part 'cart_item_data_model.g.dart';

@freezed
@HiveType(typeId: 0)
class CartItemDataModel with _$CartItemDataModel {
  const factory CartItemDataModel({
    @HiveField(0) required String id,
    @HiveField(1) required String itemName,
    @HiveField(2) required int size,
    @HiveField(3) required String color,
    @HiveField(4) required String brand,
    @HiveField(5) required int quantity,
    @HiveField(6) required double price,
    @HiveField(7) required String imagePath,
  }) = _CartItemDataModel;

  const CartItemDataModel._();

  factory CartItemDataModel.fromJson(Map<String, Object?> json) =>
      _$CartItemDataModelFromJson(json);
}
