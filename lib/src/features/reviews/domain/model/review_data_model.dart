import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_data_model.freezed.dart';
part 'review_data_model.g.dart';

@freezed
class ReviewDataModel with _$ReviewDataModel {
  const factory ReviewDataModel({
    required String reviewerName,
    required double reviewStars,
    required String description,
    required DateTime reviewDate,
  }) = _ReviewDataModel;

  const ReviewDataModel._();

  factory ReviewDataModel.fromJson(Map<String, Object?> json) =>
      _$ReviewDataModelFromJson(json);
}
