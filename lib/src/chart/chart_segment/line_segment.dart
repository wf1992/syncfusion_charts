part of charts;

/// Creates the segments for line series.
///
/// Line segment is a part of a line series that is bounded by two distinct end point.
/// Generates the line series points and has the [calculateSegmentPoints] override method
/// used to customize the line series segment point calculation.
///
/// Gets the path, stroke color and fill color from the [series].
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class LineSegment extends ChartSegment {
  /// X1 value
  num x1;

  /// Y1 value
  num y1;

  /// X2 value
  num x2;

  /// Y2 value
  num y2;
  Color _pointColorMapper;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (color != null) {
      fillPaint.color = _pointColorMapper ?? color.withOpacity(series.opacity);
    }
    fillPaint.strokeWidth = strokeWidth;
    fillPaint.style = PaintingStyle.fill;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (series.gradient == null) {
      if (strokeColor != null) {
        strokePaint.color = _pointColorMapper ?? strokeColor;
        strokePaint.color =
            (series.opacity < 1 && strokePaint.color != Colors.transparent)
                ? strokePaint.color.withOpacity(series.opacity)
                : strokePaint.color;
      }
    } else {
      strokePaint.color = series.gradient.colors[0];
    }
    strokePaint.strokeWidth = strokeWidth;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final ChartAxis _xAxis = series._xAxis;
    final ChartAxis _yAxis = series._yAxis;
    final Rect axisClipRect = _calculatePlotOffset(
        chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    final _ChartLocation currentPointLocation = _calculatePoint(
        _currentPoint.xValue,
        _currentPoint.yValue,
        _xAxis,
        _yAxis,
        chart._requireInvertedAxis,
        series,
        axisClipRect);
    x1 = currentPointLocation.x;
    y1 = currentPointLocation.y;
    final _ChartLocation nextPointLocation = _calculatePoint(
        _nextPoint.xValue,
        _nextPoint.yValue,
        _xAxis,
        _yAxis,
        chart._requireInvertedAxis,
        series,
        axisClipRect);
    x2 = nextPointLocation.x;
    y2 = nextPointLocation.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final Rect rect = _calculatePlotOffset(
        series._chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);
    if (series.animationDuration > 0 &&
        oldSeries != null &&
        oldSeries.segments.isNotEmpty &&
        oldSeries.segments[0] is LineSegment &&
        series._chart._chartState.prevWidgetSeries.length - 1 >=
            series.segments[currentSegmentIndex]._seriesIndex &&
        series.segments[currentSegmentIndex].oldSeries.segments.isNotEmpty) {
      final LineSegment currentSegment = series.segments[currentSegmentIndex];
      final LineSegment oldSegment =
          (currentSegment.oldSeries.segments.length - 1 >= currentSegmentIndex)
              ? currentSegment.oldSeries.segments[currentSegmentIndex]
              : null;
      num oldX1, oldY1, oldX2, oldY2;
      oldX1 = oldSegment?.x1;
      oldY1 = oldSegment?.y1;
      oldX2 = oldSegment?.x2;
      oldY2 = oldSegment?.y2;

      if (oldSegment != null &&
          (oldX1.isNaN || oldX2.isNaN) &&
          series._chart._chartState.oldAxes != null) {
        ChartAxis oldXAxis, oldYAxis;
        bool needAnimate;
        _ChartLocation first, second;
        oldXAxis =
            _getOldAxis(series._xAxis, series._chart._chartState.oldAxes);
        oldYAxis =
            _getOldAxis(series._yAxis, series._chart._chartState.oldAxes);
        if (oldYAxis != null && oldXAxis != null) {
          needAnimate = oldYAxis._visibleRange.minimum !=
                  series._yAxis._visibleRange.minimum ||
              oldYAxis._visibleRange.maximum !=
                  series._yAxis._visibleRange.maximum ||
              oldXAxis._visibleRange.minimum !=
                  series._xAxis._visibleRange.minimum ||
              oldXAxis._visibleRange.maximum !=
                  series._xAxis._visibleRange.maximum;
        }
        if (needAnimate) {
          first = _calculatePoint(
              _currentPoint.xValue,
              _currentPoint.yValue,
              oldXAxis,
              oldYAxis,
              series._chart._requireInvertedAxis,
              series,
              rect);
          second = _calculatePoint(
              _nextPoint.xValue,
              _nextPoint.yValue,
              oldXAxis,
              oldYAxis,
              series._chart._requireInvertedAxis,
              series,
              rect);
          oldX1 = first.x;
          oldX2 = second.x;
          oldY1 = first.y;
          oldY2 = second.y;
        }
      }
      _animateLineTypeSeries(
        canvas,
        series,
        strokePaint,
        animationFactor,
        currentSegment.x1,
        currentSegment.y1,
        currentSegment.x2,
        currentSegment.y2,
        oldX1,
        oldY1,
        oldX2,
        oldY2,
      );
    } else {
      final Path path = Path();
      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
      _drawDashedLine(canvas, series.dashArray, strokePaint, path);
    }
  }
}
