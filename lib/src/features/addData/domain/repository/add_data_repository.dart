import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

abstract class AddDataRepository {
  Future<void> addShoe(ShoeDataModel shoe);

  Future<void> addReviews({
    required List<ReviewDataModel> reviews,
    required String shoeDocId,
  });
}
