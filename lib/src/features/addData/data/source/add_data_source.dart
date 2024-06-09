import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/firestore_constants.dart';
import 'package:shoesly_ps/src/features/addData/data/model/brands_response_model.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

abstract class AddDataSource {
  Future<void> addShoes(ShoeDataModel shoe);

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
  Future<void> addShoes(ShoeDataModel shoe) async {
    WriteBatch batch = _firebaseFirestore.batch();
    final newBrand = await getBrandIfNew(shoe);
    if (newBrand != null) {
      batch.set(
          _firebaseFirestore.collection(brandsCollection).doc(), newBrand);
    }
    final collectionRef = _firebaseFirestore.collection(shoesCollection);
    batch.set(collectionRef.doc(shoe.shoeId), shoe.toJson());
    return await batch.commit();
  }

  Future<String?> getBrandIfNew(ShoeDataModel shoe) async {
    final brands = await _firebaseFirestore
        .collection(brandsCollection)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                BrandsResponseModel.fromJson(snapshot.data()!),
            toFirestore: (value, _) => value.toJson())
        .get();
    String? uniqueBrand;
    for (var brand in brands.docs) {
      if (brand.data().brandName != shoe.brand) {
        uniqueBrand = shoe.brand;
      }
    }
    return uniqueBrand;
  }
}
