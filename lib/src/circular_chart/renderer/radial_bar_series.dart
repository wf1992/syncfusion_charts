part of charts;

/// Renders the radial bar series.
///
/// The radial bar chart is used for showing the comparisons among the categories using the circular shapes.
/// To render a radial bar chart, create an instance of RadialBarSeries, and add to the series collection property of [SfCircularChart].
///
///Provides options to customize the [maximumValue], [trackColor], [trackBorderColor], [trackBorderWidth], [trackOpacity]
///and [useSeriesColor] of the pie segments.
class RadialBarSeries<T, D> extends CircularSeries<T, D> {
  RadialBarSeries(
      {List<T> dataSource,
      ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> pointRadiusMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      ChartValueMapper<T, String> sortFieldValueMapper,
      this.trackColor = const Color.fromRGBO(234, 236, 239, 1.0),
      this.trackBorderWidth = 0.0,
      this.trackOpacity = 1,
      this.useSeriesColor = false,
      this.trackBorderColor = Colors.transparent,
      this.maximumValue,
      DataLabelSettings dataLabelSettings,
      String radius,
      String innerRadius,
      String gap,
      double strokeWidth,
      double opacity,
      Color strokeColor,
      bool enableTooltip,
      bool enableSmartLabels,
      String name,
      double animationDuration,
      SelectionSettings selectionSettings,
      SortingOrder sortingOrder,
      LegendIconType legendIconType,
      CornerStyle cornerStyle,
      List<int> initialSelectedDataIndexes})
      : super(
          dataSource: dataSource,
          animationDuration: animationDuration,
          xValueMapper: (int index) => xValueMapper(dataSource[index], index),
          yValueMapper: (int index) => yValueMapper(dataSource[index], index),
          pointColorMapper: (int index) => pointColorMapper != null
              ? pointColorMapper(dataSource[index], index)
              : null,
          pointRadiusMapper: (int index) => pointRadiusMapper != null
              ? pointRadiusMapper(dataSource[index], index)
              : null,
          dataLabelMapper: (int index) => dataLabelMapper != null
              ? dataLabelMapper(dataSource[index], index)
              : null,
          sortFieldValueMapper: sortFieldValueMapper != null
              ? (int index) => sortFieldValueMapper(dataSource[index], index)
              : null,
          radius: radius,
          innerRadius: innerRadius,
          gap: gap,
          borderColor: strokeColor,
          borderWidth: strokeWidth,
          opacity: opacity,
          enableTooltip: enableTooltip,
          dataLabelSettings: dataLabelSettings,
          name: name,
          selectionSettings: selectionSettings,
          sortingOrder: sortingOrder,
          legendIconType: legendIconType,
          enableSmartLabels: enableSmartLabels,
          cornerStyle: cornerStyle,
          initialSelectedDataIndexes: initialSelectedDataIndexes,
        );

  ///Color of the track
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackColor: Colors.red,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackColor;

  ///Specifies the maximum value of the radial bar.
  ///
  /// By default, the sum of the data points values will be considered as maximum value.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  maximumValue: 100,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double maximumValue;

  ///Border color of the track
  ///
  ///Defaults to `colors.Transparent`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderColor: Colors.red,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackBorderColor;

  ///Border width of the track
  ///
  ///Defaults to `0.0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderColor: Colors.red,
  ///                  trackBorderWidth: 2,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackBorderWidth;

  ///Opacity of the track
  ///
  ///Defaults to `1`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackOpacity: 0.2,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackOpacity;

  ///Uses the point color for filling the track
  ///
  ///Defaults to `false`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  useSeriesColor:true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool useSeriesColor;

  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  useSeriesColor:true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```

}

class _RadialBarPainter extends CustomPainter {
  _RadialBarPainter({
    this.chart,
    this.index,
    this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    ValueNotifier<num> notifier,
  }) : super(repaint: notifier);
  final SfCircularChart chart;
  final int index;
  final bool isRepaint;
  final AnimationController animationController;
  final Animation<double> seriesAnimation;

  RadialBarSeries<dynamic, dynamic> series;

  num innerRadius;

  num radius;

  Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    num pointStartAngle, pointEndAngle, degree, length = 0;
    series = chart._chartSeries.visibleSeries[index];
    series._pointRegions = <_Region>[];
    final num sum = series._sumOfPoints, actualStartAngle = series._start;
    innerRadius = series._currentInnerRadius;
    radius = series._currentRadius;
    ChartPoint<dynamic> point, oldPoint;
    center = series._center;
    canvas.clipRect(chart._chartState.chartAreaRect);

    /// finding visible points count
    for (int i = 0; i < series._renderPoints.length; i++) {
      length += series._renderPoints[i].isVisible ? 1 : 0;
    }

    /// finding first visible point
    final int firstVisible = _getFirstVisiblePointIndex();
    final num ringSize =
        (series._currentRadius - series._currentInnerRadius).abs() / length;
    final num gap = _percentToValue(
        series.gap, (series._currentRadius - series._currentInnerRadius).abs());
    final num animationValue =
        seriesAnimation != null ? seriesAnimation.value : 1;
    final bool isLegendToggle = chart._chartState._isLegendToggled;
    final RadialBarSeries<dynamic, dynamic> oldSeries =
        (chart._chartState.widgetNeedUpdate &&
                !chart._chartState._isLegendToggled &&
                chart._chartState.prevSeries._seriesType == 'radialbar')
            ? chart._chartState.prevSeries
            : null;
    for (int i = 0; i < series._renderPoints.length; i++) {
      point = series._renderPoints[i];
      oldPoint =
          (oldSeries != null && (oldSeries._renderPoints.length - 1 >= i))
              ? oldSeries._renderPoints[i]
              : (isLegendToggle ? chart._chartState._oldPoints[i] : null);
      pointStartAngle = actualStartAngle;
      final bool isDynamicUpdate = oldPoint != null;
      bool hide = false;
      num oldStart, oldEnd, oldRadius, oldInnerRadius, value;
      if (!isDynamicUpdate ||
          ((oldPoint.isVisible && point.isVisible) ||
              (oldPoint.isVisible && !point.isVisible) ||
              (!oldPoint.isVisible && point.isVisible))) {
        if (point.isVisible) {
          hide = false;
          if (isDynamicUpdate && !isLegendToggle) {
            value = (point.y > oldPoint.y)
                ? oldPoint.y + (point.y - oldPoint.y) * animationValue
                : oldPoint.y - (oldPoint.y - point.y) * animationValue;
          }
          degree = (value != null ? value : point.y).abs() /
              (series.maximumValue ?? sum);
          degree = (degree > 1 ? 1 : degree) * (360 - 0.001);
          degree = isDynamicUpdate ? degree : degree * animationValue;
          pointEndAngle = pointStartAngle + degree;
          point.midAngle = (pointStartAngle + pointEndAngle) / 2;
          point.startAngle = pointStartAngle;
          point.endAngle = pointEndAngle;
          point.center = center;
          point.innerRadius =
              innerRadius = innerRadius + ((i == firstVisible) ? 0 : ringSize);
          point.outerRadius =
              radius = ringSize < gap ? 0 : innerRadius + ringSize - gap;
          if (isLegendToggle) {
            _calculateVisiblePointLegendToggleAnimation(
                point, oldPoint, i, animationValue);
          }
        } //animate on hiding
        else if (isLegendToggle && !point.isVisible && oldPoint.isVisible) {
          hide = true;
          oldEnd = oldPoint.endAngle;
          oldStart = oldPoint.startAngle;
          degree = oldPoint.y.abs() / (series.maximumValue ?? sum);
          degree = (degree > 1 ? 1 : degree) * (360 - 0.001);
          oldInnerRadius = oldPoint.innerRadius +
              ((oldPoint.outerRadius + oldPoint.innerRadius) / 2 -
                      oldPoint.innerRadius) *
                  animationValue;
          oldRadius = oldPoint.outerRadius -
              (oldPoint.outerRadius -
                      (oldPoint.outerRadius + oldPoint.innerRadius) / 2) *
                  animationValue;
        }
        _drawDataPoint(
            point,
            degree,
            pointStartAngle,
            pointEndAngle,
            series,
            hide,
            oldRadius,
            oldInnerRadius,
            oldPoint,
            oldStart,
            oldEnd,
            i,
            canvas);
      }
    }
  }

  /// finding first visible point
  int _getFirstVisiblePointIndex() {
    for (int i = 0; i < series._renderPoints.length; i++) {
      if (series._renderPoints[i].isVisible) {
        return i;
      }
    }
    return null;
  }

  void _calculateVisiblePointLegendToggleAnimation(ChartPoint<dynamic> point,
      ChartPoint<dynamic> oldPoint, int i, num animationValue) {
    if (!oldPoint.isVisible && point.isVisible) {
      radius = i == 0
          ? point.outerRadius
          : (point.innerRadius +
              (point.outerRadius - point.innerRadius) * animationValue);
      innerRadius = i == 0
          ? (point.outerRadius -
              (point.outerRadius - point.innerRadius) * animationValue)
          : innerRadius;
    } else {
      radius = (point.outerRadius > oldPoint.outerRadius)
          ? oldPoint.outerRadius +
              (point.outerRadius - oldPoint.outerRadius) * animationValue
          : oldPoint.outerRadius -
              (oldPoint.outerRadius - point.outerRadius) * animationValue;
      innerRadius = (point.innerRadius > oldPoint.innerRadius)
          ? oldPoint.innerRadius +
              (point.innerRadius - oldPoint.innerRadius) * animationValue
          : oldPoint.innerRadius -
              (oldPoint.innerRadius - point.innerRadius) * animationValue;
    }
  }

  void _drawDataPoint(
      ChartPoint<dynamic> point,
      num degree,
      num pointStartAngle,
      num pointEndAngle,
      RadialBarSeries<dynamic, dynamic> series,
      bool hide,
      num oldRadius,
      num oldInnerRadius,
      ChartPoint<dynamic> oldPoint,
      num oldStart,
      num oldEnd,
      int i,
      Canvas canvas) {
    _drawPath(
        canvas,
        _StyleOptions(
            series.useSeriesColor ? point.fill : series.trackColor,
            series.trackBorderWidth,
            series.trackBorderColor,
            series.trackOpacity),
        _getArcPath(
            hide ? oldInnerRadius : innerRadius,
            hide ? oldRadius : radius.toDouble(),
            center,
            0,
            360 - 0.001,
            360 - 0.001,
            chart,
            true));
    if (radius > 0 && degree > 0) {
      _renderPoint(point, degree, pointStartAngle, pointEndAngle, series, hide,
          oldRadius, oldInnerRadius, oldPoint, oldStart, oldEnd, i, canvas);
    }
  }

  void _renderPoint(
      ChartPoint<dynamic> point,
      num degree,
      num pointStartAngle,
      num pointEndAngle,
      RadialBarSeries<dynamic, dynamic> series,
      bool hide,
      num oldRadius,
      num oldInnerRadius,
      ChartPoint<dynamic> oldPoint,
      num oldStart,
      num oldEnd,
      int i,
      Canvas canvas) {
    if (point.isVisible) {
      final _Region pointRegion = _Region(
          _degreesToRadians(point.startAngle),
          _degreesToRadians(point.endAngle),
          point.startAngle,
          point.endAngle,
          index,
          i,
          point.center,
          innerRadius,
          point.outerRadius);
      series._pointRegions.add(pointRegion);
    }

    final num angleDeviation = _findAngleDeviation(
        hide ? oldInnerRadius : innerRadius, hide ? oldRadius : radius, 360);
    final CornerStyle cornerStyle = series.cornerStyle;
    if (cornerStyle == CornerStyle.bothCurve ||
        cornerStyle == CornerStyle.startCurve) {
      hide
          ? oldStart = oldPoint.startAngle + angleDeviation
          : pointStartAngle += angleDeviation;
    }
    if (cornerStyle == CornerStyle.bothCurve ||
        cornerStyle == CornerStyle.endCurve) {
      hide
          ? oldEnd = oldPoint.endAngle - angleDeviation
          : pointEndAngle -= angleDeviation;
    }
    final _StyleOptions style = series._selectPoint(i, series, chart, point);
    final Color fillColor = style != null && style.fill != null
        ? style.fill
        : (point.fill != Colors.transparent
            ? series._renderer.getPointColor(
                series, point, i, index, point.fill, series.opacity)
            : point.fill);
    final Color strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor
        : series._renderer
            .getPointStrokeColor(series, point, i, index, point.strokeColor);
    final double strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth
        : series._renderer
            .getPointStrokeWidth(series, point, i, index, point.strokeWidth);
    final double opacity = style != null && style.opacity != null
        ? style.opacity
        : series._renderer.getOpacity(series, point, i, index, series.opacity);
    if (hide
        ? (((oldEnd - oldStart) > 0) && (oldRadius != oldInnerRadius))
        : ((pointEndAngle - pointStartAngle) > 0)) {
      _drawPath(
          canvas,
          _StyleOptions(
              fillColor,
              chart._chartState.animateCompleted ? strokeWidth : 0,
              strokeColor,
              opacity),
          _getRoundedCornerArcPath(
              hide ? oldInnerRadius : innerRadius,
              hide ? oldRadius : radius,
              center,
              hide ? oldStart : pointStartAngle,
              hide ? oldEnd : pointEndAngle,
              degree,
              series.cornerStyle));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => isRepaint;
}
