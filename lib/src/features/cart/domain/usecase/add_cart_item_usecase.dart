import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/base/base_usecase.dart';
import 'package:shoesly_ps/src/core/mixins/exception_mixin.dart';
import 'package:shoesly_ps/src/core/typedef/either_exception.dart';
import 'package:shoesly_ps/src/features/cart/domain/model/cart_item_data_model.dart';
import 'package:shoesly_ps/src/features/cart/domain/repository/cart_repository.dart';

@injectable
class AddCartItemUsecase
    with ExceptionMixin
    implements BaseUsecase<CartItemDataModel, Unit> {
  AddCartItemUsecase(this._cartRepository);

  final CartRepository _cartRepository;

  @override
  EitherException<Unit> execute(CartItemDataModel input) => tryCatch(() async {
        await _cartRepository.addCartItem(input);
        return unit;
      });
}
