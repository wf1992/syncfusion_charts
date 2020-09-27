part of charts;

/// Creates the segments for bar series.
///
/// This generates the bar series points and has the [calculateSegmentPoints] override method
/// used to customize the bar series segment point calculation.
///
/// It gets the path, stroke color and fill color from the [series] to render the bar segment.
///
class BarSegment extends ChartSegment {
  /// X1 value
  num x1;

  /// Y1 value
  num y1;

  /// X2 value
  num x2;

  /// Y2 value
  num y2;
  RRect _trackBarRect;
  CartesianChartPoint<dynamic> _currentPoint;
  Paint _trackerFillPaint;
  Paint _trackerStrokePaint;

  ///Path to render.
  Path path;

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
    strokePaint = Paint()
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
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    final BarSeries<dynamic, dynamic> barSeries = series;
    if (color != null) {
      _trackerFillPaint = Paint()
        ..color = barSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final BarSeries<dynamic, dynamic> barSeries = series;
    _trackerStrokePaint = Paint()
      ..color = barSeries.trackBorderColor
      ..strokeWidth = barSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    barSeries.trackBorderWidth == 0
        ? _trackerStrokePaint.color = Colors.transparent
        : _trackerStrokePaint.color;
    return _trackerStrokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final BarSeries<dynamic, dynamic> barSeries = series;
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);
    if (_trackerFillPaint != null && barSeries.isTrackVisible) {
      series.animationDuration > 0
          ? _animateRectSeries(
              canvas,
              series,
              _trackerFillPaint,
              _trackBarRect,
              _currentPoint.yValue,
              animationFactor,
              _oldPoint != null ? _oldPoint.region : _oldRegion,
              _oldPoint?.yValue,
              _oldSeriesVisible)
          : canvas.drawRRect(_trackBarRect, _trackerFillPaint);
    }
    if (_trackerStrokePaint != null && barSeries.isTrackVisible) {
      series.animationDuration > 0
          ? _animateRectSeries(
              canvas,
              series,
              _trackerStrokePaint,
              _trackBarRect,
              _currentPoint.yValue,
              animationFactor,
              _oldPoint != null ? _oldPoint.region : _oldRegion,
              _oldPoint?.yValue,
              _oldSeriesVisible)
          : canvas.drawRRect(_trackBarRect, _trackerStrokePaint);
    }

    if (fillPaint != null) {
      series.animationDuration > 0
          ? _animateRectSeries(
              canvas,
              series,
              fillPaint,
              segmentRect,
              _currentPoint.yValue,
              animationFactor,
              _oldPoint != null ? _oldPoint.region : _oldRegion,
              _oldPoint?.yValue,
              _oldSeriesVisible)
          : canvas.drawRRect(segmentRect, fillPaint);
    }
    if (strokePaint != null) {
      if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      } else {
        series.animationDuration > 0
            ? _animateRectSeries(
                canvas,
                series,
                strokePaint,
                segmentRect,
                _currentPoint.yValue,
                animationFactor,
                _oldPoint != null ? _oldPoint.region : _oldRegion,
                _oldPoint?.yValue,
                _oldSeriesVisible)
            : canvas.drawRRect(segmentRect, strokePaint);
      }
    }
  }
}
