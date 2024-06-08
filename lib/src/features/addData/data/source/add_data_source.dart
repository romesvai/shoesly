import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/firestore_constants.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

abstract class AddDataSource {
  Future<void> addShoes(List<ShoeDataModel> shoes);

  Future<void> addReviews({
    required List<ReviewDataModel> reviews,
    required String shoeDocId,
  });
}

@Injectable(as: AddDataSource)
class AddDataRemoteSourceImpl implements AddDataSource {
  AddDataRemoteSourceImpl(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;
  @override
  Future<void> addReviews({
    required List<ReviewDataModel> reviews,
    required String shoeDocId,
  }) async {
    WriteBatch batch = _firebaseFirestore.batch();
    final shoeDocRef =
        _firebaseFirestore.collection(shoesCollection).doc(shoeDocId);
    final reviewCollectionRef = shoeDocRef.collection(reviewsCollection);
    final totalReviews = reviews.length;
    final averageRating = reviews.fold(0.0,
            (previousValue, review) => previousValue + review.reviewStars) /
        reviews.length;
    batch.update(shoeDocRef,
        {'averageRating': averageRating, 'totalReviews': totalReviews});
    for (ReviewDataModel review in reviews) {
      batch.set(reviewCollectionRef.doc(), review.toJson());
    }
    return await batch.commit();
  }

  @override
  Future<void> addShoes(List<ShoeDataModel> shoes) async {
    WriteBatch batch = _firebaseFirestore.batch();
    final collectionRef = _firebaseFirestore.collection(shoesCollection);
    for (ShoeDataModel shoe in shoes) {
      batch.set(collectionRef.doc(shoe.shoeId), shoe.toJson());
    }
    return await batch.commit();
  }
}
