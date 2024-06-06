import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';



part 'auth_exception.freezed.dart';

@freezed
class AuthException with _$AuthException implements BaseException {
  const AuthException._();
  const factory AuthException.operationNotAllowed() =
      AuthExceptionOperationNotAllowed;
  const factory AuthException.other(Object error) = AuthExceptionOther;

  @override
  String toLocalized(AppLocalizations l10n) => when(
        operationNotAllowed: () => l10n.operationNotAllowed,
        other: (_) => l10n.exceptionUnexpected,
      );

  @override
  Exception? get originalException => this;
}
