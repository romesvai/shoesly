import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/base/base_usecase.dart';
import 'package:shoesly_ps/src/core/mixins/exception_mixin.dart';
import 'package:shoesly_ps/src/core/typedef/either_exception.dart';
import 'package:shoesly_ps/src/features/reviews/data/model/reviews_response_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/get_reviews_usecase_input.dart';
import 'package:shoesly_ps/src/features/reviews/domain/repository/reviews_repository.dart';

@injectable
class GetReviewsUsecase
    with ExceptionMixin
    implements BaseUsecase<GetReviewsUsecaseInput, ReviewsResponseModel> {
  GetReviewsUsecase(this._reviewsRepository);

  final ReviewsRepository _reviewsRepository;

  @override
  EitherException<ReviewsResponseModel> execute(GetReviewsUsecaseInput input) =>
      tryCatch(
        () async => _reviewsRepository.getReviews(input),
      );
}
