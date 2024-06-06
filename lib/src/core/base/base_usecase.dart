import 'package:shoesly_ps/src/core/typedef/either_exception.dart';

abstract class BaseUsecase<T, R> {
  EitherException<R> execute(T input);
}
