part of charts;

class _BarChartPainter extends CustomPainter {
  _BarChartPainter(
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
  final Animation<double> animationController;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final BarSeries<dynamic, dynamic> series;
  final _PainterKey painterKey;

  @override
  void paint(Canvas canvas, Size size) {
    Rect axisClipRect, clipRect;
    double animationFactor;
    CartesianChartPoint<dynamic> point;

    if (series._visible) {
      canvas.save();
      final int seriesIndex = painterKey.index;
      series.storeSeriesProperties(chart, seriesIndex);
      axisClipRect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
          Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;

      /// side by side range calculated
      final _VisibleRange sideBySideInfo =
          _calculateSideBySideInfo(series, chart);

      final num origin = math.max(series._yAxis._visibleRange.minimum, 0);
      int segmentIndex = -1;
      for (int pointIndex = 0;
          pointIndex < series._dataPoints.length;
          pointIndex++) {
        point = series._dataPoints[pointIndex];
        series.calculateRegionData(
            chart, series, painterKey.index, point, pointIndex, sideBySideInfo);
        if (point.isVisible && !point.isGap) {
          series.drawSegment(
              canvas,
              series.addSegment(point, segmentIndex += 1, painterKey.index,
                  sideBySideInfo, chart, origin, animationFactor));
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
        chart._chartState
            .setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter oldDelegate) => isRepaint;
}
