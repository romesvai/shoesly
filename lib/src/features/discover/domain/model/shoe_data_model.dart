import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/core/enums/gender_type.dart';

part 'shoe_data_model.freezed.dart';
part 'shoe_data_model.g.dart';

@freezed
class ShoeDataModel with _$ShoeDataModel {
  const factory ShoeDataModel({
    required String name,
    required String brand,
    required double price,
    required List<double> availableSizes,
    required String description,
    required List<String> availableColors,
    required List<String> images,
    required DateTime releaseDate,
    double? averageRating,
    int? totalReviews,
    @Default(GenderType.unisex) GenderType genderType,
  }) = _ShoeDataModel;

  const ShoeDataModel._();

  factory ShoeDataModel.fromJson(Map<String, Object?> json) =>
      _$ShoeDataModelFromJson(json);
}
