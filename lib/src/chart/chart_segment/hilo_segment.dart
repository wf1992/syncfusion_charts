part of charts;

/// Creates the segments for Hilo series.
///
/// Generates the Hilo series points and has the [calculateSegmentPoints] method overrided to customize
/// the Hilo segment point calculation.
///
/// Gets the path and color from the [series].
class HiloSegment extends ChartSegment {
  /// Current point X value
  num x;

  /// Low value
  num low;

  /// High value
  num high;

  /// Position of x
  num xPos;

  /// Low position
  num lowPos;

  /// High position
  num highPos;

  /// Center of x
  num centerX;

  /// High value of x
  num highX;

  /// Low value of x
  num lowX;

  /// Center of y
  num centerY;

  /// High value of y
  num highY;

  /// Low value of y
  num lowY;

  /// Start position
  num startPos;

  /// End position
  num endPos;
  Color _pointColorMapper;

  /// Stores low point location
  _ChartLocation lowPoint;

  /// High point location
  _ChartLocation highPoint;

  /// Render path.
  Path path;

  bool _showSameValue;

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
    x = high = low = double.nan;
    final Rect rect = _calculatePlotOffset(
        series._chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    if (xPos != null && high != null && lowPos != null) {
      lowPoint = _calculatePoint(xPos, lowPos, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);
      highPoint = _calculatePoint(xPos, highPos, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);

      final bool isTransposed = series._chart._requireInvertedAxis;

      x = lowPoint.x;
      low = lowPoint.y;
      high = highPoint.y;
      _showSameValue = !isTransposed ? low == high : lowPoint.x == highPoint.x;
      x = lowPoint.x =
          (_showSameValue && isTransposed) ? lowPoint.x - 2 : lowPoint.x;
      highPoint.x =
          (_showSameValue && isTransposed) ? highPoint.x + 2 : highPoint.x;
      low = lowPoint.y =
          (_showSameValue && !isTransposed) ? lowPoint.y - 2 : lowPoint.y;
      high = highPoint.y =
          (_showSameValue && !isTransposed) ? highPoint.y + 2 : highPoint.y;
    }
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);
    if (series.animationDuration > 0 &&
        !series._chart._chartState._isLegendToggled) {
      if (!series._chart._chartState.widgetNeedUpdate) {
        if (series._chart._requireInvertedAxis) {
          lowX = lowPoint.x;
          highX = highPoint.x;
          centerX = highX + ((lowX - highX) / 2);
          highX = centerX + ((centerX - highX).abs() * animationFactor);
          lowX = centerX - ((lowX - centerX).abs() * animationFactor);
          canvas.drawLine(Offset(lowX, lowPoint.y), Offset(highX, highPoint.y),
              strokePaint);
        } else {
          centerY = high + ((low - high) / 2);
          highY = centerY - ((centerY - high) * animationFactor);
          lowY = centerY + ((low - centerY) * animationFactor);
          canvas.drawLine(Offset(lowPoint.x, highY), Offset(highPoint.x, lowY),
              strokePaint);
        }
      } else {
        final HiloSegment currentSegment = series.segments[currentSegmentIndex];
        final HiloSegment oldSegment =
            (currentSegment.oldSeries.segments.isNotEmpty &&
                    currentSegment.oldSeries.segments[0] is HiloSegment &&
                    currentSegment.oldSeries.segments.length - 1 >=
                        currentSegmentIndex)
                ? currentSegment.oldSeries.segments[currentSegmentIndex]
                : null;
        _animateHiloSeries(
            series._chart._requireInvertedAxis,
            lowPoint,
            highPoint,
            oldSegment?.lowPoint,
            oldSegment?.highPoint,
            animationFactor,
            strokePaint,
            canvas);
      }
    } else {
      if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
        path = Path();
        path.moveTo(lowPoint.x, high);
        path.lineTo(highPoint.x, low);
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      } else {
        canvas.drawLine(
            Offset(lowPoint.x, high), Offset(highPoint.x, low), strokePaint);
      }
    }
  }

  /// Method to set data.
  void _setData(List<num> values) {
    xPos = values[0].toDouble();
    lowPos = values[1].toDouble();
    highPos = values[2].toDouble();
  }
}
