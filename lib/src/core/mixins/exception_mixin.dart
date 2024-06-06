import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shoesly_ps/src/core/exceptions/app_exception.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';

mixin ExceptionMixin {
  @protected
  BaseException getAppException(Object error, StackTrace stackTrace) {
    return AppException.from(error);
  }

  @protected
  TaskEither<BaseException, R> tryCatch<R>(
    Future<R> Function() run, {
    BaseException Function(Object error, StackTrace stackTrace)? onException,
  }) {
    return TaskEither.tryCatch(run, onException ?? getAppException);
  }
}
