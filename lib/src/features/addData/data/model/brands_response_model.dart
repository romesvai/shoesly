import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brands_response_model.freezed.dart';

part 'brands_response_model.g.dart';

@freezed
class BrandsResponseModel with _$BrandsResponseModel {
  const factory BrandsResponseModel({
    required String brandName,
  }) = _BrandsResponseModel;

  const BrandsResponseModel._();

  factory BrandsResponseModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();

    if (data == null) {
      return BrandsResponseModel.fromJson({'brandName': ''});
    } else {
      return BrandsResponseModel.fromJson(data);
    }
  }

  factory BrandsResponseModel.fromJson(Map<String, Object?> json) =>
      _$BrandsResponseModelFromJson(json);
}
