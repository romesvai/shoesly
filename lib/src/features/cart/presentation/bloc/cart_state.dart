part of 'cart_cubit.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    required CartLoadingState cartLoadingState,
    List<CartItemDataModel>? cartItems,
    @Default({}) Map<String, String> cartItemImageMap,
  }) = _CartState;

  const CartState._();
}

@freezed
class CartLoadingState with _$CartLoadingState {
  const factory CartLoadingState.initial() = _Initial;

  const factory CartLoadingState.loading() = _Loading;

  const factory CartLoadingState.paginationLoading() = _PaginationLoading;

  const factory CartLoadingState.success() = _Success;

  const factory CartLoadingState.xception({BaseException? exception}) =
      _Exception;
}
