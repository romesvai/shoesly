import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/firestore_constants.dart';
import 'package:shoesly_ps/src/features/reviews/data/model/reviews_response_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/get_reviews_usecase_input.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

abstract class ReviewsRemoteSource {
  Future<ReviewsResponseModel> getReviews({
    required GetReviewsUsecaseInput reviewsRequestModel,
  });
}

@Injectable(as: ReviewsRemoteSource)
class ReviewsRemoteSourceImpl implements ReviewsRemoteSource {
  ReviewsRemoteSourceImpl(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<ReviewsResponseModel> getReviews({
    required GetReviewsUsecaseInput reviewsRequestModel,
  }) async {
    final limit = reviewsRequestModel.limit;
    Query<Map<String, dynamic>> query = _firebaseFirestore
        .collection(shoesCollection)
        .doc(reviewsRequestModel.shoeId)
        .collection(reviewsCollection)
        .limit(limit + 1);

    if (reviewsRequestModel.stars != null) {
      query = query.where(
        reviewStarsKey,
        isEqualTo: reviewsRequestModel.stars,
      );
    }
    if (reviewsRequestModel.lastDocument != null) {
      query = query.startAfterDocument(reviewsRequestModel.lastDocument!);
    }
    final response = await query
        .withConverter(
          fromFirestore: (snapshot, _) =>
              ReviewDataModel.fromFirestore(snapshot),
          toFirestore: (reviewDataModel, _) => reviewDataModel.toJson(),
        )
        .get();

    final data =
        response.docs.map((snapshot) => snapshot.data()).take(limit).toList();
    final moreDocumentsFlag = hasMoreDocuments(response, limit);
    DocumentSnapshot? lastDocumentFromResponse;
    if (response.docs.isNotEmpty) {
      lastDocumentFromResponse = response.docs[data.length - 1];
    }
    return ReviewsResponseModel(
      reviews: data.take(limit).toList(),
      hasMoreDocuments: moreDocumentsFlag,
      lastDocument: lastDocumentFromResponse,
    );
  }

  bool hasMoreDocuments(QuerySnapshot<ReviewDataModel> response, int limit) =>
      response.docs.length == limit + 1;
}
