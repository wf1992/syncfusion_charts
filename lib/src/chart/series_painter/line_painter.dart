part of charts;

class _LineChartPainter extends CustomPainter {
  _LineChartPainter(
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
  final AnimationController animationController;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final LineSeries<dynamic, dynamic> series;
  final _PainterKey painterKey;

  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    Rect clipRect;
    if (series._visible) {
      canvas.save();
      final int seriesIndex = painterKey.index;
      series.storeSeriesProperties(chart, seriesIndex);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      if (!(chart._chartState.widgetNeedUpdate ||
              chart._chartState._isLegendToggled) &&
          series.animationDuration > 0) {
        _performLinearAnimation(
            series._chart, series._xAxis, canvas, animationFactor);
      }
      int segmentIndex = -1;
      CartesianChartPoint<dynamic> startPoint, endPoint;

      for (int pointIndex = 0;
          pointIndex < series._dataPoints.length;
          pointIndex++) {
        final CartesianChartPoint<dynamic> currentPoint =
            series._dataPoints[pointIndex];
        series.calculateRegionData(
            chart, series, seriesIndex, currentPoint, pointIndex);
        if ((currentPoint.isVisible && !currentPoint.isGap) &&
            startPoint == null) {
          startPoint = currentPoint;
        }
        if (pointIndex + 1 < series._dataPoints.length) {
          final CartesianChartPoint<dynamic> nextPoint =
              series._dataPoints[pointIndex + 1];
          if (startPoint != null && nextPoint.isVisible && nextPoint.isGap) {
            startPoint = null;
          } else if (nextPoint.isVisible && !nextPoint.isGap) {
            endPoint = nextPoint;
          }
        }

        if (startPoint != null && endPoint != null) {
          series.drawSegment(
              canvas,
              series.addSegment(startPoint, endPoint, segmentIndex += 1,
                  seriesIndex, animationFactor));
          endPoint = startPoint = null;
        }
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
        chart._chartState.setPainterKey(seriesIndex, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) => isRepaint;
}
