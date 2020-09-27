part of charts;

/// Renders the scatter series.
///
/// To render a scatter chart, create an instance of ScatterSeries, and add it to the series collection property of [SfCartesianChart].
///
/// The following properties, such as [color], [opacity], [borderWidth], [borderColor] can be used to customize  the appearance of the scatter segment.

class ScatterSeries<T, D> extends XyDataSeries<T, D> {
  ScatterSeries(
      {@required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String xAxisName,
      String yAxisName,
      String name,
      Color color,
      MarkerSettings markerSettings,
      EmptyPointSettings emptyPointSettings,
      bool isVisible,
      DataLabelSettings dataLabelSettings,
      bool enableTooltip,
      List<Trendline> trendlines,
      double animationDuration,
      Color borderColor,
      double borderWidth,
      LinearGradient gradient,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      SortingOrder sortingOrder,
      String legendItemText,
      double opacity,
      List<int> initialSelectedDataIndexes})
      : super(
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
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            isVisible: isVisible,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            trendlines: trendlines,
            gradient: gradient,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => ScatterSegment();
  // ignore:unused_field
  CartesianChartPoint<dynamic> _point;

  final bool _isLineType = false;

  /// Creates a collection of segments for the points in the series.
  @override
  void createSegments() {}

  void drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  ///Adds the points to the segments .
  ChartSegment addSegment(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    final ScatterSegment segment = createSegment();
    _isRectSeries = false;
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.series = this;
      segment.animationFactor = animateFactor;
      segment._point = currentPoint;
      segment._currentPoint = currentPoint;
      if (_chart._chartState.widgetNeedUpdate &&
          !_chart._chartState._isLegendToggled &&
          _chart._chartState.prevWidgetSeries != null &&
          _chart._chartState.prevWidgetSeries.isNotEmpty &&
          _chart._chartState.prevWidgetSeries.length - 1 >=
              segment._seriesIndex &&
          _chart._chartState.prevWidgetSeries[segment._seriesIndex]
                  ._seriesName ==
              segment.series._seriesName) {
        segment.oldSeries =
            _chart._chartState.prevWidgetSeries[segment._seriesIndex];
        segment._oldPoint = (segment.oldSeries.segments.isNotEmpty &&
                segment.oldSeries.segments[0] is ScatterSegment &&
                segment.oldSeries._dataPoints.length - 1 >= pointIndex)
            ? segment.oldSeries._dataPoints[pointIndex]
            : null;
      }
      final _ChartLocation location = _calculatePoint(
          currentPoint.xValue,
          currentPoint.yValue,
          _xAxis,
          _yAxis,
          _chart._requireInvertedAxis,
          this,
          _chart._chartAxis._axisClipRect);
      segment.centerX = location.x;
      segment.centerY = location.y;
      segment.radius = markerSettings.width;
      segment.segmentRect =
          RRect.fromRectAndRadius(currentPoint.region, Radius.zero);
      customizeSegment(segment);
      segments.add(segment);
    }
    return segment;
  }

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final ScatterSegment scatterSegment = segment;
    scatterSegment.color = scatterSegment.series._seriesColor;
    scatterSegment.strokeColor =
        scatterSegment.series.borderColor ?? scatterSegment.series._seriesColor;
    scatterSegment.strokeWidth = scatterSegment.series.borderWidth;
    scatterSegment.strokePaint = scatterSegment.getStrokePaint();
    scatterSegment.fillPaint = scatterSegment.getFillPaint();
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
