import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/features/reviews/data/model/reviews_response_model.dart';
import 'package:shoesly_ps/src/features/reviews/data/source/reviews_remote_data_source.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/get_reviews_usecase_input.dart';
import 'package:shoesly_ps/src/features/reviews/domain/repository/reviews_repository.dart';

@Injectable(as: ReviewsRepository)
class ReviewsRepositoryImpl implements ReviewsRepository {
  ReviewsRepositoryImpl(this._reviewsRemoteSource);

  final ReviewsRemoteSource _reviewsRemoteSource;

  @override
  Future<ReviewsResponseModel> getReviews(
          GetReviewsUsecaseInput reviewsRequestModel) =>
      _reviewsRemoteSource.getReviews(reviewsRequestModel: reviewsRequestModel);
}
