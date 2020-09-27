part of charts;

/// Renders the xy series.
///
/// Cartesian charts uses two axis namely x and y, to render.
abstract class XyDataSeries<T, D> extends CartesianSeries<T, D> {
  XyDataSeries(
      {ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String name,
      @required List<T> dataSource,
      String xAxisName,
      String yAxisName,
      ChartValueMapper<T, Color> pointColorMapper,
      String legendItemText,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      LinearGradient gradient,
      ChartValueMapper<T, num> sizeValueMapper,
      ChartValueMapper<T, num> highValueMapper,
      ChartValueMapper<T, num> lowValueMapper,
      List<Trendline> trendlines,
      double width,
      MarkerSettings markerSettings,
      bool isVisible,
      bool enableTooltip,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      double animationDuration,
      List<double> dashArray,
      Color borderColor,
      double borderWidth,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      double opacity,
      List<ChartSegment> segments,
      Color color,
      List<int> initialSelectedDataIndexes,
      SortingOrder sortingOrder})
      : drawControlPoints = <_ListControlPoints>[],
        super(
            isVisible: isVisible,
            legendItemText: legendItemText,
            xAxisName: xAxisName,
            dashArray: dashArray,
            segments: segments,
            isVisibleInLegend: isVisibleInLegend,
            borderColor: borderColor,
            trendlines: trendlines,
            borderWidth: borderWidth,
            yAxisName: yAxisName,
            color: color,
            name: name,
            width: width,
            xValueMapper: (int index) => xValueMapper(dataSource[index], index),
            yValueMapper: (int index) => yValueMapper(dataSource[index], index),
            sortFieldValueMapper: sortFieldValueMapper != null
                ? (int index) => sortFieldValueMapper(dataSource[index], index)
                : null,
            pointColorMapper: pointColorMapper != null
                ? (int index) => pointColorMapper(dataSource[index], index)
                : null,
            dataLabelMapper: dataLabelMapper != null
                ? (int index) => dataLabelMapper(dataSource[index], index)
                : null,
            sizeValueMapper: sizeValueMapper != null
                ? (int index) => sizeValueMapper(dataSource[index], index)
                : null,
            highValueMapper: highValueMapper != null
                ? (int index) => highValueMapper(dataSource[index], index)
                : null,
            lowValueMapper: lowValueMapper != null
                ? (int index) => lowValueMapper(dataSource[index], index)
                : null,
            dataSource: dataSource,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            selectionSettings: selectionSettings,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            gradient: gradient,
            markerSettings: markerSettings,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Stores the series type
  String _seriesType;

  /// Holds the collection of cartesian data points
  List<CartesianChartPoint<dynamic>> _dataPoints;

  /// Whether to check the series is rect series or not
  bool _isRectSeries;

  List<_ListControlPoints> drawControlPoints;

  Path segmentPath;

  void storeSeriesProperties(SfCartesianChart chart, int index) {
    _chart = chart;
    _isRectSeries =
        _seriesType.contains('column') || _seriesType.contains('bar');
    _regionalData = <dynamic, dynamic>{};
    segmentPath = Path();
    segments = <ChartSegment>[];
    _seriesColor = color ?? chart.palette[index % chart.palette.length];
  }

  void calculateRegionData(
      SfCartesianChart chart,
      XyDataSeries<dynamic, dynamic> series,
      int seriesIndex,
      CartesianChartPoint<dynamic> point,
      int pointIndex,
      [_VisibleRange sideBySideInfo]) {
    series._chart = chart;
    final ChartAxis xAxis = series._xAxis;
    final ChartAxis yAxis = series._yAxis;
    final Rect rect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
        Offset(xAxis.plotOffset, yAxis.plotOffset));
    series._isRectSeries = series._seriesType == 'column' ||
        series._seriesType == 'bar' ||
        series._seriesType.contains('stackedcolumn') ||
        series._seriesType.contains('stackedbar') ||
        series._seriesType == 'rangecolumn';
    CartesianChartPoint<dynamic> point;
    final num markerHeight = series.markerSettings.height,
        markerWidth = series.markerSettings.width;
    final bool isPointSeries =
        series._seriesType == 'scatter' || series._seriesType == 'bubble';
    final bool isFastLine = series._seriesType == 'fastline';
    if ((!isFastLine ||
            (isFastLine &&
                (series.markerSettings.isVisible ||
                    series.dataLabelSettings.isVisible ||
                    series.enableTooltip))) &&
        series._visible) {
      point = series._dataPoints[pointIndex];
      if (series._isRectSeries) {
        _calculateRectSeriesRegion(point, pointIndex, series, chart);
      } else if (isPointSeries) {
        _calculatePointSeriesRegion(point, pointIndex, series, chart, rect);
      } else {
        _calculatePathSeriesRegion(
            point, pointIndex, series, chart, rect, markerHeight, markerWidth);
      }
      _calculateTooltipRegion(point, seriesIndex, series, chart);

      CartesianChartPoint<dynamic> trendlinePoint;
      if (series.trendlines != null) {
        for (int j = 0; j < series.trendlines.length; j++) {
          if (series.trendlines[j]._isNeedRender) {
            if (series.trendlines[j]._pointsData != null) {
              for (int k = 0;
                  k < series.trendlines[j]._pointsData.length;
                  k++) {
                trendlinePoint = series.trendlines[j]._pointsData[k];
                _calculateTooltipRegion(trendlinePoint, seriesIndex, series,
                    chart, series.trendlines[j], j);
              }
            }
          }
        }
      }
    }
  }

  void calculateTooltipRegion(SfCartesianChart chart, int seriesIndex,
      CartesianChartPoint<dynamic> point, int pointIndex) {
    /// For tooltip implementation
    if (enableTooltip != null &&
        enableTooltip &&
        point != null &&
        !point.isGap &&
        !point.isDrop) {
      final List<String> regionData = <String>[];
      String date;
      final List<dynamic> regionRect = <dynamic>[];
      final dynamic primaryAxis = _xAxis;
      if (primaryAxis is DateTimeAxis) {
        final DateFormat dateFormat =
            primaryAxis.dateFormat ?? primaryAxis._getLabelFormat(_xAxis);
        date = dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(point.xValue));
      }
      _xAxis is CategoryAxis
          ? regionData.add(point.x.toString())
          : _xAxis is DateTimeAxis
              ? regionData.add(date.toString())
              : regionData.add(_getLabelValue(
                      point.xValue, _xAxis, chart.tooltipBehavior.decimalPlaces)
                  .toString());
      if (_seriesType.contains('range')) {
        regionData.add(_getLabelValue(
                point.high, _yAxis, chart.tooltipBehavior.decimalPlaces)
            .toString());
        regionData.add(_getLabelValue(
                point.low, _yAxis, chart.tooltipBehavior.decimalPlaces)
            .toString());
      } else {
        regionData.add(_getLabelValue(
                point.yValue, _yAxis, chart.tooltipBehavior.decimalPlaces)
            .toString());
      }
      regionData.add(name ?? 'series $seriesIndex');
      regionRect.add(point.region);
      regionRect.add(_isRectSeries
          ? _seriesType == 'column' || _seriesType.contains('stackedcolumn')
              ? point.yValue > 0
                  ? point.region.topCenter
                  : point.region.bottomCenter
              : point.region.topCenter
          : (_seriesType == 'rangearea'
              ? Offset(point.markerPoint.x,
                  (point.markerPoint.y + point.markerPoint2.y) / 2)
              : point.region.center));
      regionRect.add(point.pointColorMapper);
      regionRect.add(point.bubbleSize);
      if (_seriesType.contains('stacked')) {
        regionData.add((point.cumulativeValue).toString());
      }
      _regionalData[regionRect] = regionData;
    }
  }

  @override
  void calculateEmptyPointValue(
      int pointIndex, CartesianChartPoint<dynamic> currentPoint) {
    final int pointLength = _dataPoints.length - 1;
    final CartesianChartPoint<dynamic> prevPoint =
        _dataPoints[_dataPoints.length >= 2 ? pointLength - 1 : pointLength];
    if (_seriesType.contains('range') ||
            _seriesType.contains('hilo') ||
            _seriesType == 'candle'
        ? _seriesType == 'hiloopenclose' || _seriesType == 'candle'
            ? (currentPoint.low == null ||
                currentPoint.high == null ||
                currentPoint.open == null ||
                currentPoint.close == null)
            : (currentPoint.low == null || currentPoint.high == null)
        : currentPoint.y == null) {
      switch (emptyPointSettings.mode) {
        case EmptyPointMode.zero:
          currentPoint.isEmpty = true;
          if (_seriesType.contains('range') ||
              _seriesType.contains('hilo') ||
              _seriesType.contains('candle')) {
            currentPoint.high = 0;
            currentPoint.low = 0;
            if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
              currentPoint.open = 0;
              currentPoint.close = 0;
            }
          } else
            currentPoint.y = 0;
          break;

        case EmptyPointMode.average:
          _calculateAverageModeValue(
              pointIndex, pointLength, currentPoint, prevPoint);
          currentPoint.isEmpty = true;
          break;

        case EmptyPointMode.gap:
          if (_seriesType == 'scatter' ||
              _seriesType == 'column' ||
              _seriesType == 'bar' ||
              _seriesType == 'bubble' ||
              _seriesType == 'splinearea' ||
              _seriesType.contains('stacked') ||
              _seriesType == 'rangecolumn' ||
              _seriesType.contains('hilo') ||
              _seriesType.contains('candle') ||
              _seriesType == 'rangearea') {
            currentPoint.y = pointIndex != 0 &&
                    (!_seriesType.contains('stackedcolumn') &&
                        !_seriesType.contains('stackedbar'))
                ? prevPoint.y
                : 0;
            currentPoint.open = 0;
            currentPoint.close = 0;
            currentPoint.isVisible = false;
          } else if (_seriesType.contains('line') ||
              _seriesType == 'area' ||
              _seriesType == 'steparea') {
            currentPoint.y = pointIndex != 0 ? prevPoint.y : 0;
          }
          currentPoint.isGap = true;
          break;
        case EmptyPointMode.drop:
          currentPoint.y = pointIndex != 0 &&
                  (_seriesType != 'area' &&
                      _seriesType != 'splinearea' &&
                      _seriesType != 'steparea' &&
                      !_seriesType.contains('stackedcolumn') &&
                      !_seriesType.contains('stackedbar'))
              ? prevPoint.y
              : 0;
          currentPoint.isDrop = true;
          currentPoint.isVisible = false;
          break;
        default:
          currentPoint.y = 0;
          break;
      }
    }
  }

  void _calculateAverageModeValue(
      int pointIndex,
      int pointLength,
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> prevPoint) {
    final CartesianChartPoint<dynamic> nextPoint = _getPointFromData(
        this,
        pointLength < dataSource.length - 1
            ? dataSource.indexOf(dataSource[pointLength + 1])
            : dataSource.indexOf(dataSource[pointLength]));
    if (_seriesType.contains('range') ||
        _seriesType.contains('hilo') ||
        _seriesType.contains('candle')) {
      if (pointIndex == 0) {
        if (currentPoint.low == null) {
          pointIndex == dataSource.length - 1
              ? currentPoint.low = 0
              : currentPoint.low = ((nextPoint.low) ?? 0) / 2;
        }
        if (currentPoint.high == null) {
          pointIndex == dataSource.length - 1
              ? currentPoint.high = 0
              : currentPoint.high = ((nextPoint.high) ?? 0) / 2;
        }
        if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
          if (currentPoint.open == null) {
            pointIndex == dataSource.length - 1
                ? currentPoint.open = 0
                : currentPoint.open = ((nextPoint.open) ?? 0) / 2;
          }
          if (currentPoint.close == null) {
            pointIndex == dataSource.length - 1
                ? currentPoint.close = 0
                : currentPoint.close = ((nextPoint.close) ?? 0) / 2;
          }
        }
      } else if (pointIndex == dataSource.length - 1) {
        currentPoint.low = currentPoint.low == null
            ? ((prevPoint.low) ?? 0) / 2
            : currentPoint.low;
        currentPoint.high = currentPoint.high == null
            ? ((prevPoint.high) ?? 0) / 2
            : currentPoint.high;

        if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
          currentPoint.open = currentPoint.open == null
              ? ((prevPoint.open) ?? 0) / 2
              : currentPoint.open;
          currentPoint.close = currentPoint.close == null
              ? ((prevPoint.close) ?? 0) / 2
              : currentPoint.close;
        }
      } else {
        currentPoint.low = currentPoint.low == null
            ? (((prevPoint.low) ?? 0) + ((nextPoint.low) ?? 0)) / 2
            : currentPoint.low;
        currentPoint.high = currentPoint.high == null
            ? (((prevPoint.high) ?? 0) + ((nextPoint.high) ?? 0)) / 2
            : currentPoint.high;

        if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
          currentPoint.open = currentPoint.open == null
              ? (((prevPoint.open) ?? 0) + ((nextPoint.open) ?? 0)) / 2
              : currentPoint.open;
          currentPoint.close = currentPoint.close == null
              ? (((prevPoint.close) ?? 0) + ((nextPoint.close) ?? 0)) / 2
              : currentPoint.close;
        }
      }
    } else {
      if (pointIndex == 0) {
        ///Check the first point is null
        pointIndex == dataSource.length - 1
            ?

            ///Check the series contains single point with null value
            currentPoint.y = 0
            : currentPoint.y = ((nextPoint.y) ?? 0) / 2;
      } else if (pointIndex == dataSource.length - 1) {
        ///Check the last point is null
        currentPoint.y = ((prevPoint.y) ?? 0) / 2;
      } else {
        currentPoint.y = (((prevPoint.y) ?? 0) + ((nextPoint.y) ?? 0)) / 2;
      }
    }
  }
}

/// Returns the widget.
typedef ChartDataLabelTemplateBuilder<T> = Widget Function(
    T data, CartesianChartPoint<dynamic> point, int pointIndex,
    {int seriesIndex, CartesianSeries<dynamic, dynamic> series});

/// This class has the properties of CartesianChartPoint.
///
/// Chart point is a class that is used to store the current x and y values from the datasource.
/// Contains x and y coordinates which are converted from the x and y values.
///
class CartesianChartPoint<D> {
  CartesianChartPoint(
      [this.x,
      this.y,
      this.dataLabelMapper,
      this.pointColorMapper,
      this.bubbleSize,
      this.high,
      this.low,
      this.open,
      this.close,
      this.volume]) {
    x = x;
    y = y;
    sortValue = sortValue;
    markerPoint = markerPoint;
    isEmpty = isEmpty;
    isGap = isGap;
    isVisible = isVisible;
    bubbleSize = bubbleSize;
    pointColorMapper = pointColorMapper;
    dataLabelMapper = dataLabelMapper;
    high = high;
    low = low;
    open = open;
    close = close;
    markerPoint2 = markerPoint2;
    volume = volume;
  }

  /// X value of the point.
  D x;

  /// Y value of the point
  D y;

  /// Stores the xValues of the point
  D xValue;

  /// Stores the yValues of the Point
  D yValue;

  /// Sort value of the point.
  D sortValue;

  /// High value of the point.
  D high;

  /// Low value of the point.
  D low;

  /// Open value of the point.
  D open;

  /// Close value of the point
  D close;

  /// Volume value of the point
  num volume;

  /// Marker point location.
  _ChartLocation markerPoint;

  /// second Marker point location.
  _ChartLocation markerPoint2;

  /// Size of the bubble.
  double bubbleSize;

  /// To set empty value
  bool isEmpty;

  /// To set gap value
  bool isGap = false;

  /// To set the drop value
  bool isDrop = false;

  /// Set the visibility of the series.
  bool isVisible = true;

  /// Used to map the color value from data point.
  Color pointColorMapper;

  /// Map the datalabel value from data point.
  String dataLabelMapper;

  /// Store the region.
  Rect region;

  /// Stores the chart location.
  _ChartLocation openPoint, closePoint, centerOpenPoint, centerClosePoint;

  /// Store the visible range.
  _VisibleRange sideBySideInfo;

  /// Store the List of region.
  List<Rect> regions;

  /// store the cumulative value.
  double cumulativeValue;

  /// Stores the tracker rect region
  Rect trackerRectRegion;

  /// Stores the forth data label text
  String label;

  /// Stores the forth data label text
  String label2;

  /// Stores the forth data label text
  String label3;

  /// Stores the forth data label text
  String label4;

  /// Stores the forth data label Rect
  RRect labelFillRect;

  /// Stores the forth data label Rect
  RRect labelFillRect2;

  /// Stores the forth data label Rect
  RRect labelFillRect3;

  /// Stores the forth data label Rect
  RRect labelFillRect4;

  /// Stores the data label location
  _ChartLocation labelLocation;

  /// Stores the second data label location
  _ChartLocation labelLocation2;

  /// Stores the third data label location
  _ChartLocation labelLocation3;

  /// Stores the forth data label location
  _ChartLocation labelLocation4;

  /// Data label region saturation.
  bool dataLabelSaturationRegionInside = false;

  /// Stores the data label region
  Rect dataLabelRegion;

  /// Stores the second data label region
  Rect dataLabelRegion2;

  /// Stores the third data label region
  Rect dataLabelRegion3;

  /// Stores the forth data label region
  Rect dataLabelRegion4;

  /// Stores the data point index
  int index;

  /// Store the region data of the data point.
  List<String> regionData;
}

class _ChartLocation {
  _ChartLocation(this.x, this.y);
  num x;
  num y;
}

/// To calculate dash array path for series
Path _dashPath(
  Path source, {
  @required _CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double intialValue = 0.0;
  final Path path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double distance = intialValue;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray.next;
      if (draw) {
        path.addPath(
            measurePath.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      draw = !draw;
    }
  }
  return path;
}

/// A circular array for dash offsets and lengths.
class _CircularIntervalList<T> {
  _CircularIntervalList(this._values);
  final List<T> _values;
  int _index = 0;
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}
