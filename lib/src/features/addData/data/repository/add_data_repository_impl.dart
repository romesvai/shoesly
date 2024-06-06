import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/features/addData/data/source/add_data_source.dart';
import 'package:shoesly_ps/src/features/addData/domain/repositories/add_data_repository.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';

@Injectable(as: AddDataRepository)
class AddDataRepositoryImpl implements AddDataRepository {
  AddDataRepositoryImpl(this._addDataSource);
  final AddDataSource _addDataSource;
  @override
  Future<void> addReviews(String shoeId) async {
    // TODO: implement addReviews
  }

  @override
  Future<void> addShoes(List<ShoeDataModel> shoes) {
    return _addDataSource.addShoes(shoes);
  }
}
