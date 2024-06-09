import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/core/constants/number_constants.dart';

part 'get_reviews_usecase_input.freezed.dart';

@freezed
class GetReviewsUsecaseInput with _$GetReviewsUsecaseInput {
  const factory GetReviewsUsecaseInput({
    required String shoeId,
    @Default(defaultPaginationLimit) int limit,
    DocumentSnapshot? lastDocument,

    /// filter the data by stars
    int? stars,
  }) = _GetReviewsUsecaseInput;

  const GetReviewsUsecaseInput._();
}
