import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/base/base_usecase.dart';
import 'package:shoesly_ps/src/core/mixins/exception_mixin.dart';
import 'package:shoesly_ps/src/core/typedef/either_exception.dart';
import 'package:shoesly_ps/src/features/discover/data/model/shoes_response_model.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/get_shoes_usecase_input.dart';
import 'package:shoesly_ps/src/features/discover/domain/repository/shoes_repository.dart';

@injectable
class GetShoesUsecase
    with ExceptionMixin
    implements BaseUsecase<GetShoesUsecaseInput, ShoesResponseModel> {
  GetShoesUsecase(this._shoesRepository);

  final ShoesRepository _shoesRepository;

  @override
  EitherException<ShoesResponseModel> execute(GetShoesUsecaseInput input) =>
      tryCatch(() async {
        final response = await _shoesRepository.getShoes(
          lastDocument: input.lastDocument,
          limit: input.limit,
          brand: input.brand,
        );
        return response;
      });
}
