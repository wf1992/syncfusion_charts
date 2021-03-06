part of charts;

/// Renders the 100% stacked line series.
///
/// A stacked 100 line chart is a line chart in which lines do not overlap because they are cumulative at each point.
/// In the stacked 100 line chart, the lines reach a total of 100% of the axis range at each point
///
/// To render a 100% stacked line chart, create an instance of StackedLine100Series, and add it to the series collection property of [SfCartesianChart].
///  Provides options to customise color,opacity and width  of the StackedLine100 segments.
class StackedLine100Series<T, D> extends _StackedSeriesBase<T, D> {
  StackedLine100Series(
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
      bool isVisible,
      String name,
      bool enableTooltip,
      List<double> dashArray,
      double animationDuration,
      List<Trendline> trendlines,
      String groupName,
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
            trendlines: trendlines,
            gradient: gradient,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
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
            groupName: groupName,
            opacity: opacity,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => StackedLine100Segment();

  /// Creates a collection of segments for the points in the series.
  @override
  void createSegments() {
    List<num> values = <num>[];
    int segmentIndex = 0;
    for (int i = 0; i < _dataPoints.length; i++) {
      if (_dataPoints.length > 1) {
        if (values != null && values.isNotEmpty && values.length > 3) {
          values[0] = values[3];
          values[1] = values[4];
          values[2] = values[5];
          values.removeRange(3, 6);
        }
        if (_dataPoints[i].isVisible) {
          if (_dataPoints[i].isGap != true) {
            if (values.isEmpty ||
                (values.isNotEmpty &&
                    !(values[0] == _dataPoints[i].xValue &&
                        values[1] == _dataPoints[i].yValue))) {
              values.add(_dataPoints[i].xValue);
              values.add(_dataPoints[i].yValue);
              values.add(_dataPoints[i].cumulativeValue);
            }
          }
          if ((i == 0 || _dataPoints[i - 1].isGap == true) &&
              _dataPoints[i].isGap != true &&
              i != _dataPoints.length - 1 &&
              _dataPoints[i + 1].isGap != true &&
              _dataPoints[i + 1].isVisible) {
            values.add(_dataPoints[i + 1].xValue);
            values.add(_dataPoints[i + 1].yValue);
            values.add(_dataPoints[i + 1].cumulativeValue);
          } else if (_dataPoints[i].isGap == true) {
            values = <num>[];
          }
        }
      }

      if (values != null && values.isNotEmpty && values.length > 3) {
        _createSegment(values, _dataPoints[i], segmentIndex,
            _dataPoints[segmentIndex].pointColorMapper);
        segmentIndex++;
      }
    }
  }

  /// Line segment is created here
  void _createSegment(
      List<num> values,
      CartesianChartPoint<dynamic> currentPoint,
      int segmentIndex,
      Color pointColorMapper) {
    final StackedLine100Segment segment = createSegment();
    _isRectSeries = false;
    if (segment != null) {
      segment.currentSegmentIndex = segmentIndex;
      segment._seriesIndex = _chart._chartSeries.visibleSeries.indexOf(this);
      segment.series = this;
      segment._currentPoint = currentPoint;
      if (_chart._chartState.widgetNeedUpdate &&
          _xAxis._zoomFactor == 1 &&
          _yAxis._zoomFactor == 1 &&
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
      segment._pointColorMapper = pointColorMapper;
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
    segment.color = segment.series._seriesColor;
    segment.strokeColor = segment.series._seriesColor;
    segment.strokeWidth = segment.series.width;
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY) {
    canvas.drawPath(_markerShapes[index], strokePaint);
    canvas.drawPath(_markerShapes[index], fillPaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, ChartTextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
