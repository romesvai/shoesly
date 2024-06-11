import 'package:shoesly_ps/src/features/cart/domain/model/cart_item_data_model.dart';

abstract class CartRepository {
  Future<void> addCartItem(CartItemDataModel cartItem);

  List<CartItemDataModel> getCartItems();

  Future<void> removeCartItem(CartItemDataModel cartItem);
}
