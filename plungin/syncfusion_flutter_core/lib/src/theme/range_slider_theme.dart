import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion range slider widgets.
class SfRangeSliderTheme extends InheritedTheme {
  const SfRangeSliderTheme({Key key, this.data, this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant range slider widgets.
  final SfRangeSliderThemeData data;

  /// Specifies a widget that can hold single child.
  final Widget child;

  /// The data from the closest [SfRangeSliderTheme] instance that encloses the given context.
  ///
  /// Defaults to [SfThemeData.rangeSliderThemeData] if there is no
  /// [SfRangeSliderTheme] in the given build context.
  static SfRangeSliderThemeData of(BuildContext context) {
    final SfRangeSliderTheme rangeSliderTheme =
        context.dependOnInheritedWidgetOfExactType<SfRangeSliderTheme>();
    return rangeSliderTheme?.data ?? SfTheme.of(context).rangeSliderThemeData;
  }

  @override
  bool updateShouldNotify(SfRangeSliderTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfRangeSliderTheme ancestorTheme =
        context.findAncestorWidgetOfExactType<SfRangeSliderTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfRangeSliderTheme(data: data, child: child);
  }
}
