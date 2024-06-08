import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/features/discover/data/model/shoes_response_model.dart';
import 'package:shoesly_ps/src/features/discover/data/source/shoes_remote_data_source.dart';
import 'package:shoesly_ps/src/features/discover/domain/repository/shoes_repository.dart';

@Injectable(as: ShoesRepository)
class ShoesRepositoryImpl implements ShoesRepository {
  ShoesRepositoryImpl(this._shoesRemoteDataSource);

  final ShoesRemoteDataSource _shoesRemoteDataSource;

  @override
  Future<ShoesResponseModel> getShoes({
    DocumentSnapshot<Object?>? lastDocument,
    int limit = 10,
  }) =>
      _shoesRemoteDataSource.getShoes(
        lastDocument: lastDocument,
        limit: limit,
      );
}
