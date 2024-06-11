import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/features/cart/data/source/cart_local_source.dart';
import 'package:shoesly_ps/src/features/cart/domain/model/cart_item_data_model.dart';
import 'package:shoesly_ps/src/features/cart/domain/repository/cart_repository.dart';

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._cartLocalSource);

  final CartLocalSource _cartLocalSource;

  @override
  Future<void> addCartItem(CartItemDataModel cartItem) async =>
      _cartLocalSource.addCartItem(cartItem: cartItem);

  @override
  List<CartItemDataModel> getCartItems() => _cartLocalSource.getCartItems();

  @override
  Future<void> removeCartItem(CartItemDataModel cartItem) =>
      _cartLocalSource.removeCartItem(cartItem: cartItem);
}
