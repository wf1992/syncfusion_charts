part of charts;

/// Renders the range area series.
///
/// To render a range area chart, create an instance of RangeAreaSeries and add to the series collection property of [SfCartesianChart].
/// RangeAreaSeries is similar to Areaseries requires two Y values for a point, data should contain high and low values.
///
/// High and low value specify the maximum and minimum range of the point.
///
/// [highValueMapper] - Field in the data source, which is considered as high value for the data points.
/// [lowValueMapper] - Field in the data source, which is considered as low value for the data points.
class RangeAreaSeries<T, D> extends XyDataSeries<T, D> {
  RangeAreaSeries(
      {@required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> highValueMapper,
      @required ChartValueMapper<T, num> lowValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      String xAxisName,
      List<Trendline> trendlines,
      String yAxisName,
      String name,
      Color color,
      MarkerSettings markerSettings,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
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
      RangeAreaBorderMode borderDrawMode})
      : borderDrawMode = borderDrawMode ?? RangeAreaBorderMode.all,
        super(
            xValueMapper: xValueMapper,
            highValueMapper: highValueMapper,
            lowValueMapper: lowValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            trendlines: trendlines,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            name: name,
            color: color,
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
  ///Defaults to BorderDrawMode.top
  ///
  ///Also refer [BorderDrawMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <RangeAreaSeries<SalesData, num>>[
  ///                RangeAreaSeries<SalesData, num>(
  ///                  borderDrawMode: RangeAreaBorderMode.all,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final RangeAreaBorderMode borderDrawMode;

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => RangeAreaSegment();

  /// Creates a collection of segments for the points in the series.
  @override
  void createSegments() => _createSegment(_dataPoints);

  /// Range Area segment is created here
  void _createSegment(List<CartesianChartPoint<dynamic>> dataPoints) {
    final RangeAreaSegment segment = createSegment();
    _isRectSeries = false;
    if (segment != null) {
      segment._seriesIndex = _chart._chartSeries.visibleSeries.indexOf(this);
      segment.series = this;
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      segments.add(segment);
    }
  }

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    segment.color = segment.series._seriesColor;
    segment.strokeColor = segment.series.borderColor;
    segment.strokeWidth = segment.series.borderWidth;
  }

  /// Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY) {
    canvas.drawPath(_markerShapes[index], strokePaint);
    canvas.drawPath(_markerShapes[index], fillPaint);
    canvas.drawPath(_markerShapes2[index], strokePaint);
    canvas.drawPath(_markerShapes2[index], fillPaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, ChartTextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
