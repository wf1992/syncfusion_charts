part of charts;

/// Renders the line series.
///
/// This class holds the properties of line series. To render a Line chart,
/// create an instance of [LineSeries], and add it to the series collection
/// property of [SfCartesianChart]. A line chart requires two fields (X and Y)
/// to plot a point.
///
/// Provide the options for color, opacity, border color, and border width to customize the appearance.
class LineSeries<T, D> extends XyDataSeries<T, D> {
  LineSeries(
      {@required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String xAxisName,
      String yAxisName,
      Color color,
      double width,
      LinearGradient gradient,
      MarkerSettings markerSettings,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      List<Trendline> trendlines,
      bool isVisible,
      String name,
      bool enableTooltip,
      List<double> dashArray,
      double animationDuration,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      SortingOrder sortingOrder,
      String legendItemText,
      double opacity,
      List<int> initialSelectedDataIndexes})
      : super(
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 2,
            gradient: gradient,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            trendlines: trendlines,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            dashArray: dashArray,
            animationDuration: animationDuration,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => LineSegment();

  /// Creates a collection of segments for the points in the series.
  @override
  void createSegments() {}

  ChartSegment addSegment(
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> nextPoint,
      int pointIndex,
      int seriesIndex,
      num animateFactor) {
    final LineSegment segment = createSegment();
    segment.series = this;
    segment._seriesIndex = seriesIndex;
    segment._currentPoint = currentPoint;
    segment.currentSegmentIndex = pointIndex;
    segment._nextPoint = nextPoint;
    segment.chart = _chart;
    segment.animationFactor = animateFactor;
    segment._pointColorMapper = currentPoint.pointColorMapper;
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
    segment.calculateSegmentPoints();
    customizeSegment(segment);
    segments.add(segment);
    return segment;
  }

  void drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final LineSegment lineSegment = segment;
    lineSegment.color = lineSegment._pointColorMapper ??
        lineSegment.series.color ??
        lineSegment.series._seriesColor;
    lineSegment.strokeColor = lineSegment._pointColorMapper ??
        lineSegment.series.color ??
        lineSegment.series._seriesColor;
    lineSegment.strokeWidth = lineSegment.series.width;
    lineSegment.strokePaint = lineSegment.getStrokePaint();
    lineSegment.fillPaint = lineSegment.getFillPaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
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
