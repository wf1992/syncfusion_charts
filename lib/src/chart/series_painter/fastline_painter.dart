part of charts;

class _FastLineChartPainter extends CustomPainter {
  _FastLineChartPainter(
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
  final FastLineSeries<dynamic, dynamic> series;
  Path path;
  Paint pathPaint;
  final _PainterKey painterKey;

  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    if (series._visible) {
      canvas.save();
      final int seriesIndex = painterKey.index;
      series.storeSeriesProperties(chart, seriesIndex);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      if (series.animationDuration > 0 &&
          !series._chart._chartState._isLegendToggled) {
        _performLinearAnimation(
            series._chart, series._xAxis, canvas, animationFactor);
      }
      CartesianChartPoint<dynamic> prevPoint, point;
      _ChartLocation currentLocation;
      final _VisibleRange xVisibleRange = series._xAxis._visibleRange;
      final _VisibleRange yVisibleRange = series._yAxis._visibleRange;
      final List<CartesianChartPoint<dynamic>> seriesPoints =
          series._dataPoints;
      final Rect areaBounds = series._chart._chartAxis._axisClipRect;
      final num xTolerance = (xVisibleRange.delta / areaBounds.width).abs();
      final num yTolerance = (yVisibleRange.delta / areaBounds.height).abs();
      num prevXValue = (seriesPoints.isNotEmpty &&
              seriesPoints[0] != null &&
              seriesPoints[0].xValue > xTolerance)
          ? 0
          : xTolerance;
      num prevYValue = (seriesPoints.isNotEmpty &&
              seriesPoints[0] != null &&
              seriesPoints[0].yValue > yTolerance)
          ? 0
          : yTolerance;
      num xVal = 0;
      num yVal = 0;

      final List<CartesianChartPoint<dynamic>> dataPoints =
          <CartesianChartPoint<dynamic>>[];

      ///Eliminating nearest points
      dynamic currentPoint;
      for (int pointIndex = 0;
          pointIndex < series._dataPoints.length;
          pointIndex++) {
        currentPoint = series._dataPoints[pointIndex];
        xVal = currentPoint.xValue != null
            ? currentPoint.xValue
            : xVisibleRange.minimum;
        yVal = currentPoint.yValue != null
            ? currentPoint.yValue
            : yVisibleRange.minimum;
        if ((prevXValue - xVal).abs() >= xTolerance ||
            (prevYValue - yVal).abs() >= yTolerance) {
          point = currentPoint;
          dataPoints.add(currentPoint);
          series.calculateRegionData(
              chart, series, painterKey.index, point, pointIndex);
          if (point.isVisible) {
            currentLocation = _calculatePoint(
                xVal,
                yVal,
                series._xAxis,
                series._yAxis,
                series._chart._requireInvertedAxis,
                series,
                series._chart._chartAxis._axisClipRect);
            if (prevPoint == null)
              series.segmentPath.moveTo(currentLocation.x, currentLocation.y);
            else if (series._dataPoints[pointIndex - 1].isVisible == false &&
                series.emptyPointSettings.mode == EmptyPointMode.gap)
              series.segmentPath.moveTo(currentLocation.x, currentLocation.y);
            else if (point.isGap != true &&
                series._dataPoints[pointIndex - 1].isGap != true &&
                series._dataPoints[pointIndex].isVisible == true)
              series.segmentPath.lineTo(currentLocation.x, currentLocation.y);
            else
              series.segmentPath.moveTo(currentLocation.x, currentLocation.y);
            prevPoint = point;
          }
          prevXValue = xVal;
          prevYValue = yVal;
        }
      }

      if (series.segmentPath != null) {
        series._dataPoints = dataPoints;
        series.drawSegment(canvas,
            series.addSegment(painterKey.index, chart, animationFactor));
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
  bool shouldRepaint(_FastLineChartPainter oldDelegate) => isRepaint;
}
