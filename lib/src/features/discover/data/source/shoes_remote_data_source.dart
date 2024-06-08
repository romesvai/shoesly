import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/firestore_constants.dart';
import 'package:shoesly_ps/src/features/discover/data/model/shoes_response_model.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

abstract class ShoesRemoteDataSource {
  Future<ShoesResponseModel> getShoes({
    DocumentSnapshot? lastDocument,
    required int limit,
  });
}

@Injectable(as: ShoesRemoteDataSource)
class ShoesRemoteDataSourceImpl implements ShoesRemoteDataSource {
  ShoesRemoteDataSourceImpl(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<ShoesResponseModel> getShoes({
    DocumentSnapshot<Object?>? lastDocument,
    required int limit,
  }) async {
    final query =
        _firebaseFirestore.collection(shoesCollection).limit(limit + 1);
    if (lastDocument != null) {
      query.startAfterDocument(lastDocument);
    }
    final response = await query
        .withConverter(
          fromFirestore: (snapshot, _) => ShoeDataModel.fromFirestore(snapshot),
          toFirestore: (shoeDataModel, _) => shoeDataModel.toJson(),
        )
        .get();

    final data =
        response.docs.map((snapshot) => snapshot.data()).take(3).toList();
    final moreDocumentsFlag = hasMoreDocuments(response, limit);
    DocumentSnapshot? lastDocumentFromResponse;
    if (response.docs.isNotEmpty) {
      lastDocumentFromResponse = response.docs[data.length - 1];
    }
    return ShoesResponseModel(
        shoes: data.take(limit).toList(),
        hasMoreDocuments: moreDocumentsFlag,
        lastDocument: lastDocumentFromResponse);
  }

  bool hasMoreDocuments(QuerySnapshot<ShoeDataModel> response, int limit) =>
      response.docs.length == limit + 1;
}
