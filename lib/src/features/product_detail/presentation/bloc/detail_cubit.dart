import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';
import 'package:shoesly_ps/src/core/helper/firebase_image_helper.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/get_reviews_usecase_input.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';
import 'package:shoesly_ps/src/features/reviews/domain/usecase/get_reviews_usecase.dart';

part 'detail_cubit.freezed.dart';

part 'detail_state.dart';

@injectable
class DetailCubit extends Cubit<DetailState> {
  DetailCubit(
    @factoryParam ShoeDataModel shoe,
    this._getReviewsUsecase,
  ) : super(
          const DetailState(
            detailLoadingState: DetailLoadingState.initial(),
          ),
        ) {
    _initialize(shoe);
  }

  void _initialize(ShoeDataModel shoe) {
    emit(
      state.copyWith(shoe: shoe),
    );
    _getReviews();
    _getShoeImages(shoe);
    setSelectedSize(shoe.availableSizes.first);
  }

  final GetReviewsUsecase _getReviewsUsecase;

  Future<void> _getReviews() async {
    emit(
      state.copyWith(
        detailLoadingState: const DetailLoadingState.loading(),
      ),
    );
    final response = await _getReviewsUsecase
        .execute(
          GetReviewsUsecaseInput(
            shoeId: state.shoe!.shoeId,
            limit: 3,
          ),
        )
        .run();

    response.match(
      (exception) => emit(
        state.copyWith(
          detailLoadingState: DetailLoadingState.xception(
            exception: exception,
          ),
        ),
      ),
      (reviewResponseModel) async {
        emit(
          state.copyWith(
            reviews: reviewResponseModel.reviews,
            detailLoadingState: const DetailLoadingState.success(),
          ),
        );
      },
    );
  }

  Future<void> _getShoeImages(ShoeDataModel shoe) async {
    final imageUrls = await Future.wait(
      shoe.images.map(
        (imagePath) async =>
            await FirebaseImageHelper.getDownloadUrl(imagePath),
      ),
    );
    emit(
      state.copyWith(shoeImages: imageUrls),
    );
  }

  void setSelectedSize(double? size) {
    emit(
      state.copyWith(selectedSize: size),
    );
  }

  void setCurrentImage(int index) {
    emit(
      state.copyWith(currentImageIndex: index),
    );
  }

  void setCurrentColor(int index) {
    emit(
      state.copyWith(currentColorIndex: index),
    );
  }

  /// Increases quantity by one
  void increaseQuantity() {
    emit(
      state.copyWith(quantity: state.quantity + 1),
    );
  }

  /// Decreases quantity by one
  void decreaseQuantity() {
    if (state.quantity == 1) {
      return;
    }

    emit(
      state.copyWith(quantity: state.quantity - 1),
    );
  }
}
