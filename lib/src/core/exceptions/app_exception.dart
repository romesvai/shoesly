import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/core/exceptions/exceptions.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException implements BaseException {
  const AppException._();

  const factory AppException.unsupportedPlatform() = _UnsupportedPlatform;

  const factory AppException.other(Object error) = _Other;

  const factory AppException.network(NetworkException exception) = _Network;
  const factory AppException.auth(AuthException exception) = _Auth;

  /// Converts Object into useful [AppException].
  factory AppException.from(Object error) {
    // Every possible Exception should be converted here since we don't know,
    // what object can be.

    // error is not Exception so it is some object.
    if (error is! Exception) return AppException.other(error);

    if (error is AppException) return error;

    if (error is NetworkException) return AppException.network(error);

    if (error is AuthException) return AppException.auth(error);

    return AppException.other(error);
  }

  @override
  String toLocalized(AppLocalizations l10n) {
    return when(
      unsupportedPlatform: () => l10n.exceptionUnsupportedPlatform,
      other: (error) => error.toString(),
      network: (NetworkException exception) => exception.toLocalized(l10n),
      auth: (AuthException exception) => exception.toLocalized(l10n),
    );
  }

  @override
  Exception get originalException => this;
}
