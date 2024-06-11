import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/features/discover/data/model/shoes_response_model.dart';
import 'package:shoesly_ps/src/features/discover/data/source/shoes_remote_data_source.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/get_shoes_usecase_input.dart';
import 'package:shoesly_ps/src/features/discover/domain/repository/shoes_repository.dart';

@Injectable(as: ShoesRepository)
class ShoesRepositoryImpl implements ShoesRepository {
  ShoesRepositoryImpl(this._shoesRemoteDataSource);

  final ShoesRemoteDataSource _shoesRemoteDataSource;

  @override
  Future<ShoesResponseModel> getShoes({required GetShoesUsecaseInput input}) =>
      _shoesRemoteDataSource.getShoes(
        input: input,
      );

  @override
  Future<List<String>> getBrands() => _shoesRemoteDataSource.getBrands();
}
