import 'package:shoesly_ps/src/features/discover/data/model/shoes_response_model.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/get_shoes_usecase_input.dart';

abstract class ShoesRepository {
  Future<ShoesResponseModel> getShoes({
    required GetShoesUsecaseInput input,
  });

  Future<List<String>> getBrands();
}
