import 'package:fpdart/fpdart.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';

typedef EitherException<T> = TaskEither<BaseException, T>;
