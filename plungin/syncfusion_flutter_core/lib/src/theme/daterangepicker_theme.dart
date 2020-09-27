import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion chart widgets.
class SfDateRangePickerTheme extends InheritedTheme {
  const SfDateRangePickerTheme({Key key, this.data, this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant chart widgets.
  final SfDateRangePickerThemeData data;

  /// Specifies a widget that can hold single child.
  final Widget child;

  /// The data from the closest [SfDateRangePickerTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [SfThemeData.dateRangePickerTheme] if there is no [SfDateRangePickerTheme] in the given
  /// build context.
  static SfDateRangePickerThemeData of(BuildContext context) {
    final SfDateRangePickerTheme sfDateRangePickerTheme =
        context.dependOnInheritedWidgetOfExactType<SfDateRangePickerTheme>();
    return sfDateRangePickerTheme?.data ??
        SfTheme.of(context).dateRangePickerThemeData;
  }

  @override
  bool updateShouldNotify(SfDateRangePickerTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfDateRangePickerTheme ancestorTheme =
        context.findAncestorWidgetOfExactType<SfDateRangePickerTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfDateRangePickerTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfDateRangePickerTheme]. Use
///  this class to configure a [SfDateRangePickerTheme] widget
///
/// To obtain the current theme, use [SfDateRangePickerTheme.of].
class SfDateRangePickerThemeData with DiagnosticableMixin {
  factory SfDateRangePickerThemeData({
    Brightness brightness,
    Color backgroundColor,
    Color startRangeSelectionColor,
    Color endRangeSelectionColor,
    Color headerBackgroundColor,
    Color viewHeaderBackgroundColor,
    Color todayHighlightColor,
    Color selectionColor,
    Color rangeSelectionColor,
    TextStyle viewHeaderTextStyle,
    TextStyle headerTextStyle,
    TextStyle trailingDatesTextStyle,
    TextStyle leadingCellTextStyle,
    TextStyle activeDatesTextStyle,
    TextStyle cellTextStyle,
    TextStyle rangeSelectionTextStyle,
    TextStyle leadingDatesTextStyle,
    TextStyle disabledDatesTextStyle,
    TextStyle disabledCellTextStyle,
    TextStyle selectionTextStyle,
    TextStyle blackoutDatesTextStyle,
    TextStyle todayTextStyle,
    TextStyle todayCellTextStyle,
    TextStyle weekendDatesTextStyle,
    TextStyle specialDatesTextStyle,
  }) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    backgroundColor ??= Colors.transparent;
    selectionColor ??=
        isLight ? const Color(0xFF2196F3) : const Color(0xFF64FFDA);
    startRangeSelectionColor ??=
        isLight ? const Color(0xFF2196F3) : const Color(0xFF64FFDA);
    endRangeSelectionColor ??=
        isLight ? const Color(0xFF2196F3) : const Color(0xFF64FFDA);
    headerBackgroundColor ??= Colors.transparent;
    viewHeaderBackgroundColor ??= Colors.transparent;
    todayHighlightColor ??=
        isLight ? const Color(0xFF2196F3) : const Color(0xFF64FFDA);
    viewHeaderTextStyle ??= isLight
        ? TextStyle(color: Colors.black87, fontSize: 11, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Roboto');
    headerTextStyle ??= isLight
        ? TextStyle(color: Colors.black87, fontSize: 18, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Roboto');
    trailingDatesTextStyle ??= isLight
        ? TextStyle(color: Colors.black54, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white54, fontSize: 13, fontFamily: 'Roboto');
    leadingCellTextStyle ??= isLight
        ? TextStyle(color: Colors.black54, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white54, fontSize: 13, fontFamily: 'Roboto');
    activeDatesTextStyle ??= isLight
        ? TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto');
    cellTextStyle ??= isLight
        ? TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto');
    leadingDatesTextStyle ??= isLight
        ? TextStyle(color: Colors.black54, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white54, fontSize: 13, fontFamily: 'Roboto');
    rangeSelectionTextStyle ??= isLight
        ? TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto');
    rangeSelectionColor ??=
        isLight ? const Color(0xFFE3F2FD) : const Color(0xFF184C3F);
    disabledDatesTextStyle ??= isLight
        ? TextStyle(color: Colors.black26, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white38, fontSize: 13, fontFamily: 'Roboto');
    disabledCellTextStyle ??= isLight
        ? TextStyle(color: Colors.black26, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white38, fontSize: 13, fontFamily: 'Roboto');
    selectionTextStyle ??= isLight
        ? TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'Roboto');
    todayTextStyle ??= isLight
        ? const TextStyle(
            color: Color(0xFF2196F3), fontSize: 13, fontFamily: 'Roboto')
        : const TextStyle(
            color: Color(0xFF64FFDA), fontSize: 13, fontFamily: 'Roboto');
    todayCellTextStyle ??= isLight
        ? const TextStyle(
            color: Color(0xFF2196F3), fontSize: 13, fontFamily: 'Roboto')
        : const TextStyle(
            color: Color(0xFF64FFDA), fontSize: 13, fontFamily: 'Roboto');
    specialDatesTextStyle ??= isLight
        ? const TextStyle(
            color: Color(0xFF339413), fontSize: 13, fontFamily: 'Roboto')
        : const TextStyle(
            color: Color(0xFFEA75FF), fontSize: 13, fontFamily: 'Roboto');

    return SfDateRangePickerThemeData.raw(
      brightness: brightness,
      backgroundColor: backgroundColor,
      viewHeaderTextStyle: viewHeaderTextStyle,
      headerTextStyle: headerTextStyle,
      trailingDatesTextStyle: trailingDatesTextStyle,
      leadingCellTextStyle: leadingCellTextStyle,
      activeDatesTextStyle: activeDatesTextStyle,
      cellTextStyle: cellTextStyle,
      rangeSelectionTextStyle: rangeSelectionTextStyle,
      rangeSelectionColor: rangeSelectionColor,
      leadingDatesTextStyle: leadingDatesTextStyle,
      disabledDatesTextStyle: disabledDatesTextStyle,
      disabledCellTextStyle: disabledCellTextStyle,
      selectionColor: selectionColor,
      selectionTextStyle: selectionTextStyle,
      startRangeSelectionColor: startRangeSelectionColor,
      endRangeSelectionColor: endRangeSelectionColor,
      headerBackgroundColor: headerBackgroundColor,
      viewHeaderBackgroundColor: viewHeaderBackgroundColor,
      blackoutDatesTextStyle: blackoutDatesTextStyle,
      todayHighlightColor: todayHighlightColor,
      todayTextStyle: todayTextStyle,
      todayCellTextStyle: todayCellTextStyle,
      weekendDatesTextStyle: weekendDatesTextStyle,
      specialDatesTextStyle: specialDatesTextStyle,
    );
  }

  /// Create a [SfDateRangePickerThemeData] given a set of exact values. All the values must be
  /// specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfDateRangePickerThemeData] constructor.
  const SfDateRangePickerThemeData.raw({
    @required this.brightness,
    @required this.backgroundColor,
    @required this.viewHeaderTextStyle,
    @required this.headerTextStyle,
    @required this.trailingDatesTextStyle,
    @required this.leadingCellTextStyle,
    @required this.activeDatesTextStyle,
    @required this.cellTextStyle,
    @required this.rangeSelectionTextStyle,
    @required this.rangeSelectionColor,
    @required this.leadingDatesTextStyle,
    @required this.disabledDatesTextStyle,
    @required this.disabledCellTextStyle,
    @required this.selectionColor,
    @required this.selectionTextStyle,
    @required this.startRangeSelectionColor,
    @required this.endRangeSelectionColor,
    @required this.headerBackgroundColor,
    @required this.viewHeaderBackgroundColor,
    @required this.blackoutDatesTextStyle,
    @required this.todayHighlightColor,
    @required this.todayTextStyle,
    @required this.todayCellTextStyle,
    @required this.weekendDatesTextStyle,
    @required this.specialDatesTextStyle,
  });

  /// The brightness of the overall theme of the application for the chart widgets.
  final Brightness brightness;

  /// Specifies the background color of chart widgets.
  final Color backgroundColor;

  /// Specify the date picker view header text style in month view.
  final TextStyle viewHeaderTextStyle;

  /// Specify the date picker header text style.
  final TextStyle headerTextStyle;

  /// Specify the date picker trailing dates cell text style.
  final TextStyle trailingDatesTextStyle;

  /// Specify the date picker leading year, decade or century cell text style
  final TextStyle leadingCellTextStyle;

  /// Specify the date picker current month cells text style.
  final TextStyle activeDatesTextStyle;

  /// Specify the date picker current year, decade or century cells text style.
  final TextStyle cellTextStyle;

  /// Specify the date picker in-between selected range text style in month view when selection mode as range/multi-range selection.
  final TextStyle rangeSelectionTextStyle;

  /// Specify the date picker leading dates cell text style.
  final TextStyle leadingDatesTextStyle;

  /// Specify the date picker disabled cell text style.
  final TextStyle disabledDatesTextStyle;

  /// Specify the date picker disabled year, decade or century cell text style.
  final TextStyle disabledCellTextStyle;

  /// Specify the date picker selected dates background color in month view single and multiple selection.
  final Color selectionColor;

  /// Specify the date picker in-between selected range background color in month view when selection mode as range/multi-range selection.
  final Color rangeSelectionColor;

  /// Specify the date picker selected cell text style for the  single and multiple selection and also for the start and end range of single and multi-range selection.
  final TextStyle selectionTextStyle;

  /// Specify the date picker start date of selected range background color in month view when selection mode as range/multi-range selection.
  final Color startRangeSelectionColor;

  /// Specify the date picker end date of selected range background color in month view when selection mode as range/multi-range selection.
  final Color endRangeSelectionColor;

  /// Specify the date picker header background color.
  final Color headerBackgroundColor;

  /// Specify the view header background color in month view.
  final Color viewHeaderBackgroundColor;

  /// Specify the date picker blackout cell text style.
  final TextStyle blackoutDatesTextStyle;

  /// Specify the date picker today highlight color.
  final Color todayHighlightColor;

  /// Specify the date picker today date month cell text style.
  final TextStyle todayTextStyle;

  /// Specify the date picker today month, decade or century cell text style.
  final TextStyle todayCellTextStyle;

  /// Specify the date picker weekend cell text style.
  final TextStyle weekendDatesTextStyle;

  /// Specify the date picker special dates text style in month view
  final TextStyle specialDatesTextStyle;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  SfDateRangePickerThemeData copyWith({
    Brightness brightness,
    TextStyle viewHeaderTextStyle,
    Color backgroundColor,
    TextStyle headerTextStyle,
    TextStyle trailingDatesTextStyle,
    TextStyle leadingCellTextStyle,
    TextStyle activeDatesTextStyle,
    TextStyle cellTextStyle,
    TextStyle rangeSelectionTextStyle,
    TextStyle leadingDatesTextStyle,
    TextStyle disabledDatesTextStyle,
    TextStyle disabledCellTextStyle,
    Color selectionColor,
    Color rangeSelectionColor,
    TextStyle selectionTextStyle,
    Color startRangeSelectionColor,
    Color endRangeSelectionColor,
    Color headerBackgroundColor,
    Color viewHeaderBackgroundColor,
    TextStyle blackoutDatesTextStyle,
    Color todayHighlightColor,
    TextStyle todayTextStyle,
    TextStyle todayCellTextStyle,
    TextStyle weekendDatesTextStyle,
    TextStyle specialDatesTextStyle,
  }) {
    return SfDateRangePickerThemeData.raw(
      brightness: brightness ?? this.brightness,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      viewHeaderTextStyle: viewHeaderTextStyle ?? this.viewHeaderTextStyle,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      trailingDatesTextStyle:
          trailingDatesTextStyle ?? this.trailingDatesTextStyle,
      leadingCellTextStyle: leadingCellTextStyle ?? this.leadingCellTextStyle,
      activeDatesTextStyle: activeDatesTextStyle ?? this.activeDatesTextStyle,
      cellTextStyle: cellTextStyle ?? this.cellTextStyle,
      rangeSelectionTextStyle:
          rangeSelectionTextStyle ?? this.rangeSelectionTextStyle,
      rangeSelectionColor: rangeSelectionColor ?? this.rangeSelectionColor,
      leadingDatesTextStyle:
          leadingDatesTextStyle ?? this.leadingDatesTextStyle,
      disabledDatesTextStyle:
          disabledDatesTextStyle ?? this.disabledDatesTextStyle,
      disabledCellTextStyle:
          disabledCellTextStyle ?? this.disabledCellTextStyle,
      selectionColor: selectionColor ?? this.selectionColor,
      selectionTextStyle: selectionTextStyle ?? this.selectionTextStyle,
      startRangeSelectionColor:
          startRangeSelectionColor ?? this.startRangeSelectionColor,
      endRangeSelectionColor:
          endRangeSelectionColor ?? this.endRangeSelectionColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      viewHeaderBackgroundColor:
          viewHeaderBackgroundColor ?? this.viewHeaderBackgroundColor,
      blackoutDatesTextStyle:
          blackoutDatesTextStyle ?? this.blackoutDatesTextStyle,
      todayHighlightColor: todayHighlightColor ?? this.todayHighlightColor,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      todayCellTextStyle: todayCellTextStyle ?? this.todayCellTextStyle,
      weekendDatesTextStyle:
          weekendDatesTextStyle ?? this.weekendDatesTextStyle,
      specialDatesTextStyle:
          specialDatesTextStyle ?? this.specialDatesTextStyle,
    );
  }

  static SfDateRangePickerThemeData lerp(
      SfDateRangePickerThemeData a, SfDateRangePickerThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) {
      return null;
    }
    return SfDateRangePickerThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      rangeSelectionColor:
          Color.lerp(a.rangeSelectionColor, b.rangeSelectionColor, t),
      selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t),
      startRangeSelectionColor:
          Color.lerp(a.startRangeSelectionColor, b.startRangeSelectionColor, t),
      endRangeSelectionColor:
          Color.lerp(a.endRangeSelectionColor, b.endRangeSelectionColor, t),
      headerBackgroundColor:
          Color.lerp(a.headerBackgroundColor, b.headerBackgroundColor, t),
      viewHeaderBackgroundColor: Color.lerp(
          a.viewHeaderBackgroundColor, b.viewHeaderBackgroundColor, t),
      todayHighlightColor:
          Color.lerp(a.todayHighlightColor, b.todayHighlightColor, t),
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
    final SfDateRangePickerThemeData typedOther = other;
    return typedOther.viewHeaderTextStyle == viewHeaderTextStyle &&
        typedOther.backgroundColor == backgroundColor &&
        typedOther.headerTextStyle == headerTextStyle &&
        typedOther.trailingDatesTextStyle == trailingDatesTextStyle &&
        typedOther.leadingCellTextStyle == leadingCellTextStyle &&
        typedOther.activeDatesTextStyle == activeDatesTextStyle &&
        typedOther.cellTextStyle == cellTextStyle &&
        typedOther.rangeSelectionTextStyle == rangeSelectionTextStyle &&
        typedOther.rangeSelectionColor == rangeSelectionColor &&
        typedOther.leadingDatesTextStyle == leadingDatesTextStyle &&
        typedOther.disabledDatesTextStyle == disabledDatesTextStyle &&
        typedOther.disabledCellTextStyle == disabledCellTextStyle &&
        typedOther.selectionColor == selectionColor &&
        typedOther.selectionTextStyle == selectionTextStyle &&
        typedOther.startRangeSelectionColor == startRangeSelectionColor &&
        typedOther.endRangeSelectionColor == endRangeSelectionColor &&
        typedOther.headerBackgroundColor == headerBackgroundColor &&
        typedOther.viewHeaderBackgroundColor == viewHeaderBackgroundColor &&
        typedOther.blackoutDatesTextStyle == blackoutDatesTextStyle &&
        typedOther.todayHighlightColor == todayHighlightColor &&
        typedOther.todayTextStyle == todayTextStyle &&
        typedOther.todayCellTextStyle == todayCellTextStyle &&
        typedOther.weekendDatesTextStyle == weekendDatesTextStyle &&
        typedOther.specialDatesTextStyle == specialDatesTextStyle;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      viewHeaderTextStyle,
      backgroundColor,
      headerTextStyle,
      trailingDatesTextStyle,
      leadingCellTextStyle,
      activeDatesTextStyle,
      cellTextStyle,
      rangeSelectionTextStyle,
      rangeSelectionColor,
      leadingDatesTextStyle,
      disabledDatesTextStyle,
      disabledCellTextStyle,
      selectionColor,
      selectionTextStyle,
      startRangeSelectionColor,
      endRangeSelectionColor,
      headerBackgroundColor,
      viewHeaderBackgroundColor,
      blackoutDatesTextStyle,
      todayHighlightColor,
      todayTextStyle,
      todayCellTextStyle,
      weekendDatesTextStyle,
      specialDatesTextStyle,
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfDateRangePickerThemeData defaultData = SfDateRangePickerThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('backgroundColor', backgroundColor,
        defaultValue: defaultData.backgroundColor));
    properties.add(ColorProperty('rangeSelectionColor', rangeSelectionColor,
        defaultValue: defaultData.rangeSelectionColor));
    properties.add(ColorProperty('selectionColor', selectionColor,
        defaultValue: defaultData.selectionColor));
    properties.add(ColorProperty(
        'startRangeSelectionColor', startRangeSelectionColor,
        defaultValue: defaultData.startRangeSelectionColor));
    properties.add(ColorProperty(
        'endRangeSelectionColor', endRangeSelectionColor,
        defaultValue: defaultData.endRangeSelectionColor));
    properties.add(ColorProperty('headerBackgroundColor', headerBackgroundColor,
        defaultValue: defaultData.headerBackgroundColor));
    properties.add(ColorProperty(
        'viewHeaderBackgroundColor', viewHeaderBackgroundColor,
        defaultValue: defaultData.viewHeaderBackgroundColor));
    properties.add(ColorProperty('todayHighlightColor', todayHighlightColor,
        defaultValue: defaultData.todayHighlightColor));
  }
}
