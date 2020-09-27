part of charts;

/// Creates the segments for HiloOpenClose series.
///
/// Generates the HiloOpenClose series points and has the [calculateSegmentPoints] method overrided to customize
/// the HiloOpenClose segment point calculation.
///
/// Gets the path and color from the [series].
class HiloOpenCloseSegment extends ChartSegment {
  num x,

      ///Low value.
      low,

      ///High value.
      high,

      ///Position of X.
      xPos,

      ///Postion of low.
      lowPos,

      ///Position of high.
      highPos,

      ///Center value of Y.
      centerY,

      ///High value of Y.
      highY,

      ///Center value of X.
      centerX,

      ///low value of X.
      lowX,

      ///High value of X.
      highX,

      ///Open value of X.
      openX,

      ///Open value of X.
      openY,

      ///Close value of Y.
      closeX,

      /// Close value of Y.
      closeY,

      /// High value of center.
      centerHigh,

      /// Low value of center.
      centerLow,

      /// Low value of Y.
      lowY,

      /// Start position.
      startPos,

      ///End position.
      endPos,

      ///Open value.
      open,

      ///Close value.
      close;

  Color _pointColorMapper;
  bool isBull = false;
  CartesianChartPoint<dynamic> _currentPoint;
  Path path;
  _ChartLocation centerLowPoint, centerHighPoint, lowPoint, highPoint;
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

  /// Gets the border color of the series.
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
    final _VisibleRange sideBySideInfo =
        _calculateSideBySideInfo(series, series._chart);
    final num startPos = xPos + sideBySideInfo.minimum;
    final num endPos = xPos + sideBySideInfo.maximum;
    final dynamic center = startPos + ((endPos - startPos) / 2);

    isBull = open < close;
    x = high = low = double.nan;
    final Rect rect = _calculatePlotOffset(
        series._chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    if (xPos != null &&
        high != null &&
        lowPos != null &&
        open != null &&
        close != null) {
      lowPoint = _calculatePoint(startPos, lowPos, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);
      highPoint = _calculatePoint(endPos, highPos, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);

      centerHighPoint = _calculatePoint(center, highPos, series._xAxis,
          series._yAxis, series._chart._requireInvertedAxis, series, rect);

      centerLowPoint = _calculatePoint(center, lowPos, series._xAxis,
          series._yAxis, series._chart._requireInvertedAxis, series, rect);

      final bool isTransposed = series._chart._requireInvertedAxis;

      x = lowPoint.x;
      low = lowPoint.y;
      high = highPoint.y;
      centerHigh = centerHighPoint.x;
      highY = centerHighPoint.y;
      centerLow = centerLowPoint.x;
      lowY = centerLowPoint.y;
      openX = _currentPoint.openPoint.x;
      openY = _currentPoint.openPoint.y;
      closeX = _currentPoint.closePoint.x;
      closeY = _currentPoint.closePoint.y;

      _showSameValue = !isTransposed
          ? centerHighPoint.y == centerLowPoint.y
          : centerHighPoint.x == centerLowPoint.x;

      x = lowPoint.x =
          (_showSameValue && isTransposed) ? lowPoint.x - 2 : lowPoint.x;
      highPoint.x =
          (_showSameValue && isTransposed) ? highPoint.x + 2 : highPoint.x;
      low = lowPoint.y =
          (_showSameValue && !isTransposed) ? lowPoint.y - 2 : lowPoint.y;
      high = highPoint.y =
          (_showSameValue && !isTransposed) ? highPoint.y + 2 : highPoint.y;
      centerHigh = centerHighPoint.x = (_showSameValue && isTransposed)
          ? centerHighPoint.x + 2
          : centerHighPoint.x;
      highY = centerHighPoint.y = (_showSameValue && !isTransposed)
          ? centerHighPoint.y + 2
          : centerHighPoint.y;
      centerLow = centerLowPoint.x = (_showSameValue && isTransposed)
          ? centerLowPoint.x - 2
          : centerLowPoint.x;
      lowY = centerLowPoint.y = (_showSameValue && !isTransposed)
          ? centerLowPoint.y - 2
          : centerLowPoint.y;
    }
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);
    if (strokePaint != null) {
      path = Path();
      if (series.animationDuration > 0 &&
          !series._chart._chartState._isLegendToggled) {
        if (!series._chart._chartState.widgetNeedUpdate) {
          if (series._chart._requireInvertedAxis) {
            lowX = lowPoint.x;
            highX = highPoint.x;
            centerX = highX + ((lowX - highX) / 2);
            openX = centerX -
                ((centerX - _currentPoint.openPoint.x) * animationFactor);
            closeX = centerX +
                ((_currentPoint.closePoint.x - centerX) * animationFactor);
            highX = centerX + ((centerX - highX).abs() * animationFactor);
            lowX = centerX - ((lowX - centerX).abs() * animationFactor);
            canvas.drawLine(Offset(lowX, centerLowPoint.y),
                Offset(highX, centerHighPoint.y), strokePaint);
            canvas.drawLine(
                Offset(openX, openY), Offset(openX, highY), strokePaint);
            canvas.drawLine(
                Offset(closeX, lowY), Offset(closeX, closeY), strokePaint);
          } else {
            centerY = high + ((low - high) / 2);
            openY = centerY -
                ((centerY - _currentPoint.openPoint.y) * animationFactor);
            closeY = centerY +
                ((_currentPoint.closePoint.y - centerY) * animationFactor);
            highY = centerY - ((centerY - high) * animationFactor);
            lowY = centerY + ((low - centerY) * animationFactor);
            canvas.drawLine(Offset(centerHigh, highY), Offset(centerLow, lowY),
                strokePaint);
            canvas.drawLine(
                Offset(openX, openY), Offset(centerHigh, openY), strokePaint);
            canvas.drawLine(
                Offset(centerLow, closeY), Offset(closeX, closeY), strokePaint);
          }
        } else {
          final HiloOpenCloseSegment currentSegment =
              series.segments[currentSegmentIndex];
          final HiloOpenCloseSegment oldSegment =
              (currentSegment.oldSeries.segments.isNotEmpty &&
                      currentSegment.oldSeries.segments[0]
                          is HiloOpenCloseSegment &&
                      currentSegment.oldSeries.segments.length - 1 >=
                          currentSegmentIndex)
                  ? currentSegment.oldSeries.segments[currentSegmentIndex]
                  : null;
          _animateHiloOpenCloseSeries(
              series._chart._requireInvertedAxis,
              series._chart._requireInvertedAxis ? lowPoint.x : low,
              series._chart._requireInvertedAxis ? highPoint.x : high,
              series._chart._requireInvertedAxis
                  ? (oldSegment != null ? oldSegment.lowPoint.x : null)
                  : oldSegment?.low,
              series._chart._requireInvertedAxis
                  ? (oldSegment != null ? oldSegment.highPoint.x : null)
                  : oldSegment?.high,
              openX,
              openY,
              closeX,
              closeY,
              series._chart._requireInvertedAxis ? centerLowPoint.y : centerLow,
              series._chart._requireInvertedAxis
                  ? centerHighPoint.y
                  : centerHigh,
              oldSegment?.openX,
              oldSegment?.openY,
              oldSegment?.closeX,
              oldSegment?.closeY,
              series._chart._requireInvertedAxis
                  ? (oldSegment != null ? oldSegment.centerLowPoint.y : null)
                  : oldSegment?.centerLow,
              series._chart._requireInvertedAxis
                  ? (oldSegment != null ? oldSegment.centerHighPoint.y : null)
                  : oldSegment?.centerHigh,
              animationFactor,
              strokePaint,
              canvas);
        }
      } else {
        path = Path();
        path.moveTo(centerHigh, highY);
        path.lineTo(centerLow, lowY);
        if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
          _drawDashedLine(
              canvas,
              series.dashArray,
              strokePaint,
              drawOpenClosePath(path, openX, openY, closeX, closeY, highY,
                  centerHigh, centerLow, series._chart._requireInvertedAxis));
        } else {
          canvas.drawPath(
              drawOpenClosePath(path, openX, openY, closeX, closeY, highY,
                  centerHigh, centerLow, series._chart._requireInvertedAxis),
              strokePaint);
        }
      }
    }
  }

  /// Draws the path between open and close values.
  Path drawOpenClosePath(Path path, num openX, num openY, num closeX,
      num closeY, num highY, num centerHigh, num centerLow, bool isTransposed) {
    path.moveTo(openX, openY);
    path.lineTo(
        isTransposed ? openX : centerHigh, isTransposed ? highY : openY);
    path.moveTo(
        isTransposed ? closeX : centerLow, isTransposed ? highY : closeY);
    path.lineTo(closeX, closeY);
    return path;
  }

  /// Method to set data.
  void _setData(List<num> values) {
    xPos = values[0];
    lowPos = values[1];
    highPos = values[2];
    open = values[3];
    close = values[4];
  }
}
