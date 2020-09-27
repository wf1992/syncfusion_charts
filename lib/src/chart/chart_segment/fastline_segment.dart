part of charts;

/// Creates the segments for fast line series.
///
/// This generates the fast line series points and has the [calculateSegmentPoints] method overrided to customize
/// the fast line segment point calculation.
///
/// Gets the path and color from the [series].
class FastLineSegment extends ChartSegment {
  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (color != null) {
      fillPaint.color = color.withOpacity(series.opacity);
    }
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
        strokePaint.color =
            (series.opacity < 1 && strokeColor != Colors.transparent)
                ? strokeColor.withOpacity(series.opacity)
                : strokeColor;
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

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    series.selectionSettings._selectionRenderer
        ._checkWithSelectionState(series.segments[0], series._chart);
    series.dashArray != null
        ? _drawDashedLine(
            canvas, series.dashArray, strokePaint, series.segmentPath)
        : canvas.drawPath(series.segmentPath, strokePaint);
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}
}
