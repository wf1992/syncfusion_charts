import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'barcodes_theme.dart';
import 'calendar_theme.dart';
import 'charts_theme.dart';
import 'daterangepicker_theme.dart';
import 'gauges_theme.dart';
import 'range_selector_theme.dart';

/// Applies a theme to descendant Syncfusion widgets.
class SfTheme extends StatelessWidget {
  const SfTheme({
    Key key,
    this.data,
    @required this.child,
  }) : super(key: key);

  /// Specifies a widget that can hold single child.
  final Widget child;

  /// Specifies the color and typography values for descendant widgets.
  final SfThemeData data;

  //ignore: unused_field
  static final SfThemeData _kFallbackTheme = SfThemeData.fallback();

  /// The data from the closest [SfTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [SfThemeData.fallback] if there is no [SfTheme] in the given
  /// build context.
  static SfThemeData of(BuildContext context) {
    final _SfInheritedTheme inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_SfInheritedTheme>();
    return inheritedTheme?.data ??
        (Theme.of(context).brightness == Brightness.light
            ? SfThemeData.light()
            : SfThemeData.dark());
  }

  @override
  Widget build(BuildContext context) {
    return _SfInheritedTheme(data: data, child: child);
  }
}

class _SfInheritedTheme extends InheritedTheme {
  const _SfInheritedTheme({Key key, this.data, Widget child})
      : super(key: key, child: child);

  final SfThemeData data;

  @override
  bool updateShouldNotify(_SfInheritedTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final _SfInheritedTheme ancestorTheme =
        context.findAncestorWidgetOfExactType<_SfInheritedTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for light and dark themes. Use
///  this class to configure a [SfTheme] widget.
///
/// To obtain the current theme, use [SfTheme.of].
class SfThemeData with DiagnosticableMixin {
  factory SfThemeData({
    Brightness brightness,
    SfChartThemeData chartThemeData,
    SfCalendarThemeData calendarThemeData,
    SfDateRangePickerThemeData dateRangePickerThemeData,
    SfBarcodeThemeData barcodeThemeData,
    SfGaugeThemeData gaugeThemeData,
    SfRangeSliderThemeData rangeSelectorThemeData,
    SfRangeSliderThemeData rangeSliderThemeData,
  }) {
    brightness ??= Brightness.light;
    chartThemeData = chartThemeData ?? SfChartThemeData(brightness: brightness);
    calendarThemeData =
        calendarThemeData ?? SfCalendarThemeData(brightness: brightness);
    dateRangePickerThemeData = dateRangePickerThemeData ??
        SfDateRangePickerThemeData(brightness: brightness);
    barcodeThemeData =
        barcodeThemeData ?? SfBarcodeThemeData(brightness: brightness);
    gaugeThemeData = gaugeThemeData ?? SfGaugeThemeData(brightness: brightness);
    rangeSelectorThemeData = rangeSelectorThemeData ??
        SfRangeSliderThemeData(brightness: brightness);
    rangeSliderThemeData =
        rangeSliderThemeData ?? SfRangeSliderThemeData(brightness: brightness);
    return SfThemeData.raw(
        brightness: brightness,
        chartThemeData: chartThemeData,
        calendarThemeData: calendarThemeData,
        dateRangePickerThemeData: dateRangePickerThemeData,
        barcodeThemeData: barcodeThemeData,
        gaugeThemeData: gaugeThemeData,
        rangeSelectorThemeData: rangeSelectorThemeData,
        rangeSliderThemeData: rangeSliderThemeData);
  }

  /// Create a [SfThemeData] given a set of exact values. All the values must be
  /// specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfThemeData] constructor.
  const SfThemeData.raw({
    @required this.brightness,
    @required this.chartThemeData,
    @required this.calendarThemeData,
    @required this.dateRangePickerThemeData,
    @required this.barcodeThemeData,
    @required this.gaugeThemeData,
    @required this.rangeSelectorThemeData,
    @required this.rangeSliderThemeData,
  })  : assert(brightness != null),
        assert(chartThemeData != null),
        assert(calendarThemeData != null),
        assert(dateRangePickerThemeData != null),
        assert(barcodeThemeData != null),
        assert(gaugeThemeData != null),
        assert(rangeSelectorThemeData != null),
        assert(rangeSliderThemeData != null);

  factory SfThemeData.light() => SfThemeData(brightness: Brightness.light);

  factory SfThemeData.dark() => SfThemeData(brightness: Brightness.dark);

  /// The default color theme. Same as [SfThemeData.light].
  ///
  /// This is used by [SfTheme.of] when no theme has been specified.
  factory SfThemeData.fallback() => SfThemeData.light();

  /// The brightness of the overall theme of the application for the Syncusion widgets.
  final Brightness brightness;

  /// Defines the default configuration of chart widgets.
  final SfChartThemeData chartThemeData;

  /// Defines the default configuration of datepicker widgets.
  final SfDateRangePickerThemeData dateRangePickerThemeData;

  /// Defines the default configuration of calendar widgets.
  final SfCalendarThemeData calendarThemeData;

  /// Defines the default configuration of barcode widgets.
  final SfBarcodeThemeData barcodeThemeData;

  /// Defines the default configuration of gauge widgets.
  final SfGaugeThemeData gaugeThemeData;

  /// Defines the default configuration of range selector widgets.
  final SfRangeSliderThemeData rangeSelectorThemeData;

  /// Defines the default configuration of range slider widgets.
  final SfRangeSliderThemeData rangeSliderThemeData;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  SfThemeData copyWith(
      {Brightness brightness,
      SfChartThemeData chartThemeData,
      SfCalendarThemeData calendarThemeData,
      SfDateRangePickerThemeData dateRangePickerThemeData,
      SfBarcodeThemeData barcodeThemeData,
      SfRangeSliderThemeData rangeSelectorThemeData,
      SfRangeSliderThemeData rangeSliderThemeData}) {
    return SfThemeData.raw(
        brightness: brightness ?? this.brightness,
        chartThemeData: chartThemeData ?? this.chartThemeData,
        calendarThemeData: calendarThemeData ?? this.calendarThemeData,
        dateRangePickerThemeData:
            dateRangePickerThemeData ?? this.dateRangePickerThemeData,
        barcodeThemeData: barcodeThemeData ?? this.barcodeThemeData,
        gaugeThemeData: gaugeThemeData ?? this.barcodeThemeData,
        rangeSelectorThemeData:
            rangeSelectorThemeData ?? this.rangeSelectorThemeData,
        rangeSliderThemeData:
            rangeSliderThemeData ?? this.rangeSliderThemeData);
  }

  static SfThemeData lerp(SfThemeData a, SfThemeData b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return SfThemeData.raw(
        brightness: t < 0.5 ? a.brightness : b.brightness,
        chartThemeData:
            SfChartThemeData.lerp(a.chartThemeData, b.chartThemeData, t),
        calendarThemeData: SfCalendarThemeData.lerp(
            a.calendarThemeData, b.calendarThemeData, t),
        dateRangePickerThemeData: SfDateRangePickerThemeData.lerp(
            a.dateRangePickerThemeData, b.dateRangePickerThemeData, t),
        barcodeThemeData:
            SfBarcodeThemeData.lerp(a.barcodeThemeData, b.barcodeThemeData, t),
        gaugeThemeData:
            SfGaugeThemeData.lerp(a.gaugeThemeData, b.gaugeThemeData, t),
        rangeSelectorThemeData: SfRangeSliderThemeData.lerp(
            a.rangeSelectorThemeData, b.rangeSelectorThemeData, t),
        rangeSliderThemeData: SfRangeSliderThemeData.lerp(
            a.rangeSliderThemeData, b.rangeSliderThemeData, t));
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SfThemeData otherData = other;
    return otherData.brightness == brightness &&
        otherData.chartThemeData == chartThemeData &&
        otherData.calendarThemeData == calendarThemeData &&
        otherData.dateRangePickerThemeData == dateRangePickerThemeData &&
        otherData.barcodeThemeData == barcodeThemeData &&
        otherData.gaugeThemeData == gaugeThemeData &&
        otherData.rangeSelectorThemeData == rangeSelectorThemeData &&
        otherData.rangeSliderThemeData == rangeSliderThemeData;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      brightness,
      chartThemeData,
      calendarThemeData,
      dateRangePickerThemeData,
      barcodeThemeData,
      gaugeThemeData,
      rangeSelectorThemeData,
      rangeSliderThemeData
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfThemeData defaultData = SfThemeData.fallback();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(DiagnosticsProperty<SfChartThemeData>(
        'chartThemeData', chartThemeData,
        defaultValue: defaultData.chartThemeData));
    properties.add(DiagnosticsProperty<SfCalendarThemeData>(
        'calendarThemeData', calendarThemeData,
        defaultValue: defaultData.calendarThemeData));
    properties.add(DiagnosticsProperty<SfDateRangePickerThemeData>(
        'dateRangePickerThemeData', dateRangePickerThemeData,
        defaultValue: defaultData.dateRangePickerThemeData));
    properties.add(DiagnosticsProperty<SfBarcodeThemeData>(
        'barcodeThemeData', barcodeThemeData,
        defaultValue: defaultData.barcodeThemeData));
    properties.add(DiagnosticsProperty<SfGaugeThemeData>(
        'gaugeThemeData', gaugeThemeData,
        defaultValue: defaultData.gaugeThemeData));
    properties.add(DiagnosticsProperty<SfRangeSliderThemeData>(
        'rangeSelectorThemeData', rangeSelectorThemeData,
        defaultValue: defaultData.rangeSelectorThemeData));
    properties.add(DiagnosticsProperty<SfRangeSliderThemeData>(
        'rangeSliderThemeData', rangeSliderThemeData,
        defaultValue: defaultData.rangeSliderThemeData));
  }
}
