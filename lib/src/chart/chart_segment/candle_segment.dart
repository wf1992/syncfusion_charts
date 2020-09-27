part of charts;

/// Creates the segments for bubble series.
///
/// Generates the candle series points and has the [calculateSegmentPoints] override method
/// used to customize the candle series segment point calculation.
///
/// Gets the path and fill color from the [series] to render the candle segment.
///
class CandleSegment extends ChartSegment {
  /// X position.
  num x;

  /// Low value.
  num low;

  /// High value.
  num high;

  /// X position value.
  num xPos;

  /// Low position value.
  num lowPos;

  /// High position value.
  num highPos;

  /// Center Y value.
  num centerY;

  ///High value of Y.
  num highY;

  /// Open value of X.
  num openX;

  /// Open value of Y.
  num openY;

  /// Close value of X.
  num closeX;

  /// Close value of Y.
  num closeY;

  /// Center high value.
  num centerHigh;

  /// Center low value.
  num centerLow;

  /// Y value of low value.
  num lowY;

  /// Start position value.
  num startPos;

  /// End position value.
  num endPos;

  /// Open value.
  num open;

  /// Close value.
  num close;

  Color _pointColorMapper;
  bool isBull = false;
  CartesianChartPoint<dynamic> _currentPoint;
  double width = 0;
  bool isSolid = false;
  Path path;
  bool _showSameValue;
  _ChartLocation openPoint,
      closePoint,
      lowPoint,
      highPoint,
      centerLowPoint,
      centerHighPoint;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (color != null) {
      fillPaint.color = _pointColorMapper ?? color;
      fillPaint.color =
          (series.opacity < 1 && fillPaint.color != Colors.transparent)
              ? fillPaint.color.withOpacity(series.opacity)
              : fillPaint.color;
    }
    fillPaint.strokeWidth = strokeWidth;
    if (isSolid) {
      fillPaint.style = PaintingStyle.fill;
    } else {
      fillPaint.style = PaintingStyle.stroke;
    }
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
    open < close ? isBull = true : isBull = false;
    x = high = low = double.nan;
    final Rect rect = _calculatePlotOffset(
        series._chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    if (xPos != null && lowPos != null) {
      centerHighPoint = _calculatePoint(center, highPos, series._xAxis,
          series._yAxis, series._chart._requireInvertedAxis, series, rect);

      centerLowPoint = _calculatePoint(center, lowPos, series._xAxis,
          series._yAxis, series._chart._requireInvertedAxis, series, rect);

      openPoint = _calculatePoint(startPos, open, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);

      closePoint = _calculatePoint(endPos, close, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);
      lowPoint = _calculatePoint(startPos, lowPos, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);
      highPoint = _calculatePoint(endPos, highPos, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);

      final bool isTransposed = series._chart._requireInvertedAxis;

      x = lowPoint.x;
      low = lowPoint.y;
      high = highPoint.y;
      centerHigh = centerHighPoint.x;
      highY = centerHighPoint.y;
      centerLow = centerLowPoint.x;
      lowY = centerLowPoint.y;
      openX = openPoint.x;
      openY = openPoint.y;
      closeX = closePoint.x;
      closeY = closePoint.y;

      _showSameValue = !series._chart._requireInvertedAxis
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
    if (fillPaint != null &&
        !(series._chart._chartState.widgetNeedUpdate &&
            !series._chart._chartState._isLegendToggled)) {
      path = Path();
      if (!series._chart._requireInvertedAxis && open > close) {
        final num temp = closeY;
        closeY = openY;
        openY = temp;
      }
      if (series._chart._chartState._isLegendToggled) {
        animationFactor = 1;
      }
      num centersY = closeY + ((closeY - openY).abs() / 2);
      num topRectY = centersY - ((centersY - closeY).abs() * animationFactor);
      num topLineY = topRectY - ((topRectY - highY).abs() * animationFactor);
      num bottomRectY = centersY + ((centersY - openY).abs() * animationFactor);
      num bottomLineY =
          bottomRectY + ((bottomRectY - lowY).abs() * animationFactor);

      if (lowY < openY) {
        bottomLineY = bottomRectY - ((openY - lowY).abs() * animationFactor);
      }
      if (highY > closeY) {
        topLineY = topRectY + ((closeY - highY).abs() * animationFactor);
      }
      if (series._chart._requireInvertedAxis) {
        if (open > close) {
          centersY = closeX + ((openX - closeX).abs() / 2);
          topRectY = centersY + ((centersY - openX).abs() * animationFactor);
          bottomRectY =
              centersY - ((centersY - closeX).abs() * animationFactor);
        } else {
          centersY = openX + (closeX - openX).abs() / 2;
          topRectY = centersY + ((centersY - closeX).abs() * animationFactor);
          bottomRectY = centersY - ((centersY - openX).abs() * animationFactor);
        }
      }
      if (series._chart._requireInvertedAxis) {
        if (_showSameValue) {
          canvas.drawLine(Offset(centerHighPoint.x, centerHighPoint.y),
              Offset(centerLowPoint.x, centerHighPoint.y), fillPaint);
        } else {
          path.moveTo(topRectY, highY);
          if (centerHigh < closeX) {
            path.lineTo(
                topRectY - ((closeX - centerHigh).abs() * animationFactor),
                highY);
          } else
            path.lineTo(
                topRectY + ((closeX - centerHigh).abs() * animationFactor),
                highY);
          path.moveTo(bottomRectY, highY);
          if (centerLow > openX) {
            path.lineTo(
                bottomRectY + ((openX - centerLow).abs() * animationFactor),
                highY);
          } else
            path.lineTo(
                bottomRectY - ((openX - centerLow).abs() * animationFactor),
                highY);
        }
        if (openX == closeX) {
          canvas.drawLine(
              Offset(openX, openY), Offset(closeX, closeY), fillPaint);
        } else {
          path.moveTo(topRectY, closeY);
          path.lineTo(topRectY, openY);
          path.lineTo(bottomRectY, openY);
          path.lineTo(bottomRectY, closeY);
          path.lineTo(topRectY, closeY);
          path.close();
        }
      } else {
        if (open > close) {
          final num temp = closeY;
          closeY = openY;
          openY = temp;
        }

        if (_showSameValue) {
          canvas.drawLine(Offset(centerHighPoint.x, highPoint.y),
              Offset(centerHighPoint.x, lowPoint.y), fillPaint);
        } else {
          canvas.drawLine(Offset(centerHigh, topRectY),
              Offset(centerHigh, topLineY), fillPaint);
          canvas.drawLine(Offset(centerHigh, bottomRectY),
              Offset(centerHigh, bottomLineY), fillPaint);
        }
        if (openY == closeY) {
          canvas.drawLine(
              Offset(openX, openY), Offset(closeX, closeY), fillPaint);
        } else {
          path.moveTo(openX, topRectY);
          path.lineTo(closeX, topRectY);
          path.lineTo(closeX, bottomRectY);
          path.lineTo(openX, bottomRectY);
          path.lineTo(openX, topRectY);
          path.close();
        }
      }

      if (series.dashArray[0] != 0 &&
          series.dashArray[1] != 0 &&
          fillPaint.style != PaintingStyle.fill &&
          series.animationDuration <= 0) {
        _drawDashedLine(canvas, series.dashArray, fillPaint, path);
      } else {
        canvas.drawPath(path, fillPaint);
        if (fillPaint.style == PaintingStyle.fill) {
          if (series._chart._requireInvertedAxis) {
            if (open > close) {
              if (_showSameValue) {
                canvas.drawLine(Offset(centerHighPoint.x, centerHighPoint.y),
                    Offset(centerLowPoint.x, centerHighPoint.y), fillPaint);
              } else {
                canvas.drawLine(
                    Offset(topRectY, highY),
                    Offset(
                        topRectY +
                            ((openX - centerHigh).abs() * animationFactor),
                        highY),
                    fillPaint);
                canvas.drawLine(
                    Offset(bottomRectY, highY),
                    Offset(
                        bottomRectY -
                            ((closeX - centerLow).abs() * animationFactor),
                        highY),
                    fillPaint);
              }
            } else {
              if (_showSameValue) {
                canvas.drawLine(Offset(centerHighPoint.x, centerHighPoint.y),
                    Offset(centerLowPoint.x, centerHighPoint.y), fillPaint);
              } else {
                canvas.drawLine(
                    Offset(topRectY, highY),
                    Offset(
                        topRectY +
                            ((closeX - centerHigh).abs() * animationFactor),
                        highY),
                    fillPaint);
                canvas.drawLine(
                    Offset(bottomRectY, highY),
                    Offset(
                        bottomRectY -
                            ((openX - centerLow).abs() * animationFactor),
                        highY),
                    fillPaint);
              }
            }
          } else {
            if (_showSameValue) {
              canvas.drawLine(Offset(centerHighPoint.x, highPoint.y),
                  Offset(centerHighPoint.x, lowPoint.y), fillPaint);
            } else {
              canvas.drawLine(Offset(centerHigh, topRectY),
                  Offset(centerHigh, topLineY), fillPaint);
              canvas.drawLine(Offset(centerHigh, bottomRectY),
                  Offset(centerHigh, bottomLineY), fillPaint);
            }
          }
        }
      }
    } else if (!series._chart._chartState._isLegendToggled) {
      final CandleSegment currentSegment = series.segments[currentSegmentIndex];
      final CandleSegment oldSegment =
          (currentSegment.oldSeries.segments.isNotEmpty &&
                  currentSegment.oldSeries.segments[0] is CandleSegment &&
                  currentSegment.oldSeries.segments.length - 1 >=
                      currentSegmentIndex)
              ? currentSegment.oldSeries.segments[currentSegmentIndex]
              : null;
      _animateCandleSeries(
          _showSameValue,
          high,
          series._chart._requireInvertedAxis,
          open,
          close,
          lowY,
          highY,
          oldSegment?.lowY,
          oldSegment?.highY,
          openX,
          openY,
          closeX,
          closeY,
          centerLow,
          centerHigh,
          oldSegment?.openX,
          oldSegment?.openY,
          oldSegment?.closeX,
          oldSegment?.closeY,
          oldSegment?.centerLow,
          oldSegment?.centerHigh,
          animationFactor,
          fillPaint,
          canvas);
    }
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
