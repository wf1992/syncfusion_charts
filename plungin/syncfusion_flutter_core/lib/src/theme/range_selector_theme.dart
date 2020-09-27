import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion range selector widgets.
class SfRangeSelectorTheme extends InheritedTheme {
  const SfRangeSelectorTheme({Key key, this.data, this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant range selector widgets.
  ///
  /// This snippet shows how to set value to the data property in [SfRangeSelectorTheme] and [SfRangeSliderTheme].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSelectorTheme(
  ///           data: SfRangeSliderThemeData(
  ///               trackHeight: 3,
  ///           ),
  ///           child:  SfRangeSelector(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               initialValues: _initialValues,
  ///               interval: 2,
  ///               showTicks: true,
  ///               showLabels: true,
  ///               child: Container(
  ///                   height: 200,
  ///                   color: Colors.green[100],
  ///               ),
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final SfRangeSliderThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  ///
  /// This snippet shows how to set value to the child property in [SfRangeSliderTheme] and [SfRangeSelectorTheme].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               trackHeight: 3,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               interval: 2,
  ///               showTicks: true,
  ///               showLabels: true,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final Widget child;

  /// The data from the closest [SfRangeSelectorTheme] instance that encloses the given context.
  ///
  /// Defaults to [SfThemeData.rangeSelectorThemeData] if there is no
  /// [SfRangeSelectorTheme] in the given build context.
  static SfRangeSliderThemeData of(BuildContext context) {
    final SfRangeSelectorTheme rangeSelectorTheme =
        context.dependOnInheritedWidgetOfExactType<SfRangeSelectorTheme>();
    return rangeSelectorTheme?.data ??
        SfTheme.of(context).rangeSelectorThemeData;
  }

  @override
  bool updateShouldNotify(SfRangeSelectorTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfRangeSelectorTheme ancestorTheme =
        context.findAncestorWidgetOfExactType<SfRangeSelectorTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfRangeSelectorTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfRangeSelectorTheme] and [SfRangeSliderTheme]. Use
/// this class to configure a [SfRangeSelectorTheme] and [SfRangeSliderTheme] widgets.
///
/// To obtain the current theme, use [SfRangeSelectorTheme.of].
class SfRangeSliderThemeData with DiagnosticableMixin {
  factory SfRangeSliderThemeData(
      {Brightness brightness,
      double trackHeight,
      Size tickSize,
      Size minorTickSize,
      Offset tickOffset,
      Offset labelOffset,
      TextStyle inactiveLabelStyle,
      TextStyle activeLabelStyle,
      TextStyle tooltipTextStyle,
      Color inactiveTrackColor,
      Color activeTrackColor,
      Color thumbColor,
      Color activeTickColor,
      Color inactiveTickColor,
      Color disabledActiveTickColor,
      Color disabledInactiveTickColor,
      Color activeMinorTickColor,
      Color inactiveMinorTickColor,
      Color disabledActiveMinorTickColor,
      Color disabledInactiveMinorTickColor,
      Color overlayColor,
      Color inactiveDivisorColor,
      Color activeDivisorColor,
      Color disabledActiveTrackColor,
      Color disabledInactiveTrackColor,
      Color disabledActiveDivisorColor,
      Color disabledInactiveDivisorColor,
      Color disabledThumbColor,
      Color activeRegionColor,
      Color inactiveRegionColor,
      Color tooltipBackgroundColor,
      double trackCornerRadius,
      double overlayRadius,
      double thumbRadius}) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    trackHeight ??= 2.0;
    tickSize ??= const Size(1.0, 8.0);
    minorTickSize ??= const Size(1.0, 5.0);
    trackCornerRadius ??= 1.0;
    overlayRadius ??= 25.0;
    thumbRadius ??= 10.0;
    activeTickColor ??= const Color.fromRGBO(158, 158, 158, 1);
    inactiveTickColor ??= const Color.fromRGBO(158, 158, 158, 1);
    activeMinorTickColor ??= const Color.fromRGBO(158, 158, 158, 1);
    inactiveMinorTickColor ??= const Color.fromRGBO(158, 158, 158, 1);
    disabledActiveTickColor ??= const Color.fromRGBO(189, 189, 189, 1);
    disabledInactiveTickColor ??= const Color.fromRGBO(189, 189, 189, 1);
    disabledActiveMinorTickColor ??= const Color.fromRGBO(189, 189, 189, 1);
    disabledInactiveMinorTickColor ??= const Color.fromRGBO(189, 189, 189, 1);
    disabledThumbColor ??= const Color.fromRGBO(158, 158, 158, 1);
    tooltipBackgroundColor ??= isLight
        ? const Color.fromRGBO(97, 97, 97, 1)
        : const Color.fromRGBO(224, 224, 224, 1);
    activeRegionColor ??= isLight
        ? const Color.fromRGBO(255, 255, 255, 1).withOpacity(0)
        : const Color.fromRGBO(255, 255, 255, 1).withOpacity(0);
    inactiveRegionColor ??= isLight
        ? const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.75)
        : const Color.fromRGBO(48, 48, 48, 1).withOpacity(0.75);

    return SfRangeSliderThemeData.raw(
        brightness: brightness,
        trackHeight: trackHeight,
        tickSize: tickSize,
        minorTickSize: minorTickSize,
        tickOffset: tickOffset,
        labelOffset: labelOffset,
        inactiveLabelStyle: inactiveLabelStyle,
        activeLabelStyle: activeLabelStyle,
        tooltipTextStyle: tooltipTextStyle,
        inactiveTrackColor: inactiveTrackColor,
        activeTrackColor: activeTrackColor,
        inactiveDivisorColor: inactiveDivisorColor,
        activeDivisorColor: activeDivisorColor,
        thumbColor: thumbColor,
        overlayColor: overlayColor,
        activeTickColor: activeTickColor,
        inactiveTickColor: inactiveTickColor,
        disabledActiveTickColor: disabledActiveTickColor,
        disabledInactiveTickColor: disabledInactiveTickColor,
        activeMinorTickColor: activeMinorTickColor,
        inactiveMinorTickColor: inactiveMinorTickColor,
        disabledActiveMinorTickColor: disabledActiveMinorTickColor,
        disabledInactiveMinorTickColor: disabledInactiveMinorTickColor,
        disabledActiveTrackColor: disabledActiveTrackColor,
        disabledInactiveTrackColor: disabledInactiveTrackColor,
        disabledActiveDivisorColor: disabledActiveDivisorColor,
        disabledInactiveDivisorColor: disabledInactiveDivisorColor,
        disabledThumbColor: disabledThumbColor,
        activeRegionColor: activeRegionColor,
        inactiveRegionColor: inactiveRegionColor,
        tooltipBackgroundColor: tooltipBackgroundColor,
        overlayRadius: overlayRadius,
        thumbRadius: thumbRadius,
        trackCornerRadius: trackCornerRadius);
  }

  /// Create a [SfRangeSliderThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfRangeSliderThemeData] constructor.
  const SfRangeSliderThemeData.raw({
    @required this.brightness,
    @required this.trackHeight,
    @required this.tickSize,
    @required this.minorTickSize,
    @required this.tickOffset,
    @required this.labelOffset,
    @required this.inactiveLabelStyle,
    @required this.activeLabelStyle,
    @required this.tooltipTextStyle,
    @required this.inactiveTrackColor,
    @required this.activeTrackColor,
    @required this.thumbColor,
    @required this.activeTickColor,
    @required this.inactiveTickColor,
    @required this.disabledActiveTickColor,
    @required this.disabledInactiveTickColor,
    @required this.activeMinorTickColor,
    @required this.inactiveMinorTickColor,
    @required this.disabledActiveMinorTickColor,
    @required this.disabledInactiveMinorTickColor,
    @required this.overlayColor,
    @required this.inactiveDivisorColor,
    @required this.activeDivisorColor,
    @required this.disabledActiveTrackColor,
    @required this.disabledInactiveTrackColor,
    @required this.disabledActiveDivisorColor,
    @required this.disabledInactiveDivisorColor,
    @required this.disabledThumbColor,
    @required this.activeRegionColor,
    @required this.inactiveRegionColor,
    @required this.tooltipBackgroundColor,
    @required this.trackCornerRadius,
    @required this.overlayRadius,
    @required this.thumbRadius,
  });

  /// Specifies the light and dark theme for the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// This theme applies to all the [SfRangeSlider] which are added as children of [SfRangeSliderTheme].
  ///
  /// This theme applies to all the [SfRangeSelector] which are added as children of [SfRangeSelectorTheme].
  ///
  /// This snippet shows how to set brightness in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               brightness: Brightness.dark,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               interval: 2,
  ///               showTicks: true,
  ///               showLabels: true,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final Brightness brightness;

  /// Specifies the height for the track in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// Defaults to `2.0`.
  ///
  /// This snippet shows how to set track height in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               trackHeight: 8,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final double trackHeight;

  /// Specifies the size for the major ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// Major ticks is a shape which is used to represent the major interval points of the track.
  ///
  /// Defaults to `Size(1.0, 8.0)`.
  ///
  /// This snippet shows how to set major ticks size in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 tickSize: Size(3.0, 12.0),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Size tickSize;

  /// Specifies the size for the minor ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// Minor ticks represents the number of smaller ticks between two major ticks.
  ///
  /// Defaults to `Size(1.0, 5.0)`.
  ///
  /// This snippet shows how to set minor ticks size in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 minorTickSize: Size(3.0, 8.0),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 interval: 2,
  ///                 minorTicksPerInterval: 1,
  ///                 showTicks: true,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Size minorTickSize;

  /// Adjust the space around ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The default value is `null`.
  ///
  /// This snippet shows how to set tick offset in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 tickOffset: Offset(0.0, 10.0),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 interval: 2,
  ///                 minorTicksPerInterval: 1,
  ///                 showTicks: true,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Offset tickOffset;

  /// Adjust the space around labels in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The default value of [labelOffset] property is `Offset(0.0, 13.0)` if the [showTicks] property is `false`.
  ///
  /// The default value of [labelOffset] property is `Offset(0.0, 5.0)` if the [showTicks] property is `true`.
  ///
  /// This snippet shows how to set label offset in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 labelOffset: Offset(0.0, 10.0),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Offset labelOffset;

  /// Specifies the appearance for inactive label in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set inactive label style in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 inactiveLabelStyle: TextStyle(color: Colors.red[200], fontSize: 12, fontStyle: FontStyle.italic),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final TextStyle inactiveLabelStyle;

  /// Specifies the appearance for active label in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set active label style in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 activeLabelStyle: TextStyle(color: Colors.red, fontSize: 12, fontStyle: FontStyle.italic),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final TextStyle activeLabelStyle;

  /// Specifies the appearance for the tooltip in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// This snippet shows how to set tooltip label style in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 tooltipTextStyle: TextStyle(color: Colors.red, fontSize: 16, fontStyle: FontStyle.italic),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 showTooltip: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final TextStyle tooltipTextStyle;

  /// Specifies the color for the inactive track in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb, and the right thumb
  /// and the [min] value.
  ///
  /// This snippet shows how to set inactive track color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 inactiveTrackColor: Colors.red[100],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color inactiveTrackColor;

  /// Specifies the color for active track in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between the start and end thumbs.
  ///
  /// This snippet shows how to set active track color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 activeTrackColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color activeTrackColor;

  /// Specifies the color for the thumb in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// This snippet shows how to set thumb color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 thumbColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color thumbColor;

  /// Specifies the color for the active major ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set active major ticks color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 activeTickColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color activeTickColor;

  /// Specifies the color for the inactive major ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set inactive major ticks color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  inactiveTickColor: Colors.red[100],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color inactiveTickColor;

  /// Specifies the color for the disabled active major ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set disabled active major ticks color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledActiveTickColor: Colors.orange,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledActiveTickColor;

  /// Specifies the color for the disabled inactive major ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set disabled inactive major ticks color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledInactiveTickColor: Colors.orange[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledInactiveTickColor;

  /// Specifies the color for the active minor ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set active minor ticks color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  activeMinorTickColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 minorTicksPerInterval: 1,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color activeMinorTickColor;

  /// Specifies the color for the inactive minor ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set inactive minor ticks color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  inactiveMinorTickColor: Colors.red[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 minorTicksPerInterval: 1,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color inactiveMinorTickColor;

  /// Specifies the color for the disabled active minor ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set disabled active minor ticks color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                   disabledActiveMinorTickColor: Colors.orange,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledActiveMinorTickColor;

  /// Specifies the color for the disabled inactive minor ticks in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set disabled inactive minor ticks color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledInactiveMinorTickColor: Colors.orange[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledInactiveMinorTickColor;

  /// Specifies the color for the overlay in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// Overlay appears while interacting with thumbs.
  ///
  /// This snippet shows how to set overlay color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  overlayColor: Colors.red[50],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color overlayColor;

  /// Specifies the color for the inactive divisors in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set inactive divisors color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  inactiveDivisorColor: Colors.red[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showDivisors: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color inactiveDivisorColor;

  /// Specifies the color for the active divisors in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set active divisors color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  activeDivisorColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showDivisors: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color activeDivisorColor;

  /// Specifies the color for the disabled active track in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set disabled active track color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledActiveTrackColor: Colors.orange,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledActiveTrackColor;

  /// Specifies the color for the disabled inactive track in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set disabled inactive track color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledInactiveTrackColor: Colors.orange[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledInactiveTrackColor;

  /// Specifies the color for the disabled active divisors in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set disabled active divisor color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledActiveDivisorColor: Colors.purple,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 showDivisors: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledActiveDivisorColor;

  /// Specifies the color for the disabled inactive divisors in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set disabled inactive divisor color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 disabledInactiveDivisorColor: Colors.purple[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 showDivisors: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledInactiveDivisorColor;

  /// Specifies the color for the disabled thumb in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// This snippet shows how to set disabled thumb color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 disabledThumbColor: Colors.orange,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledThumbColor;

  /// Specifies the color for the active region of the child in the [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between start and end thumbs.
  ///
  /// This snippet shows how to set active region color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSelectorTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 activeRegionColor: Colors.blue[200],
  ///             ),
  ///             child:  SfRangeSelector(
  ///                min: 2.0,
  ///                max: 10.0,
  ///                interval: 1,
  ///                showLabels: true,
  ///                showTicks: true,
  ///                initialValues: _values,
  ///                child: Container(
  ///                   height: 200,
  ///                   color: Colors.pink,
  ///                ),
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color activeRegionColor;

  /// Specifies the color for the inactive region of the child in the [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set inactive region color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSelectorTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 inactiveRegionColor: Colors.blue[200],
  ///             ),
  ///             child:  SfRangeSelector(
  ///                min: 2.0,
  ///                max: 10.0,
  ///                interval: 1,
  ///                showLabels: true,
  ///                showTicks: true,
  ///                initialValues: _values,
  ///                child: Container(
  ///                   height: 200,
  ///                   color: Colors.pink,
  ///                ),
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color inactiveRegionColor;

  /// Specifies the color for the tooltip background in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// This snippet shows how to set tooltip background color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 tooltipBackgroundColor: Colors.red[300],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showLabels: true,
  ///                 showTooltip: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color tooltipBackgroundColor;

  /// Specifies the radius for the track corners in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// This snippet shows how to set track corner radius in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 trackHeight: 10,
  ///                 trackCornerRadius: 5,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final double trackCornerRadius;

  /// Specifies the radius for the overlay in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// Overlay appears while interacting with thumbs.
  ///
  /// This snippet shows how to set overlay radius in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 overlayRadius: 22,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final double overlayRadius;

  /// Specifies the radius for the thumb in the [SfRangeSlider] and [SfRangeSelector].
  ///
  /// This snippet shows how to set thumb radius in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 thumbRadius: 13,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final double thumbRadius;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  SfRangeSliderThemeData copyWith({
    Brightness brightness,
    double trackHeight,
    Size tickSize,
    Size minorTickSize,
    Offset tickOffset,
    Offset labelOffset,
    TextStyle inactiveLabelStyle,
    TextStyle activeLabelStyle,
    TextStyle tooltipTextStyle,
    Color inactiveTrackColor,
    Color activeTrackColor,
    Color thumbColor,
    Color activeTickColor,
    Color inactiveTickColor,
    Color disabledActiveTickColor,
    Color disabledInactiveTickColor,
    Color activeMinorTickColor,
    Color inactiveMinorTickColor,
    Color disabledActiveMinorTickColor,
    Color disabledInactiveMinorTickColor,
    Color overlayColor,
    Color inactiveDivisorColor,
    Color activeDivisorColor,
    Color disabledActiveTrackColor,
    Color disabledInactiveTrackColor,
    Color disabledActiveDivisorColor,
    Color disabledInactiveDivisorColor,
    Color disabledThumbColor,
    Color activeRegionColor,
    Color inactiveRegionColor,
    Color tooltipBackgroundColor,
    double trackCornerRadius,
    double overlayRadius,
    double thumbRadius,
  }) {
    return SfRangeSliderThemeData.raw(
      brightness: brightness ?? this.brightness,
      trackHeight: trackHeight ?? this.trackHeight,
      tickSize: tickSize ?? this.tickSize,
      minorTickSize: minorTickSize ?? this.minorTickSize,
      tickOffset: tickOffset ?? this.tickOffset,
      labelOffset: labelOffset ?? this.labelOffset,
      inactiveLabelStyle: inactiveLabelStyle ?? this.inactiveLabelStyle,
      activeLabelStyle: activeLabelStyle ?? this.activeLabelStyle,
      tooltipTextStyle: tooltipTextStyle ?? this.tooltipTextStyle,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      thumbColor: thumbColor ?? this.thumbColor,
      activeTickColor: activeTickColor ?? this.activeTickColor,
      inactiveTickColor: inactiveTickColor ?? this.inactiveTickColor,
      disabledActiveTickColor:
          disabledActiveTickColor ?? this.disabledActiveTickColor,
      disabledInactiveTickColor:
          disabledInactiveTickColor ?? this.disabledInactiveTickColor,
      activeMinorTickColor: activeMinorTickColor ?? this.activeMinorTickColor,
      inactiveMinorTickColor:
          inactiveMinorTickColor ?? this.inactiveMinorTickColor,
      disabledActiveMinorTickColor:
          disabledActiveMinorTickColor ?? this.disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor:
          disabledInactiveMinorTickColor ?? this.disabledInactiveMinorTickColor,
      overlayColor: overlayColor ?? this.overlayColor,
      inactiveDivisorColor: inactiveDivisorColor ?? this.inactiveDivisorColor,
      activeDivisorColor: activeDivisorColor ?? this.activeDivisorColor,
      disabledActiveTrackColor:
          disabledActiveTrackColor ?? this.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          disabledInactiveTrackColor ?? this.disabledInactiveTrackColor,
      disabledActiveDivisorColor:
          disabledActiveDivisorColor ?? this.disabledActiveDivisorColor,
      disabledInactiveDivisorColor:
          disabledInactiveDivisorColor ?? this.disabledInactiveDivisorColor,
      disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
      activeRegionColor: activeRegionColor ?? this.activeRegionColor,
      inactiveRegionColor: inactiveRegionColor ?? this.inactiveRegionColor,
      tooltipBackgroundColor:
          tooltipBackgroundColor ?? this.tooltipBackgroundColor,
      trackCornerRadius: trackCornerRadius ?? this.trackCornerRadius,
      overlayRadius: overlayRadius ?? this.overlayRadius,
      thumbRadius: thumbRadius ?? this.thumbRadius,
    );
  }

  static SfRangeSliderThemeData lerp(
      SfRangeSliderThemeData a, SfRangeSliderThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) {
      return null;
    }
    return SfRangeSliderThemeData(
      trackHeight: lerpDouble(a.trackHeight, b.trackHeight, t),
      tickSize: Size.lerp(a.tickSize, b.tickSize, t),
      minorTickSize: Size.lerp(a.minorTickSize, b.minorTickSize, t),
      tickOffset: Offset.lerp(a.tickOffset, b.tickOffset, t),
      labelOffset: Offset.lerp(a.labelOffset, b.labelOffset, t),
      inactiveLabelStyle:
          TextStyle.lerp(a.inactiveLabelStyle, b.inactiveLabelStyle, t),
      activeLabelStyle:
          TextStyle.lerp(a.activeLabelStyle, b.activeLabelStyle, t),
      tooltipTextStyle:
          TextStyle.lerp(a.tooltipTextStyle, b.tooltipTextStyle, t),
      inactiveTrackColor:
          Color.lerp(a.inactiveTrackColor, b.inactiveTrackColor, t),
      activeTrackColor: Color.lerp(a.activeTrackColor, b.activeTrackColor, t),
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
      activeTickColor: Color.lerp(a.activeTickColor, b.activeTickColor, t),
      inactiveTickColor:
          Color.lerp(a.inactiveTickColor, b.inactiveTickColor, t),
      disabledActiveTickColor:
          Color.lerp(a.disabledActiveTickColor, b.disabledActiveTickColor, t),
      disabledInactiveTickColor: Color.lerp(
          a.disabledInactiveTickColor, b.disabledInactiveTickColor, t),
      activeMinorTickColor:
          Color.lerp(a.activeMinorTickColor, b.activeMinorTickColor, t),
      inactiveMinorTickColor:
          Color.lerp(a.inactiveMinorTickColor, b.inactiveMinorTickColor, t),
      disabledActiveMinorTickColor: Color.lerp(
          a.disabledActiveMinorTickColor, b.disabledActiveMinorTickColor, t),
      disabledInactiveMinorTickColor: Color.lerp(
          a.disabledInactiveMinorTickColor,
          b.disabledInactiveMinorTickColor,
          t),
      overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
      inactiveDivisorColor:
          Color.lerp(a.inactiveDivisorColor, b.inactiveDivisorColor, t),
      activeDivisorColor:
          Color.lerp(a.activeDivisorColor, b.activeDivisorColor, t),
      disabledActiveTrackColor:
          Color.lerp(a.disabledActiveTrackColor, b.disabledActiveTrackColor, t),
      disabledInactiveTrackColor: Color.lerp(
          a.disabledInactiveTrackColor, b.disabledInactiveTrackColor, t),
      disabledActiveDivisorColor: Color.lerp(
          a.disabledActiveDivisorColor, b.disabledActiveDivisorColor, t),
      disabledInactiveDivisorColor: Color.lerp(
          a.disabledInactiveDivisorColor, b.disabledInactiveDivisorColor, t),
      disabledThumbColor:
          Color.lerp(a.disabledThumbColor, b.disabledThumbColor, t),
      activeRegionColor:
          Color.lerp(a.activeRegionColor, b.activeRegionColor, t),
      inactiveRegionColor:
          Color.lerp(a.inactiveRegionColor, b.inactiveRegionColor, t),
      tooltipBackgroundColor:
          Color.lerp(a.tooltipBackgroundColor, b.tooltipBackgroundColor, t),
      trackCornerRadius:
          lerpDouble(a.trackCornerRadius, b.trackCornerRadius, t),
      overlayRadius: lerpDouble(a.overlayRadius, b.overlayRadius, t),
      thumbRadius: lerpDouble(a.thumbRadius, b.thumbRadius, t),
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
    final SfRangeSliderThemeData otherData = other;
    return otherData.brightness == brightness &&
        otherData.trackHeight == trackHeight &&
        otherData.tickSize == tickSize &&
        otherData.minorTickSize == minorTickSize &&
        otherData.tickOffset == tickOffset &&
        otherData.labelOffset == labelOffset &&
        otherData.inactiveLabelStyle == inactiveLabelStyle &&
        otherData.activeLabelStyle == activeLabelStyle &&
        otherData.tooltipTextStyle == tooltipTextStyle &&
        otherData.inactiveTrackColor == inactiveTrackColor &&
        otherData.activeTrackColor == activeTrackColor &&
        otherData.thumbColor == thumbColor &&
        otherData.activeTickColor == activeTickColor &&
        otherData.inactiveTickColor == inactiveTickColor &&
        otherData.disabledActiveTickColor == disabledActiveTickColor &&
        otherData.disabledInactiveTickColor == disabledInactiveTickColor &&
        otherData.activeMinorTickColor == activeMinorTickColor &&
        otherData.inactiveMinorTickColor == inactiveMinorTickColor &&
        otherData.disabledActiveMinorTickColor ==
            disabledActiveMinorTickColor &&
        otherData.disabledInactiveMinorTickColor ==
            disabledInactiveMinorTickColor &&
        otherData.overlayColor == overlayColor &&
        otherData.inactiveDivisorColor == inactiveDivisorColor &&
        otherData.activeDivisorColor == activeDivisorColor &&
        otherData.disabledActiveTrackColor == disabledActiveTrackColor &&
        otherData.disabledInactiveTrackColor == disabledInactiveTrackColor &&
        otherData.disabledActiveDivisorColor == disabledActiveDivisorColor &&
        otherData.disabledInactiveDivisorColor ==
            disabledInactiveDivisorColor &&
        otherData.disabledThumbColor == disabledThumbColor &&
        otherData.activeRegionColor == activeRegionColor &&
        otherData.inactiveRegionColor == inactiveRegionColor &&
        otherData.tooltipBackgroundColor == tooltipBackgroundColor &&
        otherData.trackCornerRadius == trackCornerRadius &&
        otherData.overlayRadius == overlayRadius &&
        otherData.thumbRadius == thumbRadius;
  }

  @override
  int get hashCode {
    return hashList(<Object>[
      brightness,
      trackHeight,
      tickSize,
      minorTickSize,
      tickOffset,
      labelOffset,
      inactiveLabelStyle,
      activeLabelStyle,
      tooltipTextStyle,
      inactiveTrackColor,
      activeTrackColor,
      thumbColor,
      activeTickColor,
      inactiveTickColor,
      disabledActiveTickColor,
      disabledInactiveTickColor,
      activeMinorTickColor,
      inactiveMinorTickColor,
      disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor,
      overlayColor,
      inactiveDivisorColor,
      activeDivisorColor,
      disabledActiveTrackColor,
      disabledInactiveTrackColor,
      disabledActiveDivisorColor,
      disabledInactiveDivisorColor,
      disabledThumbColor,
      activeRegionColor,
      inactiveRegionColor,
      tooltipBackgroundColor,
      trackCornerRadius,
      overlayRadius,
      thumbRadius,
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfRangeSliderThemeData defaultData = SfRangeSliderThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(DoubleProperty('trackHeight', trackHeight,
        defaultValue: defaultData.trackHeight));
    properties.add(DiagnosticsProperty<Size>('tickSize', tickSize,
        defaultValue: defaultData.tickSize));
    properties.add(DiagnosticsProperty<Size>('minorTickSize', minorTickSize,
        defaultValue: defaultData.minorTickSize));
    properties.add(DiagnosticsProperty<Offset>('tickOffset', tickOffset,
        defaultValue: defaultData.tickOffset));
    properties.add(DiagnosticsProperty<Offset>('labelOffset', labelOffset,
        defaultValue: defaultData.labelOffset));
    properties.add(DiagnosticsProperty<TextStyle>(
        'inactiveLabelStyle', inactiveLabelStyle,
        defaultValue: defaultData.inactiveLabelStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'activeLabelStyle', activeLabelStyle,
        defaultValue: defaultData.activeLabelStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'tooltipTextStyle', tooltipTextStyle,
        defaultValue: defaultData.tooltipTextStyle));
    properties.add(ColorProperty('inactiveTrackColor', inactiveTrackColor,
        defaultValue: defaultData.inactiveTrackColor));
    properties.add(ColorProperty('activeTrackColor', activeTrackColor,
        defaultValue: defaultData.activeTrackColor));
    properties.add(ColorProperty('thumbColor', thumbColor,
        defaultValue: defaultData.thumbColor));
    properties.add(ColorProperty('activeTickColor', activeTickColor,
        defaultValue: defaultData.activeTickColor));
    properties.add(ColorProperty('inactiveTickColor', inactiveTickColor,
        defaultValue: defaultData.inactiveTickColor));
    properties.add(ColorProperty(
        'disabledActiveTickColor', disabledActiveTickColor,
        defaultValue: defaultData.disabledActiveTickColor));
    properties.add(ColorProperty(
        'disabledInactiveTickColor', disabledInactiveTickColor,
        defaultValue: defaultData.disabledInactiveTickColor));
    properties.add(ColorProperty('activeMinorTickColor', activeMinorTickColor,
        defaultValue: defaultData.activeMinorTickColor));
    properties.add(ColorProperty(
        'inactiveMinorTickColor', inactiveMinorTickColor,
        defaultValue: defaultData.inactiveMinorTickColor));
    properties.add(ColorProperty(
        'disabledActiveMinorTickColor', disabledActiveMinorTickColor,
        defaultValue: defaultData.disabledActiveMinorTickColor));
    properties.add(ColorProperty(
        'disabledInactiveMinorTickColor', disabledInactiveMinorTickColor,
        defaultValue: defaultData.disabledInactiveMinorTickColor));
    properties.add(ColorProperty('overlayColor', overlayColor,
        defaultValue: defaultData.overlayColor));
    properties.add(ColorProperty('inactiveDivisorColor', inactiveDivisorColor,
        defaultValue: defaultData.inactiveDivisorColor));
    properties.add(ColorProperty('activeDivisorColor', activeDivisorColor,
        defaultValue: defaultData.activeDivisorColor));
    properties.add(ColorProperty(
        'disabledActiveTrackColor', disabledActiveTrackColor,
        defaultValue: defaultData.disabledActiveTrackColor));
    properties.add(ColorProperty(
        'disabledInactiveTrackColor', disabledInactiveTrackColor,
        defaultValue: defaultData.disabledInactiveTrackColor));
    properties.add(ColorProperty(
        'disabledActiveDivisorColor', disabledActiveDivisorColor,
        defaultValue: defaultData.disabledActiveDivisorColor));
    properties.add(ColorProperty(
        'disabledInactiveDivisorColor', disabledInactiveDivisorColor,
        defaultValue: defaultData.disabledInactiveDivisorColor));
    properties.add(ColorProperty('disabledThumbColor', disabledThumbColor,
        defaultValue: defaultData.disabledThumbColor));
    properties.add(ColorProperty('activeRegionColor', activeRegionColor,
        defaultValue: defaultData.activeRegionColor));
    properties.add(ColorProperty('inactiveRegionColor', inactiveRegionColor,
        defaultValue: defaultData.inactiveRegionColor));
    properties.add(ColorProperty(
        'tooltipBackgroundColor', tooltipBackgroundColor,
        defaultValue: defaultData.tooltipBackgroundColor));
    properties.add(DoubleProperty('trackCornerRadius', trackCornerRadius,
        defaultValue: defaultData.trackCornerRadius));
    properties.add(DoubleProperty('overlayRadius', overlayRadius,
        defaultValue: defaultData.overlayRadius));
    properties.add(DoubleProperty('thumbRadius', thumbRadius,
        defaultValue: defaultData.thumbRadius));
  }
}
