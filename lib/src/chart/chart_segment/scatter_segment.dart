part of charts;

/// Creates the segments for scatter series.
///
/// Generates the scatter series points and has the [calculateSegmentPoints] method overrided to customize
/// the scatter segment point calculation.
///
/// Gets the path and color from the [series].
class ScatterSegment extends ChartSegment {
  ///X position of the scatter
  num centerX;

  ///Y position of the scatter
  num centerY;

  ///Radius of the scatter
  num radius;

  ///X value of the scatter
  num xData;

  ///Y value of the scatter
  num yData;

  ///Size of the scatter
  num size;
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
    _defaultFillColor = fillPaint;
    if (fillPaint.color != null)
      fillPaint.color =
          (series.opacity < 1 && fillPaint.color != Colors.transparent)
              ? fillPaint.color.withOpacity(series.opacity)
              : fillPaint.color;
    return fillPaint;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final ScatterSeries<dynamic, dynamic> _series = series;
    final Paint strokePaint = Paint()
      ..color = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderColor
          : series.markerSettings.isVisible
              ? series.markerSettings.borderColor ?? series._seriesColor
              : strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : strokeWidth;
    (series.borderWidth == 0 && !_series._isLineType)
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);
    if (fillPaint != null) {
      series.animationDuration > 0 &&
              !series._chart._chartState._isLegendToggled
          ? _animateScatterSeries(series, _point, _oldPoint, animationFactor,
              canvas, fillPaint, strokePaint)
          : series.drawDataMarker(currentSegmentIndex, canvas, fillPaint,
              strokePaint, _point.markerPoint.x, _point.markerPoint.y);
    }
  }
}
