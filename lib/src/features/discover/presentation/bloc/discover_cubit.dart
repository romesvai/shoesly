import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/shoes_constants.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';
import 'package:shoesly_ps/src/features/addData/domain/model/add_reviews_usecase_input.dart';
import 'package:shoesly_ps/src/features/addData/domain/model/add_shoes_usecase_input.dart';
import 'package:shoesly_ps/src/features/addData/domain/usecase/add_reviews_usecase.dart';
import 'package:shoesly_ps/src/features/addData/domain/usecase/add_shoes_usecase.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/get_shoes_usecase_input.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/discover/domain/usecase/get_shoes_usecase.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

part 'discover_cubit.freezed.dart';

part 'discover_state.dart';

@injectable
class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(
    this._addShoesUseCase,
    this._addReviewsUseCase,
    this._getShoesUsecase,
  ) : super(
          const DiscoverState(
            discoverLoadingState: DiscoverLoadingState.initial(),
          ),
        ) {
    getShoes();
  }

  final AddShoesUsecase _addShoesUseCase;
  final AddReviewsUseCase _addReviewsUseCase;
  final GetShoesUsecase _getShoesUsecase;

  void addShoes() async {
    _addShoesUseCase
        .execute(
          AddShoesUsecaseInput(shoes: shoes),
        )
        .run();
  }

  void addReviews() async {
    _addReviewsUseCase
        .execute(
          AddReviewsUsecaseInput(
              reviews: generateReviews(), shoeDocId: 'wQjrmprJXU6INlxlg3ak'),
        )
        .run();
  }

  Future<void> getShoes() async {
    emit(
      state.copyWith(
        discoverLoadingState: const DiscoverLoadingState.loading(),
      ),
    );

    final response = await _getShoesUsecase
        .execute(
          GetShoesUsecaseInput(
            lastDocument: state.lastDocument,
            limit: 3,
          ),
        )
        .run();

    emit(
      response.fold(
        (exception) => state.copyWith(
          discoverLoadingState: DiscoverLoadingState.xception(
            exception: exception,
          ),
        ),
        (shoesResponseModel) => state.copyWith(
          hasMoreDocuments: shoesResponseModel.hasMoreDocuments,
          lastDocument: shoesResponseModel.lastDocument,
        ),
      ),
    );
  }
}
