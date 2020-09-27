part of charts;

/// This class has the properties of the column series.
///
/// To render a column chart, create an instance of [ColumnSeries], and add it to the series collection property of [SfCartesianChart].
/// The column series is a rectangular column with heights or lengths proportional to the values that they represent. it has the spacing
/// property to separate the column.
///
/// Provide the options of color, opacity, border color, and border width to customize the appearance.
///
class ColumnSeries<T, D> extends XyDataSeries<T, D> {
  ColumnSeries(
      {@required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      this.isTrackVisible = false,
      String xAxisName,
      String yAxisName,
      String name,
      Color color,
      double width,
      double spacing,
      MarkerSettings markerSettings,
      List<Trendline> trendlines,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
      LinearGradient gradient,
      BorderRadius borderRadius,
      bool enableTooltip,
      double animationDuration,
      Color trackColor,
      Color trackBorderColor,
      double trackBorderWidth,
      double trackPadding,
      Color borderColor,
      double borderWidth,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      double opacity,
      List<double> dashArray,
      List<int> initialSelectedDataIndexes})
      : trackColor = trackColor ?? Colors.grey,
        trackBorderColor = trackBorderColor ?? Colors.transparent,
        trackBorderWidth = trackBorderWidth ?? 1,
        trackPadding = trackPadding ?? 0,
        spacing = spacing ?? 0,
        borderRadius = borderRadius ?? const BorderRadius.all(Radius.zero),
        super(
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            trendlines: trendlines,
            color: color,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            dashArray: dashArray,
            initialSelectedDataIndexes: initialSelectedDataIndexes);
  num _rectPosition;
  num _rectCount;

  ///Color of the track.
  ///
  ///Defaults to `grey`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackColor: Colors.red
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackColor;

  ///Color of the track border.
  ///
  ///Defaults to `transparent`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackBorderColor: Colors.red
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackBorderColor;

  ///Width of the track border.
  ///
  ///Defaults to `1`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackBorderColor: Colors.red ,
  ///                  trackBorderWidth: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackBorderWidth;

  ///Padding of the track.
  ///
  ///Defaults to `0`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackPadding: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackPadding;

  ///Spacing between the columns. The value ranges from 0 to 1.
  ///1 represents 100% and 0 represents 0% of the available space.
  ///
  ///Spacing also affects the width of the column. For example, setting 20% spacing
  ///and 100% width renders the column with 80% of total width.
  ///
  ///Defaults to `0`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  spacing: 0,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double spacing;

  ///Renders column with track.
  ///
  ///Track is a rectangular bar rendered from the start to the end of the axis. Column series will be rendered above the track.
  ///
  ///Defaults to `false`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool isTrackVisible;

  ///Customizes the corners of the column.
  ///
  /// Each corner can be customized with a desired value or with a single value.
  ///
  ///Defaults to `Radius.zero`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  borderRadius: BorderRadius.circular(5),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BorderRadius borderRadius;

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => ColumnSegment();

  /// Creates a collection of segments for the points in the series.
  @override
  void createSegments() {}

  ChartSegment addSegment(
      CartesianChartPoint<dynamic> currentPoint,
      int pointIndex,
      _VisibleRange sideBySideInfo,
      int seriesIndex,
      num animateFactor) {
    final ColumnSegment segment = createSegment();
    segment.series = this;
    segment.chart = _chart;
    segment._seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.animationFactor = animateFactor;
    final num origin = math.max(_yAxis._visibleRange.minimum, 0);
    currentPoint.region = _calculateRectangle(
        currentPoint.xValue + sideBySideInfo.minimum,
        currentPoint.yValue,
        currentPoint.xValue + sideBySideInfo.maximum,
        math.max(_yAxis._visibleRange.minimum, 0),
        this,
        _chart);
    segment._currentPoint = currentPoint;
    if (_chart._chartState.widgetNeedUpdate &&
        !_chart._chartState._isLegendToggled &&
        _chart._chartState.prevWidgetSeries != null &&
        _chart._chartState.prevWidgetSeries.isNotEmpty &&
        _chart._chartState.prevWidgetSeries.length - 1 >=
            segment._seriesIndex &&
        _chart._chartState.prevWidgetSeries[segment._seriesIndex]._seriesName ==
            segment.series._seriesName) {
      segment.oldSeries =
          _chart._chartState.prevWidgetSeries[segment._seriesIndex];
      segment._oldPoint = (segment.oldSeries.segments.isNotEmpty &&
              segment.oldSeries.segments[0] is ColumnSegment &&
              segment.oldSeries._dataPoints.length - 1 >= pointIndex)
          ? segment.oldSeries._dataPoints[pointIndex]
          : null;
    } else if (_chart._chartState._isLegendToggled &&
        _chart._chartState.segments != null &&
        _chart._chartState.segments.isNotEmpty) {
      segment._oldSeriesVisible =
          _chart._chartState._oldSeriesVisible[segment._seriesIndex];
      for (int i = 0; i < _chart._chartState.segments.length; i++) {
        final ChartSegment oldSegment = _chart._chartState.segments[i];
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            oldSegment._seriesIndex == segment._seriesIndex) {
          segment._oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segment.path = _dashedBorder(currentPoint, borderWidth);
    if (borderRadius != null) {
      segment.segmentRect = getRRectFromRect(currentPoint.region, borderRadius);
    }
    //Tracker rect
    if (isTrackVisible) {
      currentPoint.trackerRectRegion = _calculateShadowRectangle(
          currentPoint.xValue + sideBySideInfo.minimum,
          currentPoint.yValue,
          currentPoint.xValue + sideBySideInfo.maximum,
          origin,
          this,
          _chart,
          Offset(segment.series._xAxis?.plotOffset,
              segment.series._yAxis?.plotOffset));
      if (borderRadius != null) {
        segment._trackRect =
            getRRectFromRect(currentPoint.trackerRectRegion, borderRadius);
      }
    }
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
    final ColumnSegment columnSegment = segment;
    columnSegment.color = columnSegment._currentPoint.pointColorMapper ??
        segment.series._seriesColor;
    columnSegment.strokeColor = segment.series.borderColor;
    columnSegment.strokeWidth = segment.series.borderWidth;
    columnSegment.strokePaint = columnSegment.getStrokePaint();
    columnSegment.fillPaint = columnSegment.getFillPaint();
    columnSegment._trackerFillPaint = columnSegment._getTrackerFillPaint();
    columnSegment._trackerStrokePaint = columnSegment._getTrackerStrokePaint();
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
