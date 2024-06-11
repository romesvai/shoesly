import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';
import 'package:shoesly_ps/src/core/helper/firebase_image_helper.dart';
import 'package:shoesly_ps/src/features/cart/domain/model/cart_item_data_model.dart';
import 'package:shoesly_ps/src/features/cart/domain/usecase/get_cart_item_usecase.dart';
import 'package:shoesly_ps/src/features/cart/domain/usecase/remove_cart_item_usecase.dart';

part 'cart_cubit.freezed.dart';

part 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  CartCubit(
    this._getCartItemUsecase,
    this._removeCartItemUsecase,
  ) : super(
          const CartState(
            cartLoadingState: CartLoadingState.initial(),
          ),
        ) {
    getCartItems();
  }

  final GetCartItemUsecase _getCartItemUsecase;
  final RemoveCartItemUsecase _removeCartItemUsecase;

  void getCartItems() async {
    final response = await _getCartItemUsecase.execute(unit).run();
    emit(
      response.fold(
        (exception) => state.copyWith(
          cartLoadingState: CartLoadingState.xception(exception: exception),
        ),
        (cartItems) => state.copyWith(
          cartItems: cartItems,
        ),
      ),
    );
    _getCartItemImages(state.cartItems!);
  }

  void removeCartItem(CartItemDataModel cartItem) async {
    final response = await _removeCartItemUsecase.execute(cartItem).run();
    emit(
      response.fold(
        (exception) => state.copyWith(
          cartLoadingState: CartLoadingState.xception(exception: exception),
        ),
        (cartItems) => state.copyWith(),
      ),
    );

    getCartItems();
  }

  Future<void> _getCartItemImages(List<CartItemDataModel> cartData) async {
    final imageUrls = Map.fromEntries(
      await Future.wait(
        cartData.map(
          (cartItem) async => MapEntry(
            cartItem.id,
            await FirebaseImageHelper.getDownloadUrl(cartItem.imagePath),
          ),
        ),
      ),
    );
    emit(
      state.copyWith(cartItemImageMap: imageUrls),
    );
  }

  void increaseCartItemQuantity(CartItemDataModel cartItem) {
    if (state.cartItems == null) {
      return;
    }
    final index = state.cartItems!.indexWhere(
      (item) => item.id == cartItem.id,
    );
    if (index != -1) {
      final updatedItem = state.cartItems![index]
          .copyWith(quantity: state.cartItems![index].quantity + 1);
      final currentCartItems = List<CartItemDataModel>.from(state.cartItems!);
      currentCartItems[index] = updatedItem;
      emit(
        state.copyWith(cartItems: currentCartItems),
      );
    }
  }

  void decreaseCartItemQuantity(CartItemDataModel cartItem) {
    if (state.cartItems == null || cartItem.quantity == 1) {
      return;
    }
    final index = state.cartItems!.indexWhere(
      (item) => item.id == cartItem.id,
    );
    if (index != -1) {
      final updatedItem = state.cartItems![index]
          .copyWith(quantity: state.cartItems![index].quantity - 1);
      final currentCartItems = List<CartItemDataModel>.from(state.cartItems!);
      currentCartItems[index] = updatedItem;
      emit(
        state.copyWith(cartItems: currentCartItems),
      );
    }
  }
}
