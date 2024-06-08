import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/core/enums/gender_type.dart';

part 'shoe_data_model.freezed.dart';

part 'shoe_data_model.g.dart';

@freezed
class ShoeDataModel with _$ShoeDataModel {
  const factory ShoeDataModel({
    @Default('') String shoeId,
    @Default('') String name,
    @Default('') String brand,
    @Default(0.0) double price,
    @Default([]) List<double> availableSizes,
    @Default('') String description,
    @Default([]) List<String> availableColors,
    @Default([]) List<String> images,
    DateTime? releaseDate,
    double? averageRating,
    int? totalReviews,
    @Default(GenderType.unisex) GenderType genderType,
  }) = _ShoeDataModel;

  factory ShoeDataModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      return ShoeDataModel.fromJson({});
    } else {
      return ShoeDataModel.fromJson(data);
    }
  }

  const ShoeDataModel._();

  factory ShoeDataModel.fromJson(Map<String, Object?> json) =>
      _$ShoeDataModelFromJson(json);
}
