part of charts;

class _AreaChartPainter extends CustomPainter {
  _AreaChartPainter(
      {this.chart,
      this.series,
      this.isRepaint,
      this.animationController,
      this.seriesAnimation,
      this.chartElementAnimation,
      ValueNotifier<num> notifier,
      this.painterKey})
      : super(repaint: notifier);
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final Animation<double> animationController;
  final AreaSeries<dynamic, dynamic> series;
  final _PainterKey painterKey;

  @override
  void paint(Canvas canvas, Size size) {
    final int seriesIndex = painterKey.index;
    Rect clipRect;
    series.storeSeriesProperties(chart, seriesIndex);
    double animationFactor;
    CartesianChartPoint<dynamic> prevPoint, point, _point;
    _ChartLocation currentPoint, originPoint, oldPoint;
    final ChartAxis xAxis = series._xAxis;
    final ChartAxis yAxis = series._yAxis;
    XyDataSeries<dynamic, dynamic> oldSeries;
    final Path _path = Path();
    final Path _strokePath = Path();
    if (series._visible) {
      canvas.save();
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      if (chart._chartState.widgetNeedUpdate &&
          xAxis._zoomFactor == 1 &&
          yAxis._zoomFactor == 1 &&
          chart._chartState.prevWidgetSeries != null &&
          chart._chartState.prevWidgetSeries.isNotEmpty &&
          chart._chartState.prevWidgetSeries.length - 1 >= seriesIndex &&
          chart._chartState.prevWidgetSeries[seriesIndex]._seriesName ==
              series._seriesName) {
        oldSeries = chart._chartState.prevWidgetSeries[seriesIndex];
      }
      if (!series._chart._chartState.widgetNeedUpdate &&
          series.animationDuration > 0 &&
          !series._chart._chartState._isLegendToggled) {
        _performLinearAnimation(
            series._chart, series._xAxis, canvas, animationFactor);
      }
      for (int pointIndex = 0;
          pointIndex < series._dataPoints.length;
          pointIndex++) {
        point = series._dataPoints[pointIndex];
        series.calculateRegionData(
            chart, series, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          _point = (series.animationDuration > 0 &&
                  series._chart._chartState.widgetNeedUpdate &&
                  !series._chart._chartState._isLegendToggled &&
                  series._chart._chartState.prevWidgetSeries != null &&
                  series._chart._chartState.prevWidgetSeries.isNotEmpty &&
                  oldSeries != null &&
                  oldSeries.segments.isNotEmpty &&
                  oldSeries.segments[0] is AreaSegment &&
                  series._chart._chartState.prevWidgetSeries.length - 1 >=
                      seriesIndex &&
                  oldSeries._dataPoints.length - 1 >= pointIndex)
              ? oldSeries._dataPoints[pointIndex]
              : null;
          oldPoint = _point != null
              ? _calculatePoint(
                  _point.xValue,
                  _point.yValue,
                  oldSeries._xAxis,
                  oldSeries._yAxis,
                  series._chart._requireInvertedAxis,
                  oldSeries,
                  axisClipRect)
              : null;
          currentPoint = _calculatePoint(point.xValue, point.yValue, xAxis,
              yAxis, series._chart._requireInvertedAxis, series, axisClipRect);
          originPoint = _calculatePoint(
              point.xValue,
              math_lib.max(yAxis._visibleRange.minimum, 0),
              xAxis,
              yAxis,
              series._chart._requireInvertedAxis,
              series,
              axisClipRect);
          num x = currentPoint.x;
          num y = currentPoint.y;
          final bool closed =
              series.emptyPointSettings.mode == EmptyPointMode.drop
                  ? _getVisibility(series._dataPoints, pointIndex)
                  : false;
          if (oldPoint != null) {
            if (series._chart.isTransposed) {
              x = _getValue(animationFactor, x, oldPoint.x, currentPoint.x);
            } else {
              y = _getValue(animationFactor, y, oldPoint.y, currentPoint.y);
            }
          }
          if (prevPoint == null ||
              series._dataPoints[pointIndex - 1].isGap == true ||
              (series._dataPoints[pointIndex].isGap == true) ||
              (series._dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(originPoint.x, originPoint.y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
              if (series._dataPoints[pointIndex].isGap != true) {
                _strokePath.moveTo(originPoint.x, originPoint.y);
                _strokePath.lineTo(x, y);
              }
            } else if (series.borderDrawMode == BorderDrawMode.all) {
              if (series._dataPoints[pointIndex].isGap != true) {
                _strokePath.moveTo(originPoint.x, originPoint.y);
                _strokePath.lineTo(x, y);
              }
            } else if (series.borderDrawMode == BorderDrawMode.top) {
              _strokePath.moveTo(x, y);
            }
            _path.lineTo(x, y);
          } else if (pointIndex == series._dataPoints.length - 1 ||
              series._dataPoints[pointIndex + 1].isGap == true) {
            _strokePath.lineTo(x, y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom)
              _strokePath.lineTo(originPoint.x, originPoint.y);
            else if (series.borderDrawMode == BorderDrawMode.all) {
              _strokePath.lineTo(originPoint.x, originPoint.y);
              _strokePath.close();
            }
            _path.lineTo(x, y);
            _path.lineTo(originPoint.x, originPoint.y);
          } else {
            _strokePath.lineTo(x, y);
            _path.lineTo(x, y);

            if (closed) {
              _path.lineTo(originPoint.x, originPoint.y);
              if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
                _strokePath.lineTo(originPoint.x, originPoint.y);
              } else if (series.borderDrawMode == BorderDrawMode.all) {
                _strokePath.lineTo(originPoint.x, originPoint.y);
                _strokePath.close();
              }
            }
          }
          prevPoint = point;
        }
        if (pointIndex >= series._dataPoints.length - 1) {
          series.addSegment(painterKey.index, chart, animationFactor);
        }
      }

      if (_path != null &&
          series.segments != null &&
          series.segments.isNotEmpty) {
        final AreaSegment areaSegment = series.segments[0];
        series.drawSegment(
            canvas,
            areaSegment
              .._path = _path
              .._strokePath = _strokePath);
      }
      clipRect = _calculatePlotOffset(
          Rect.fromLTRB(
              chart._chartAxis._axisClipRect.left - series.markerSettings.width,
              chart._chartAxis._axisClipRect.top - series.markerSettings.height,
              chart._chartAxis._axisClipRect.right +
                  series.markerSettings.width,
              chart._chartAxis._axisClipRect.bottom +
                  series.markerSettings.height),
          Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
      canvas.restore();
      if ((series.animationDuration <= 0 ||
              animationFactor >= chart._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        canvas.clipRect(clipRect);
        series.renderSeriesElements(chart, canvas, chartElementAnimation);
      }
      if (animationFactor >= 1) {
        chart._chartState
            .setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  bool _getVisibility(List<CartesianChartPoint<dynamic>> points, int index) {
    for (int i = index; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        return false;
      }
    }
    return true;
  }

  @override
  bool shouldRepaint(_AreaChartPainter oldDelegate) => isRepaint;
}
