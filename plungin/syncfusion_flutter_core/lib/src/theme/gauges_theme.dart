import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion gauges widgets.
class SfGaugeTheme extends InheritedTheme {
  const SfGaugeTheme({Key key, this.data, this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant gauges widgets.
  final SfGaugeThemeData data;

  /// Specifies a widget that can hold single child.
  final Widget child;

  /// The data from the closest [SfGaugeTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [SfGaugeTheme.gaugeThemeData] if there is no [SfGaugeTheme] in the given
  /// build context.
  static SfGaugeThemeData of(BuildContext context) {
    final SfGaugeTheme sfGaugeTheme =
        context.dependOnInheritedWidgetOfExactType<SfGaugeTheme>();
    return sfGaugeTheme?.data ?? SfTheme.of(context).gaugeThemeData;
  }

  @override
  bool updateShouldNotify(SfGaugeTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfGaugeTheme ancestorTheme =
        context.findAncestorWidgetOfExactType<SfGaugeTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfGaugeTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfGaugeTheme]. Use
///  this class to configure a [SfGaugeTheme] widget
///
/// To obtain the current theme, use [SfGaugeTheme.of].
class SfGaugeThemeData with DiagnosticableMixin {
  factory SfGaugeThemeData({
    Brightness brightness,
    Color backgroundColor,
    Color titleColor,
    Color axisLabelColor,
    Color axisLineColor,
    Color majorTickColor,
    Color minorTickColor,
    Color markerColor,
    Color markerBorderColor,
    Color needleColor,
    Color knobColor,
    Color knobBorderColor,
    Color tailColor,
    Color tailBorderColor,
    Color rangePointerColor,
    Color rangeColor,
    Color titleBorderColor,
    Color titleBackgroundColor,
  }) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    backgroundColor ??= Colors.transparent;
    titleColor ??= isLight ? const Color(0xFF333333) : const Color(0xFFF5F5F5);
    axisLabelColor ??=
        isLight ? const Color(0xFF333333) : const Color(0xFFF5F5F5);
    axisLineColor ??=
        isLight ? const Color(0xFFDADADA) : const Color(0xFF555555);
    majorTickColor ??=
        isLight ? const Color(0xFF999999) : const Color(0xFF888888);
    minorTickColor ??=
        isLight ? const Color(0xFFC4C4C4) : const Color(0xFF666666);
    markerColor ??= isLight ? const Color(0xFF00A8B5) : const Color(0xFF00A8B5);
    markerBorderColor ??= isLight ? Colors.transparent : Colors.transparent;
    needleColor ??= isLight ? const Color(0xFF3A3A3A) : const Color(0xFFEEEEEE);
    knobColor ??= isLight ? const Color(0xFF3A3A3A) : const Color(0xFFEEEEEE);
    knobBorderColor ??= isLight ? Colors.transparent : Colors.transparent;
    tailColor ??= isLight ? const Color(0xFF3A3A3A) : const Color(0xFFEEEEEE);
    tailBorderColor ??= isLight ? Colors.transparent : Colors.transparent;
    rangePointerColor ??=
        isLight ? const Color(0xFF00A8B5) : const Color(0xFF00A8B5);
    rangeColor ??= isLight ? const Color(0xFFF67280) : const Color(0xFFF67280);
    titleBorderColor ??= isLight ? Colors.transparent : Colors.transparent;
    titleBackgroundColor ??= isLight ? Colors.transparent : Colors.transparent;

    return SfGaugeThemeData.raw(
        brightness: brightness,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        axisLabelColor: axisLabelColor,
        axisLineColor: axisLineColor,
        majorTickColor: majorTickColor,
        minorTickColor: minorTickColor,
        markerColor: markerColor,
        markerBorderColor: markerBorderColor,
        needleColor: needleColor,
        knobColor: knobColor,
        knobBorderColor: knobBorderColor,
        tailColor: tailColor,
        tailBorderColor: tailBorderColor,
        rangePointerColor: rangePointerColor,
        rangeColor: rangeColor,
        titleBorderColor: titleBorderColor,
        titleBackgroundColor: titleBackgroundColor);
  }

  /// Create a [SfGaugeThemeData] given a set of exact values. All the values must be
  /// specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfGaugeThemeData] constructor.
  const SfGaugeThemeData.raw(
      {@required this.brightness,
      @required this.backgroundColor,
      @required this.titleColor,
      @required this.axisLabelColor,
      @required this.axisLineColor,
      @required this.majorTickColor,
      @required this.minorTickColor,
      @required this.markerColor,
      @required this.markerBorderColor,
      @required this.needleColor,
      @required this.knobColor,
      @required this.knobBorderColor,
      @required this.tailColor,
      @required this.tailBorderColor,
      @required this.rangePointerColor,
      @required this.rangeColor,
      @required this.titleBorderColor,
      @required this.titleBackgroundColor});

  /// The brightness of the overall theme of the application for the gauge widgets.
  final Brightness brightness;

  /// Specifies the background color of gauge widgets.
  final Color backgroundColor;

  /// Specifies the title color
  final Color titleColor;

  /// Specifies the axis label color
  final Color axisLabelColor;

  /// Specifies the axis line color
  final Color axisLineColor;

  /// Specifies the major tick line color
  final Color majorTickColor;

  /// Specifies the minor tick line color
  final Color minorTickColor;

  /// Specifies the marker color
  final Color markerColor;

  /// Specifies the marker border color
  final Color markerBorderColor;

  /// Specifies the needle color
  final Color needleColor;

  /// Specifies the knob color
  final Color knobColor;

  /// Specifies the knob border color
  final Color knobBorderColor;

  /// Specifies the tail color
  final Color tailColor;

  /// Specifies the tail border color
  final Color tailBorderColor;

  /// Specifies the range pointer color
  final Color rangePointerColor;

  /// Specifies the range color
  final Color rangeColor;

  /// Specifies the title border color
  final Color titleBorderColor;

  /// Specifies the title background color
  final Color titleBackgroundColor;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  SfGaugeThemeData copyWith({
    Brightness brightness,
    Color backgroundColor,
    Color titleColor,
    Color axisLabelColor,
    Color axisLineColor,
    Color majorTickColor,
    Color minorTickColor,
    Color markerColor,
    Color markerBorderColor,
    Color needleColor,
    Color knobColor,
    Color knobBorderColor,
    Color tailColor,
    Color tailBorderColor,
    Color rangePointerColor,
    Color rangeColor,
    Color titleBorderColor,
    Color titleBackgroundColor,
  }) {
    return SfGaugeThemeData.raw(
      brightness: brightness ?? this.brightness,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      axisLabelColor: axisLabelColor ?? this.axisLabelColor,
      axisLineColor: axisLineColor ?? this.axisLineColor,
      majorTickColor: majorTickColor ?? this.majorTickColor,
      minorTickColor: minorTickColor ?? this.minorTickColor,
      markerColor: markerColor ?? this.markerColor,
      markerBorderColor: markerBorderColor ?? this.markerBorderColor,
      needleColor: needleColor ?? this.needleColor,
      knobColor: knobColor ?? this.knobColor,
      knobBorderColor: knobBorderColor ?? this.knobBorderColor,
      tailColor: tailColor ?? this.tailColor,
      tailBorderColor: tailBorderColor ?? this.tailBorderColor,
      rangePointerColor: rangePointerColor ?? this.rangePointerColor,
      rangeColor: rangeColor ?? this.rangeColor,
      titleBorderColor: titleBorderColor ?? this.titleBorderColor,
      titleBackgroundColor: titleBackgroundColor ?? this.titleBackgroundColor,
    );
  }

  static SfGaugeThemeData lerp(
      SfGaugeThemeData a, SfGaugeThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) {
      return null;
    }
    return SfGaugeThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      titleColor: Color.lerp(a.titleColor, b.titleColor, t),
      axisLabelColor: Color.lerp(a.axisLabelColor, b.axisLabelColor, t),
      axisLineColor: Color.lerp(a.axisLineColor, b.axisLineColor, t),
      majorTickColor: Color.lerp(a.majorTickColor, b.majorTickColor, t),
      minorTickColor: Color.lerp(a.minorTickColor, b.minorTickColor, t),
      markerColor: Color.lerp(a.markerColor, b.markerColor, t),
      markerBorderColor:
          Color.lerp(a.markerBorderColor, b.markerBorderColor, t),
      needleColor: Color.lerp(a.needleColor, b.needleColor, t),
      knobColor: Color.lerp(a.knobColor, b.knobColor, t),
      knobBorderColor: Color.lerp(a.knobBorderColor, b.knobBorderColor, t),
      tailColor: Color.lerp(a.tailColor, b.tailColor, t),
      tailBorderColor: Color.lerp(a.tailBorderColor, b.tailBorderColor, t),
      rangePointerColor:
          Color.lerp(a.rangePointerColor, b.rangePointerColor, t),
      rangeColor: Color.lerp(a.rangeColor, b.rangeColor, t),
      titleBorderColor: Color.lerp(a.titleBorderColor, b.titleBorderColor, t),
      titleBackgroundColor:
          Color.lerp(a.titleBackgroundColor, b.titleBackgroundColor, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SfGaugeThemeData typedOther = other;
    return typedOther.backgroundColor == backgroundColor &&
        typedOther.titleColor == titleColor &&
        typedOther.axisLabelColor == axisLabelColor &&
        typedOther.axisLineColor == axisLineColor &&
        typedOther.majorTickColor == majorTickColor &&
        typedOther.minorTickColor == minorTickColor &&
        typedOther.markerColor == markerColor &&
        typedOther.markerBorderColor == markerBorderColor &&
        typedOther.needleColor == needleColor &&
        typedOther.knobColor == knobColor &&
        typedOther.knobBorderColor == knobBorderColor &&
        typedOther.tailColor == tailColor &&
        typedOther.tailBorderColor == tailBorderColor &&
        typedOther.rangePointerColor == rangePointerColor &&
        typedOther.rangeColor == rangeColor &&
        typedOther.titleBorderColor == titleBorderColor &&
        typedOther.titleBackgroundColor == titleBackgroundColor;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      backgroundColor,
      titleColor,
      axisLabelColor,
      axisLineColor,
      majorTickColor,
      minorTickColor,
      markerColor,
      markerBorderColor,
      needleColor,
      knobColor,
      knobBorderColor,
      tailColor,
      tailBorderColor,
      rangePointerColor,
      rangeColor,
      titleBorderColor,
      titleBackgroundColor
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfGaugeThemeData defaultData = SfGaugeThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('backgroundColor', backgroundColor,
        defaultValue: defaultData.backgroundColor));
    properties.add(ColorProperty('titleColor', titleColor,
        defaultValue: defaultData.titleColor));
    properties.add(ColorProperty('axisLabelColor', axisLabelColor,
        defaultValue: defaultData.axisLabelColor));
    properties.add(ColorProperty('axisLineColor', axisLineColor,
        defaultValue: defaultData.axisLineColor));
    properties.add(ColorProperty('majorTickColor', majorTickColor,
        defaultValue: defaultData.majorTickColor));
    properties.add(ColorProperty('minorTickColor', minorTickColor,
        defaultValue: defaultData.minorTickColor));
    properties.add(ColorProperty('markerColor', markerColor,
        defaultValue: defaultData.markerColor));
    properties.add(ColorProperty('markerBorderColor', markerBorderColor,
        defaultValue: defaultData.markerBorderColor));
    properties.add(ColorProperty('needleColor', needleColor,
        defaultValue: defaultData.needleColor));
    properties.add(ColorProperty('knobColor', knobColor,
        defaultValue: defaultData.knobColor));
    properties.add(ColorProperty('knobBorderColor', knobBorderColor,
        defaultValue: defaultData.knobBorderColor));
    properties.add(ColorProperty('tailColor', tailColor,
        defaultValue: defaultData.tailColor));
    properties.add(ColorProperty('tailBorderColor', tailBorderColor,
        defaultValue: defaultData.tailBorderColor));
    properties.add(ColorProperty('rangePointerColor', rangePointerColor,
        defaultValue: defaultData.rangePointerColor));
    properties.add(ColorProperty('rangeColor', rangeColor,
        defaultValue: defaultData.rangeColor));
    properties.add(ColorProperty('titleBorderColor', titleBorderColor,
        defaultValue: defaultData.titleBorderColor));
    properties.add(ColorProperty('titleBackgroundColor', titleBackgroundColor,
        defaultValue: defaultData.titleBackgroundColor));
  }
}
