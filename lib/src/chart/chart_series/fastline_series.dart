part of charts;

///Renders the FastLineSeries.
///
///FastLineSeries is a line chart, but it loads faster than LineSeries.
///
/// You can use this when there are large number of points to be loaded in a chart. To render a fast line chart,
///  create an instance of FastLineSeries, and add it to the series collection property of [SfCartesianChart].
///
/// The following properties are used to customize the appearance of fast line segment:
///
/// * color – Changes the color of the line.
/// * opacity - Controls the transparency of the chart series.
/// * width – Changes the stroke width of the line.
class FastLineSeries<T, D> extends XyDataSeries<T, D> {
  FastLineSeries(
      {@required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String xAxisName,
      String yAxisName,
      Color color,
      double width,
      List<double> dashArray,
      LinearGradient gradient,
      MarkerSettings markerSettings,
      EmptyPointSettings emptyPointSettings,
      List<Trendline> trendlines,
      DataLabelSettings dataLabelSettings,
      SortingOrder sortingOrder,
      bool isVisible,
      String name,
      bool enableTooltip,
      double animationDuration,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      double opacity})
      : super(
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            trendlines: trendlines,
            color: color,
            width: width ?? 2,
            gradient: gradient,
            dashArray: dashArray,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity);

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => FastLineSegment();

  /// Creates a collection of segments for the points in the series.
  @override
  void createSegments() {}

  ///Adds the segment to the segments list
  ChartSegment addSegment(
      int seriesIndex, SfCartesianChart chart, num animateFactor) {
    final FastLineSegment segment = createSegment();
    segment.series = this;
    segment._seriesIndex = seriesIndex;
    segment.animationFactor = animateFactor;
    customizeSegment(segment);
    segment.chart = chart;
    segments.add(segment);
    return segment;
  }

  ///Renders the segment.
  void drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final FastLineSegment fastLineSegment = segment;
    fastLineSegment.color = fastLineSegment.series._seriesColor;
    fastLineSegment.strokeColor = fastLineSegment.series._seriesColor;
    fastLineSegment.strokeWidth = fastLineSegment.series.width;
    fastLineSegment.strokePaint = fastLineSegment.getStrokePaint();
    fastLineSegment.fillPaint = fastLineSegment.getFillPaint();
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
