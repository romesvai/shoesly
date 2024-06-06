import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';


part 'network_exception.freezed.dart';

@freezed
class NetworkException with _$NetworkException implements BaseException {
  const NetworkException._();

  /// Remote call failed with some response from server.
  const factory NetworkException.response(String message) = _Response;

  /// Failed to connect due to connection issue.
  const factory NetworkException.connection() = _Connection;

  /// Timeout failure.
  const factory NetworkException.timeout() = _Timeout;

  /// Unknown exception that are unhandled.
  const factory NetworkException.unexpected() = _Unexpected;

  /// Translates the error message to localized message.
  @override
  String toLocalized(AppLocalizations l10n) => when(
        response: (message) => message,
        connection: () => l10n.connectionError,
        timeout: () => l10n.connectionTimeout,
        unexpected: () => l10n.unexpectedNetworkError,
      );

  @override
  Exception get originalException => this;
}
