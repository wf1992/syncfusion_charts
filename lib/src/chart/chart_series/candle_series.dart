part of charts;

/// This class holds the properties of the candle series.
///
/// To render a candle chart, create an instance of [CandleSeries], and add it to the [series] collection property of [SfCartesianChart].
/// The candle chart represents the hollow rectangle with the open, close, high and low value in the given data.
///
///  It has the [bearColor] and [bullColor] properties to change the appearance of the candle series.
///
/// Provides options for color, opacity, border color, and border width
/// to customize the appearance.
///
class CandleSeries<T, D> extends _FinancialSeriesBase<T, D> {
  CandleSeries({
    @required List<T> dataSource,
    @required ChartValueMapper<T, D> xValueMapper,
    @required ChartValueMapper<T, num> lowValueMapper,
    @required ChartValueMapper<T, num> highValueMapper,
    @required ChartValueMapper<T, num> openValueMapper,
    @required ChartValueMapper<T, num> closeValueMapper,
    ChartValueMapper<T, dynamic> sortFieldValueMapper,
    ChartValueMapper<T, Color> pointColorMapper,
    ChartValueMapper<T, String> dataLabelMapper,
    SortingOrder sortingOrder,
    String xAxisName,
    String yAxisName,
    String name,
    Color bearColor,
    Color bullColor,
    bool enableSolidCandles,
    EmptyPointSettings emptyPointSettings,
    DataLabelSettings dataLabelSettings,
    bool isVisible,
    LinearGradient gradient,
    bool enableTooltip,
    double animationDuration,
    // Color borderColor,
    double borderWidth,
    SelectionSettings selectionSettings,
    bool isVisibleInLegend,
    LegendIconType legendIconType,
    String legendItemText,
    List<double> dashArray,
    double opacity,
    List<int> initialSelectedDataIndexes,
    List<Trendline> trendlines,
  }) : super(
            name: name,
            dashArray: dashArray,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            openValueMapper: openValueMapper != null
                ? (int index) => openValueMapper(dataSource[index], index)
                : null,
            closeValueMapper: closeValueMapper != null
                ? (int index) => closeValueMapper(dataSource[index], index)
                : null,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderWidth: borderWidth ?? 2,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            bearColor: bearColor ?? Colors.red,
            bullColor: bullColor ?? Colors.green,
            enableSolidCandles: enableSolidCandles ?? false,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            trendlines: trendlines);
  num _rectPosition;
  num _rectCount;

  @override
  ChartSegment createSegment() => CandleSegment();

  /// Creates a collection of segments for the points in the series.
  @override
  void createSegments() {
    int segmentIndex = 0;
    for (int i = 0; i < _dataPoints.length; i++) {
      if (_dataPoints[i].isVisible && _dataPoints[i].isGap != true) {
        final List<num> values = <num>[];
        values.add(_dataPoints[i].xValue);
        values.add(_dataPoints[i].low);
        values.add(_dataPoints[i].high);
        values.add(_dataPoints[i].open);
        values.add(_dataPoints[i].close);
        _createSegment(values, _dataPoints[i], segmentIndex);
        segmentIndex++;
      }
    }
  }

  /// Range column segment is created here
  void _createSegment(List<num> values,
      CartesianChartPoint<dynamic> currentPoint, int segmentIndex) {
    final CandleSegment segment = createSegment();
    if (segment != null) {
      segment._seriesIndex = _chart._chartSeries.visibleSeries.indexOf(this);
      segment.currentSegmentIndex = segmentIndex;
      segment.series = this;
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
      }
      segment._pointColorMapper = currentPoint.pointColorMapper;
      segment._setData(values);
      segment.calculateSegmentPoints();
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      segments.add(segment);
    }
  }

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    if (enableSolidCandles) {
      if (segment is CandleSegment) {
        segment.isSolid = true;
      }
      segment.color =
          segment is CandleSegment && segment.isBull ? bullColor : bearColor;
    } else {
      if (segment is CandleSegment &&
          segment.currentSegmentIndex - 1 >= 0 &&
          segment.series._dataPoints[segment.currentSegmentIndex - 1].close >
              segment.series._dataPoints[segment.currentSegmentIndex].close) {
        if (!segment.isBull) {
          segment.isSolid = true;
        }
        segment.color = bearColor;
      } else {
        if (segment is CandleSegment && !segment.isBull) {
          segment.isSolid = true;
        }
        segment.color = bullColor;
      }
    }
    // segment.strokeColor = segment.series.borderColor;
    segment.strokeWidth = segment.series.borderWidth;
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY) {}

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, ChartTextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
