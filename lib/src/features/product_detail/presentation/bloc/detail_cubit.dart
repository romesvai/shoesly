import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/string_constants.dart';
import 'package:shoesly_ps/src/core/exceptions/app_exception.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';
import 'package:shoesly_ps/src/core/helper/firebase_image_helper.dart';
import 'package:shoesly_ps/src/features/cart/domain/model/cart_item_data_model.dart';
import 'package:shoesly_ps/src/features/cart/domain/usecase/add_cart_item_usecase.dart';
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
    this._addCartItemUsecase,
  ) : super(
          const DetailState(
            detailLoadingState: DetailLoadingState.initial(),
          ),
        ) {
    _initialize(shoe);
  }

  final GetReviewsUsecase _getReviewsUsecase;
  final AddCartItemUsecase _addCartItemUsecase;

  void _initialize(ShoeDataModel shoe) {
    emit(
      state.copyWith(shoe: shoe),
    );
    _getReviews();
    _getShoeImages(shoe);
    setSelectedSize(shoe.availableSizes.first);
  }

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

  Future<void> addItemToCart() async {
    if (state.shoe == null) {
      return;
    }
    if (state.selectedSize == null) {
      emit(
        state.copyWith(
          detailLoadingState: const DetailLoadingState.xception(
            exception: AppException.other(selectSize),
          ),
        ),
      );
    }
    final shoe = state.shoe!;
    final cartItem = CartItemDataModel(
      id: shoe.shoeId,
      itemName: shoe.name,
      size: state.selectedSize!.toInt(),
      color: shoe.availableColors[state.currentColorIndex],
      brand: shoe.brand,
      quantity: state.quantity,
      price: shoe.price,
      imagePath: shoe.images.first,
    );

    final response = await _addCartItemUsecase.execute(cartItem).run();

    emit(
      response.fold(
        (exception) => state.copyWith(
          detailLoadingState: DetailLoadingState.xception(exception: exception),
        ),
        (_) => state.copyWith(
          detailLoadingState: const DetailLoadingState.addToCartSuccess(),
        ),
      ),
    );
  }

  void resetAddToCartSuccess() {
    emit(
      state.copyWith(
        detailLoadingState: const DetailLoadingState.success(),
      ),
    );
  }
}
