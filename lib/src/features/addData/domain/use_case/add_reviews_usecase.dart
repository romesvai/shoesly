import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/base/base_usecase.dart';
import 'package:shoesly_ps/src/core/mixins/exception_mixin.dart';
import 'package:shoesly_ps/src/core/typedef/either_exception.dart';
import 'package:shoesly_ps/src/features/addData/domain/model/add_reviews_usecase_input.dart';

import 'package:shoesly_ps/src/features/addData/domain/repository/add_data_repository.dart';

@injectable
class AddReviewsUseCase
    with ExceptionMixin
    implements BaseUsecase<AddReviewsUsecaseInput, Unit> {
  AddReviewsUseCase(this._addDataRepository);
  final AddDataRepository _addDataRepository;

  @override
  EitherException<Unit> execute(AddReviewsUsecaseInput input) =>
      tryCatch(() async {
        await _addDataRepository.addReviews(
          reviews: input.reviews,
          shoeDocId: input.shoeDocId,
        );
        return unit;
      });
}
