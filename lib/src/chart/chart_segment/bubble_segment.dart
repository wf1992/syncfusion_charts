part of charts;

/// Creates the segments for bubble series.
///
/// Generates the bubble series points and has the [calculateSegmentPoints] override method
/// used to customize the bubble series segment point calculation.
///
/// Gets the path, stroke color and fill color from the [series] to render the bubble series.
///

class BubbleSegment extends ChartSegment {
  ///Center X position of the bubble
  num centerX;

  ///Center Y position of the bubble
  num centerY;

  ///Radius of the bubble
  num radius;

  ///X value of the bubble
  num xData;

  ///Y value of the bubble
  num yData;

  ///Size of the bubble
  num size;

  ///Bubble series.
  XyDataSeries<dynamic, dynamic> series;

  CartesianChartPoint<dynamic> _currentPoint;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final bool hasPointColor = series.pointColorMapper != null ? true : false;
    if (series.gradient == null) {
      if (color != null) {
        fillPaint = Paint()
          ..color = _currentPoint.isEmpty == true
              ? series.emptyPointSettings.color
              : ((hasPointColor && _currentPoint.pointColorMapper != null)
                  ? _currentPoint.pointColorMapper
                  : color)
          ..style = PaintingStyle.fill;
      }
    } else {
      fillPaint = _getLinearGradientPaint(series.gradient, _currentPoint.region,
          series._chart._requireInvertedAxis);
    }
    if (fillPaint.color != null)
      fillPaint.color =
          (series.opacity < 1 && fillPaint.color != Colors.transparent)
              ? fillPaint.color.withOpacity(series.opacity)
              : fillPaint.color;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint()
      ..color = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderColor
          : strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : strokeWidth;
    series.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    centerX = centerY = double.nan;
    final Rect rect = _calculatePlotOffset(
        series._chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    final _ChartLocation localtion = _calculatePoint(
        _currentPoint.xValue,
        _currentPoint.yValue,
        series._xAxis,
        series._yAxis,
        series._chart._requireInvertedAxis,
        series,
        rect);
    centerX = localtion.x;
    centerY = localtion.y;
    radius = calculateBubbleRadius();
    _currentPoint.region = Rect.fromLTRB(
        localtion.x - 2 * radius,
        localtion.y - 2 * radius,
        localtion.x + 2 * radius,
        localtion.y + 2 * radius);
    size = radius = _currentPoint.region.width / 2;
  }

  num calculateBubbleRadius() {
    final BubbleSeries<dynamic, dynamic> bubbleSeries = series;
    num bubbleRadius, sizeRange, radiusRange, maxSize, minSize;
    maxSize = bubbleSeries._maxSize;
    minSize = bubbleSeries._minSize;
    sizeRange = maxSize - minSize;
    final num bubbleSize = ((_currentPoint.bubbleSize) ?? 4).toDouble();
    if (bubbleSeries.sizeValueMapper == null)
      bubbleSeries.minimumRadius != null
          ? bubbleRadius = bubbleSeries.minimumRadius
          : bubbleRadius = bubbleSeries.maximumRadius;
    else {
      if ((bubbleSeries.maximumRadius != null) &&
          (bubbleSeries.minimumRadius != null)) {
        if (sizeRange == 0)
          bubbleRadius = bubbleSeries.maximumRadius;
        else {
          radiusRange =
              (bubbleSeries.maximumRadius - bubbleSeries.minimumRadius) * 2;
          bubbleRadius =
              (((bubbleSize.abs() - minSize) * radiusRange) / sizeRange) +
                  bubbleSeries.minimumRadius;
        }
      }
    }
    return bubbleRadius;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);
    segmentRect = RRect.fromRectAndRadius(_currentPoint.region, Radius.zero);
    if (series._chart._chartState.widgetNeedUpdate &&
        !series._chart._chartState._isLegendToggled &&
        series._chart._chartState.prevWidgetSeries != null &&
        series._chart._chartState.prevWidgetSeries.isNotEmpty &&
        oldSeries != null &&
        oldSeries.segments.isNotEmpty &&
        oldSeries.segments[0] is BubbleSegment &&
        series.animationDuration > 0 &&
        _oldPoint != null) {
      final BubbleSegment currentSegment = series.segments[currentSegmentIndex];
      final BubbleSegment oldSegment =
          (currentSegment.oldSeries.segments.length - 1 >= currentSegmentIndex)
              ? currentSegment.oldSeries.segments[currentSegmentIndex]
              : null;
      _animateBubbleSeries(
          canvas,
          centerX,
          centerY,
          oldSegment?.centerX,
          oldSegment?.centerY,
          oldSegment?.size,
          animationFactor,
          radius,
          strokePaint,
          fillPaint,
          series._chart.isTransposed);
    } else {
      canvas.drawCircle(
          Offset(centerX, centerY), radius * animationFactor, fillPaint);
      canvas.drawCircle(
          Offset(centerX, centerY), radius * animationFactor, strokePaint);
    }
  }
}
