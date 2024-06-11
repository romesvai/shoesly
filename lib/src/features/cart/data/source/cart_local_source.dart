import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/hive_keys.dart';
import 'package:shoesly_ps/src/features/cart/domain/model/cart_item_data_model.dart';

@injectable
class CartLocalSource {
  CartLocalSource();

  Future<void> addCartItem({
    required CartItemDataModel cartItem,
  }) {
    return Hive.box<CartItemDataModel>(hiveCartKey).add(cartItem);
  }

  List<CartItemDataModel> getCartItems() =>
      Hive.box<CartItemDataModel>(hiveCartKey).values.toList();

  Future<void> removeCartItem({required CartItemDataModel cartItem}) async {
    final box = Hive.box<CartItemDataModel>(hiveCartKey);
    final items = box.values.toList();
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == cartItem.id) {
        await box.deleteAt(i);
        break;
      }
    }
  }
}
