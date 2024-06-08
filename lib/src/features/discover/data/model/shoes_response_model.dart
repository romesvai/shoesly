import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';

part 'shoes_response_model.freezed.dart';

@freezed
class ShoesResponseModel with _$ShoesResponseModel {
  const factory ShoesResponseModel({
    required List<ShoeDataModel> shoes,
    required bool hasMoreDocuments,
    DocumentSnapshot? lastDocument,
  }) = _ShoesResponseModel;

  const ShoesResponseModel._();
}
