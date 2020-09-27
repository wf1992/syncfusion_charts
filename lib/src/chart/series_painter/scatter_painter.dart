part of charts;

class _ScatterChartPainter extends CustomPainter {
  _ScatterChartPainter(
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
  final ScatterSeries<dynamic, dynamic> series;
  final _PainterKey painterKey;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    double animationFactor;
    if (series._visible) {
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      final int seriesIndex = painterKey.index;
      series.storeSeriesProperties(chart, seriesIndex);
      int segmentIndex = -1;
      for (int pointIndex = 0;
          pointIndex < series._dataPoints.length;
          pointIndex++) {
        final CartesianChartPoint<dynamic> currentPoint =
            series._dataPoints[pointIndex];
        series.calculateRegionData(
            chart, series, painterKey.index, currentPoint, pointIndex);
        if (currentPoint.isVisible && !currentPoint.isGap) {
          series.drawSegment(
              canvas,
              series.addSegment(currentPoint, segmentIndex += 1, seriesIndex,
                  animationFactor));
        }
      }
      if (series.animationDuration <= 0 ||
          animationFactor >= chart._seriesDurationFactor) {
        series.renderSeriesElements(chart, canvas, chartElementAnimation);
      }
      if (animationFactor >= 1) {
        chart._chartState
            .setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScatterChartPainter oldDelegate) => isRepaint;
}
