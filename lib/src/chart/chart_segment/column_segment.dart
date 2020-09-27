part of charts;

/// Creates the segments for column series.
///
/// This generates the column series points and has the [calculateSegmentPoints] override method
/// used to customize the column series segment point calculation.
///
/// It gets the path, stroke color and fill color from the [series] to render the column segment.
///
class ColumnSegment extends ChartSegment {
  /// X1 value.
  num x1;

  /// Y1 value.
  num y1;

  /// X2 value.
  num x2;

  /// Y2 value.
  num y2;

  /// Render path.
  Path path;
  RRect _trackRect;
  CartesianChartPoint<dynamic> _currentPoint;
  Paint _trackerFillPaint;
  Paint _trackerStrokePaint;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    // final bool hasPointColor = series.pointColorMapper != null ? true : false;

    /// Get and set the paint options for column series.
    if (series.gradient == null) {
      if (color != null) {
        fillPaint = Paint()
          ..color = _currentPoint.isEmpty == true
              ? series.emptyPointSettings.color
              : ((_currentPoint.pointColorMapper != null)
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
    if (strokeColor != null) {
      strokePaint = Paint()
        ..color = _currentPoint.isEmpty == true
            ? series.emptyPointSettings.borderColor
            : strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _currentPoint.isEmpty == true
            ? series.emptyPointSettings.borderWidth
            : strokeWidth;
      _defaultStrokeColor = strokePaint;
    }
    series.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    return strokePaint;
  }

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    final ColumnSeries<dynamic, dynamic> columnSeries = series;
    if (color != null) {
      _trackerFillPaint = Paint()
        ..color = columnSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final ColumnSeries<dynamic, dynamic> columnSeries = series;
    _trackerStrokePaint = Paint()
      ..color = columnSeries.trackBorderColor
      ..strokeWidth = columnSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    columnSeries.trackBorderWidth == 0
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
    final ColumnSeries<dynamic, dynamic> columnSeries = series;

    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);

    if (_trackerFillPaint != null && columnSeries.isTrackVisible) {
      series.animationDuration > 0
          ? _animateRectSeries(
              canvas,
              series,
              _trackerFillPaint,
              _trackRect,
              _currentPoint.yValue,
              animationFactor,
              _oldPoint != null ? _oldPoint.region : _oldRegion,
              _oldPoint?.yValue,
              _oldSeriesVisible)
          : canvas.drawRRect(_trackRect, _trackerFillPaint);
    }

    if (_trackerStrokePaint != null && columnSeries.isTrackVisible) {
      series.animationDuration > 0
          ? _animateRectSeries(
              canvas,
              series,
              _trackerStrokePaint,
              _trackRect,
              _currentPoint.yValue,
              animationFactor,
              _oldPoint != null ? _oldPoint.region : _oldRegion,
              _oldPoint?.yValue,
              _oldSeriesVisible)
          : canvas.drawRRect(_trackRect, _trackerStrokePaint);
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
