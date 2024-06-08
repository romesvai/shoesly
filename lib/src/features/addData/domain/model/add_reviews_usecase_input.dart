import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

part 'add_reviews_usecase_input.freezed.dart';

@freezed
class AddReviewsUsecaseInput with _$AddReviewsUsecaseInput {
  const factory AddReviewsUsecaseInput({
    required List<ReviewDataModel> reviews,
    required String shoeDocId,
  }) = _AddReviewsUsecaseInput;

  const AddReviewsUsecaseInput._();
}
