part of charts;

/// This class Renders the area series.
///
/// To render an area chart, create an instance of AreaSeries, and add it to the series collection property of SfCartesianChart.
/// The area chart shows the filled area to represent the data, but when there are more than a series, this may hide the other series.
/// To get rid of this, increase or decrease the transparency of the series.
///
/// It provides options for color, opacity, border color, and border width to customize the appearance.
///
class AreaSeries<T, D> extends XyDataSeries<T, D> {
  AreaSeries(
      {@required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      String xAxisName,
      String yAxisName,
      String name,
      Color color,
      MarkerSettings markerSettings,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      List<Trendline> trendlines,
      bool isVisible,
      bool enableTooltip,
      List<double> dashArray,
      double animationDuration,
      Color borderColor,
      double borderWidth,
      LinearGradient gradient,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      double opacity,
      BorderDrawMode borderDrawMode})
      : borderDrawMode = borderDrawMode ?? BorderDrawMode.top,
        super(
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            name: name,
            color: color,
            trendlines: trendlines,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            dashArray: dashArray,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            gradient: gradient,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity);

  ///Border type of area series.
  ///
  ///It have the three types of [BorderDrawMode],
  ///
  ///* [BorderDrawMode.all] renders border for all the sides of area.
  ///
  ///* [BorderDrawMode.top] renders border only for top side.
  ///
  ///* [BorderDrawMode.excludeBottom] renders border except bottom side.
  ///
  ///
  ///Defaults to `BorderDrawMode.top`.
  ///
  ///Also refer [BorderDrawMode].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <AreaSeries<SalesData, num>>[
  ///                AreaSeries<SalesData, num>(
  ///                  borderDrawMode: BorderDrawMode.all,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BorderDrawMode borderDrawMode;

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => AreaSegment();

  /// Creates a collection of segments for the points in the series.
  @override
  void createSegments() {}

  ChartSegment addSegment(
      int seriesIndex, SfCartesianChart chart, num animateFactor) {
    final AreaSegment segment = createSegment();
    segment.series = this;
    segment._seriesIndex = seriesIndex;
    segment.animationFactor = animateFactor;
    if (_chart._chartState.widgetNeedUpdate &&
        _chart._chartState.prevWidgetSeries != null &&
        _chart._chartState.prevWidgetSeries.isNotEmpty &&
        _chart._chartState.prevWidgetSeries.length - 1 >=
            segment._seriesIndex &&
        _chart._chartState.prevWidgetSeries[segment._seriesIndex]._seriesName ==
            segment.series._seriesName) {
      segment.oldSeries =
          _chart._chartState.prevWidgetSeries[segment._seriesIndex];
    }
    customizeSegment(segment);
    segment.chart = chart;
    segments.add(segment);
    return segment;
  }

  void drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final AreaSegment areaSegment = segment;
    areaSegment.color = areaSegment.series._seriesColor;
    areaSegment.strokeColor = areaSegment.series._seriesColor;
    areaSegment.strokeWidth = areaSegment.series.width;
    areaSegment.strokePaint = areaSegment.getStrokePaint();
    areaSegment.fillPaint = areaSegment.getFillPaint();
  }

  /// Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY) {
    final Size size = Size(markerSettings.width, markerSettings.height);
    final Path markerPath = _getMarkerShapes(
        markerSettings.shape, Offset(pointX, pointY), size, this);
    canvas.drawPath(markerPath, fillPaint);
    canvas.drawPath(markerPath, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, ChartTextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
