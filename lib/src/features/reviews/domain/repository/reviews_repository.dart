import 'package:shoesly_ps/src/features/reviews/data/model/reviews_response_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/get_reviews_usecase_input.dart';

abstract class ReviewsRepository {
  Future<ReviewsResponseModel> getReviews(
      GetReviewsUsecaseInput reviewsRequestModel);
}
