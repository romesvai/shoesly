import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';

abstract class AddDataRepository {
  Future<void> addShoes(List<ShoeDataModel> shoes);

  Future<void> addReviews(String shoeId);
}
