import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

part 'reviews_response_model.freezed.dart';

@freezed
class ReviewsResponseModel with _$ReviewsResponseModel {
  const factory ReviewsResponseModel({
    required List<ReviewDataModel> reviews,
    required bool hasMoreDocuments,
    DocumentSnapshot? lastDocument,
  }) = _ReviewsResponseModel;

  const ReviewsResponseModel._();
}
