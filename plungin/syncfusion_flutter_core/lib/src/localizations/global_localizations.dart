import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines the localized resource values used by the Syncfusion Widgets
abstract class SfLocalizations {
  /// Label that is displayed when no date is selected in a calendar widget. This label is displayed under agenda section in month view.
  String get noSelectedDateCalendarLabel;

  /// Label that is displayed when there are no events for a selected date in a calendar widget. This label is displayed under agenda section in month view.
  String get noEventsCalendarLabel;

  static const LocalizationsDelegate<SfLocalizations> delegate =
      _SfLocalizationDelegates();

  static SfLocalizations of(BuildContext context) {
    return Localizations.of<SfLocalizations>(context, SfLocalizations) ??
        const _DefaultLocalizations();
  }
}

class _SfLocalizationDelegates extends LocalizationsDelegate<SfLocalizations> {
  const _SfLocalizationDelegates();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<SfLocalizations> load(Locale locale) =>
      _DefaultLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<SfLocalizations> old) => false;
}

/// US English strings for the Syncfusion widgets.
class _DefaultLocalizations implements SfLocalizations {
  const _DefaultLocalizations();

  @override
  String get noSelectedDateCalendarLabel => 'No selected date';

  @protected
  String get noEventsCalendarLabel => 'No events';

  static Future<SfLocalizations> load(Locale locale) {
    return SynchronousFuture<SfLocalizations>(const _DefaultLocalizations());
  }

  static const LocalizationsDelegate<SfLocalizations> delegate =
      _SfLocalizationDelegates();
}
