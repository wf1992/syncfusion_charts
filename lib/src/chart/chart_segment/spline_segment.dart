part of charts;

/// Creates the segments for spline series.
///
/// Generates the spline series points and has the [calculateSegmentPoints] method overrided to customize
/// the spline segment point calculation.
///
/// Gets the path and color from the [series].
class SplineSegment extends ChartSegment {
  /// Point x1
  num x1;

  /// Point y1
  num y1;

  /// Point x2
  num x2;

  /// Point y2
  num y2;

  /// Position of x1
  num _x1Pos;

  /// Position of y1
  num _y1Pos;

  /// Position of x2
  num _x2Pos;

  ///Position of y2
  num _y2Pos;

  /// Start point X value
  double startControlX;

  /// Start point Y value
  double startControlY;

  /// End point X value
  double endControlX;

  /// End point Y value
  double endControlY;
  CartesianChartPoint<dynamic> _currentPoint;
  CartesianChartPoint<dynamic> _nextPoint;
  Color _pointColorMapper;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (strokeColor != null) {
      fillPaint.color = strokeColor.withOpacity(series.opacity);
    }
    fillPaint.strokeWidth = strokeWidth;
    fillPaint.style = PaintingStyle.stroke;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (series.gradient == null) {
      if (strokeColor != null) {
        strokePaint.color =
            _pointColorMapper ?? strokeColor.withOpacity(series.opacity);
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
    x1 = _x1Pos;
    y1 = _y1Pos;
    x2 = _x2Pos;
    y2 = _y2Pos;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final Rect rect = _calculatePlotOffset(
        series._chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);

    /// Draw spline series
    if (series.animationDuration > 0 &&
        series._chart._chartState.widgetNeedUpdate &&
        !series._chart._chartState._isLegendToggled &&
        series._chart._chartState.prevWidgetSeries != null &&
        series._chart._chartState.prevWidgetSeries.isNotEmpty &&
        oldSeries != null &&
        oldSeries.segments.isNotEmpty &&
        oldSeries.segments[0] is SplineSegment &&
        series._chart._chartState.prevWidgetSeries.length - 1 >=
            series.segments[currentSegmentIndex]._seriesIndex &&
        series.segments[currentSegmentIndex].oldSeries.segments.isNotEmpty &&
        _currentPoint.isGap != true &&
        _nextPoint.isGap != true) {
      final SplineSegment currentSegment = series.segments[currentSegmentIndex];
      final SplineSegment oldSegment =
          (currentSegment.oldSeries.segments.length - 1 >= currentSegmentIndex)
              ? currentSegment.oldSeries.segments[currentSegmentIndex]
              : null;
      num oldX1, oldY1, oldX2, oldY2, oldX3, oldY3, oldX4, oldY4;
      oldX1 = oldSegment?.x1;
      oldY1 = oldSegment?.y1;
      oldX2 = oldSegment?.x2;
      oldY2 = oldSegment?.y2;
      oldX3 = oldSegment?.startControlX;
      oldY3 = oldSegment?.startControlY;
      oldX4 = oldSegment?.endControlX;
      oldY4 = oldSegment?.endControlY;

      if (oldSegment != null &&
          (oldX1.isNaN || oldX2.isNaN) &&
          series._chart._chartState.oldAxes != null) {
        ChartAxis oldXAxis, oldYAxis;
        bool needAnimate;
        _ChartLocation oldPoint;
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
          oldPoint = _calculatePoint(_x1Pos, _y1Pos, oldXAxis, oldYAxis,
              series._chart._requireInvertedAxis, series, rect);
          oldX1 = oldPoint.x;
          oldY1 = oldPoint.y;
          oldPoint = _calculatePoint(_x2Pos, _y2Pos, oldXAxis, oldYAxis,
              series._chart._requireInvertedAxis, series, rect);
          oldX2 = oldPoint.x;
          oldY2 = oldPoint.y;
          oldPoint = _calculatePoint(startControlX, startControlY, oldXAxis,
              oldYAxis, series._chart._requireInvertedAxis, series, rect);
          oldX3 = oldPoint.x;
          oldY3 = oldPoint.y;
          oldPoint = _calculatePoint(endControlX, endControlY, oldXAxis,
              oldYAxis, series._chart._requireInvertedAxis, series, rect);
          oldX4 = oldPoint.x;
          oldY4 = oldPoint.y;
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
        currentSegment?.startControlX,
        currentSegment?.startControlY,
        oldX3,
        oldY3,
        currentSegment.endControlX,
        currentSegment.endControlY,
        oldX4,
        oldY4,
      );
    } else {
      final Path path = Path();
      path.moveTo(x1, y1);
      if (_currentPoint.isGap != true && _nextPoint.isGap != true) {
        path.cubicTo(
            startControlX, startControlY, endControlX, endControlY, x2, y2);
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      }
    }
  }

  /// Method to set data.
  void _setData(List<num> values) {
    _x1Pos = values[0];
    _y1Pos = values[1];
    _x2Pos = values[2];
    _y2Pos = values[3];
    startControlX = values[4];
    startControlY = values[5];
    endControlX = values[6];
    endControlY = values[7];
  }
}
