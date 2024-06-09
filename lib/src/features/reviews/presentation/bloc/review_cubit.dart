import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/shoesly_constants.dart';
import 'package:shoesly_ps/src/core/constants/string_constants.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/discover/presentation/bloc/discover_cubit.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/get_reviews_usecase_input.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/usecase/get_reviews_usecase.dart';

part 'review_cubit.freezed.dart';

part 'review_state.dart';

@injectable
class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(
    @factoryParam ShoeDataModel shoe,
    this._getReviewsUsecase,
  ) : super(
          const ReviewState(
            reviewLoadingState: ReviewLoadingState.initial(),
          ),
        ) {
    _initialize(shoe);
  }

  void _initialize(ShoeDataModel shoe) {
    emit(
      state.copyWith(shoeId: shoe.shoeId),
    );
    _getReviews();
  }

  final GetReviewsUsecase _getReviewsUsecase;

  Future<void> _getReviews({
    bool isForPagination = false,
    bool shouldReset = false,
  }) async {
    emit(
      state.copyWith(
        reviewLoadingState: const ReviewLoadingState.loading(),
      ),
    );

    final currentSelectedStarFilter =
        state.stars.firstWhere((star) => star.isSelected);

    final response = await _getReviewsUsecase
        .execute(
          GetReviewsUsecaseInput(
            shoeId: state.shoeId ?? '',
            stars: currentSelectedStarFilter.displayName == all
                ? null
                : getStarFromDisplayName(
                    currentSelectedStarFilter.displayName,
                  ),
            lastDocument: state.lastDocument,
          ),
        )
        .run();

    response.match(
      (exception) => emit(
        state.copyWith(
          reviewLoadingState: ReviewLoadingState.xception(
            exception: exception,
          ),
        ),
      ),
      (reviewsResponseModel) async {
        emit(
          state.copyWith(
            hasMoreDocuments: reviewsResponseModel.hasMoreDocuments,
            lastDocument: reviewsResponseModel.lastDocument,
            reviews: isForPagination && !shouldReset
                ? [...state.reviews ?? [], ...reviewsResponseModel.reviews]
                : reviewsResponseModel.reviews,
            reviewLoadingState: const ReviewLoadingState.success(),
          ),
        );
      },
    );
  }

  void selectStarFilter(SelectableDataState selectedStar) {
    final currentStars = List<SelectableDataState>.from(state.stars);
    final updatedStars = currentStars.map((star) {
      if (star.displayName == selectedStar.displayName) {
        return star.copyWith(isSelected: true);
      } else {
        return star.copyWith(isSelected: false);
      }
    }).toList();

    emit(
      state.copyWith(
        stars: updatedStars,
        lastDocument: null,
        hasMoreDocuments: true,
        reviews: null,
      ),
    );

    _getReviews(
      shouldReset: true,
    );
  }

  void fetchAnotherPage() {
    if (state.reviewLoadingState == const ReviewLoadingState.loading()) {
      return;
    }
    emit(
      state.copyWith(
        reviewLoadingState: const ReviewLoadingState.paginationLoading(),
      ),
    );
    _getReviews(isForPagination: true);
  }

  int? getStarFromDisplayName(String starFilter) {
    switch (starFilter) {
      case oneStar:
        return 1;
      case twoStar:
        return 2;
      case threeStar:
        return 3;
      case fourStar:
        return 4;
      case fiveStar:
        return 5;
      default:
        return null;
    }
  }
}
