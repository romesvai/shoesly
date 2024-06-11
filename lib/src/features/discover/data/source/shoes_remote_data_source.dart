import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/firestore_constants.dart';
import 'package:shoesly_ps/src/core/constants/string_constants.dart';
import 'package:shoesly_ps/src/core/mixins/network_connection_mixin.dart';
import 'package:shoesly_ps/src/features/addData/data/model/brands_response_model.dart';
import 'package:shoesly_ps/src/features/discover/data/model/shoes_response_model.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/get_shoes_usecase_input.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';

abstract class ShoesRemoteDataSource {
  Future<ShoesResponseModel> getShoes({required GetShoesUsecaseInput input});

  Future<List<String>> getBrands();
}

@Injectable(as: ShoesRemoteDataSource)
class ShoesRemoteDataSourceImpl
    with NetworkConnectionMixin
    implements ShoesRemoteDataSource {
  ShoesRemoteDataSourceImpl(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<ShoesResponseModel> getShoes({
    required GetShoesUsecaseInput input,
  }) async {
    await checkNetworkConnection();
    final limit = input.limit;
    final lastDocument = input.lastDocument;
    Query<Map<String, dynamic>> query =
        _firebaseFirestore.collection(shoesCollection);

    query = applyFilter(input, query);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final response = await query
        .limit(limit + 1)
        .withConverter(
          fromFirestore: (snapshot, _) => ShoeDataModel.fromFirestore(snapshot),
          toFirestore: (shoeDataModel, _) => shoeDataModel.toJson(),
        )
        .get();

    final data =
        response.docs.map((snapshot) => snapshot.data()).take(limit).toList();
    final moreDocumentsFlag = hasMoreDocuments(response, limit);
    DocumentSnapshot? lastDocumentFromResponse;
    if (response.docs.isNotEmpty) {
      lastDocumentFromResponse = response.docs[data.length - 1];
    }
    return ShoesResponseModel(
      shoes: data.take(limit).toList(),
      hasMoreDocuments: moreDocumentsFlag,
      lastDocument: lastDocumentFromResponse,
    );
  }

  Query<Map<String, dynamic>> applyFilter(
      GetShoesUsecaseInput input, Query<Map<String, dynamic>> query) {
    if (input.priceRange != null) {
      query = query
          .where(
            priceKey,
            isLessThanOrEqualTo: input.priceRange!.maxPrice,
          )
          .where(
            priceKey,
            isGreaterThanOrEqualTo: input.priceRange!.minPrice,
          );
    }

    if (input.sortBy != null) {
      switch (input.sortBy) {
        case mostRecent:
          query = query.orderBy(
            releaseDataKey,
            descending: true,
          );
          break;
        case lowestPrice:
          query = query.orderBy(
            priceKey,
          );
          break;
        case highestReviews:
          query = query.orderBy(
            totalReviewsKey,
            descending: true,
          );
          break;
      }
    }

    if (input.brand != null) {
      query = query.where(
        shoeBrandKey,
        isEqualTo: input.brand,
      );
    }

    if (input.gender != null) {
      query = query.where(
        genderTypeKey,
        isEqualTo: input.gender!.toLowerCase(),
      );
    }

    if (input.color != null) {
      query = query.where(
        availableColorsKey,
        arrayContains: input.color!,
      );
    }
    return query;
  }

  bool hasMoreDocuments(QuerySnapshot<ShoeDataModel> response, int limit) =>
      response.docs.length == limit + 1;

  @override
  Future<List<String>> getBrands() async {
    await checkNetworkConnection();
    final response = await _firebaseFirestore
        .collection(brandsCollection)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                BrandsResponseModel.fromFirestore(snapshot),
            toFirestore: (value, _) => value.toJson())
        .get();
    return response.docs.map((brand) => brand.data().brandName).toList();
  }
}
