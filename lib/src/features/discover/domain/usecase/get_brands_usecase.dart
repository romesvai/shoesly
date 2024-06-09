import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/base/base_usecase.dart';
import 'package:shoesly_ps/src/core/mixins/exception_mixin.dart';
import 'package:shoesly_ps/src/core/typedef/either_exception.dart';
import 'package:shoesly_ps/src/features/discover/domain/repository/shoes_repository.dart';

@injectable
class GetBrandsUsecase
    with ExceptionMixin
    implements BaseUsecase<Unit, List<String>> {
  GetBrandsUsecase(this._shoesRepository);

  final ShoesRepository _shoesRepository;

  @override
  EitherException<List<String>> execute(Unit input) =>
      tryCatch(_shoesRepository.getBrands);
}
