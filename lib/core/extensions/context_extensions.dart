import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
