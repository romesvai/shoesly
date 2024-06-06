import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class BaseException implements Exception {
  BaseException(this.originalException);

  final Exception? originalException;

  String toLocalized(AppLocalizations l10n);
}
