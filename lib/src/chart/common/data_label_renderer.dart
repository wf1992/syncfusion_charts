part of charts;

///Calculating datalabel position and updating the label region for current data point
void _calculateDataLabelPosition(XyDataSeries<dynamic, dynamic> series,
    CartesianChartPoint<dynamic> point, int index, SfCartesianChart chart) {
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  Size textSize, textSize2, textSize3, textSize4;
  num value1, value2;
  final Rect rect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
      Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
  value1 =
      (point.open != null && point.close != null && point.close < point.open)
          ? point.close
          : point.open;
  value2 =
      (point.open != null && point.close != null && point.close > point.open)
          ? point.close
          : point.open;
  final bool transposed = chart._requireInvertedAxis;
  final bool inversed = series._yAxis.isInversed;
  final Rect clipRect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
      Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
  final bool isRangeSeries = series._seriesType.contains('range') ||
      series._seriesType.contains('hilo') ||
      series._seriesType.contains('candle');
  if (point != null && point.isVisible && point.isGap != true) {
    final num markerPointX =
        series._seriesType.contains('hilo') || series._seriesType == 'candle'
            ? series._chart._requireInvertedAxis
                ? point.region.centerRight.dx
                : point.region.topCenter.dx
            : point.markerPoint.x;
    final num markerPointY =
        series._seriesType.contains('hilo') || series._seriesType == 'candle'
            ? series._chart._requireInvertedAxis
                ? point.region.centerRight.dy
                : point.region.topCenter.dy
            : point.markerPoint.y;
    final _ChartLocation markerPoint2 = _calculatePoint(
        point.xValue,
        series._yAxis.isInversed ? value2 : value1,
        series._xAxis,
        series._yAxis,
        chart._requireInvertedAxis,
        series,
        rect);
    final _ChartLocation markerPoint3 = _calculatePoint(
        point.xValue,
        series._yAxis.isInversed ? value1 : value2,
        series._xAxis,
        series._yAxis,
        chart._requireInvertedAxis,
        series,
        rect);
    final String label = point.dataLabelMapper ??
        _getLabelText(
            isRangeSeries
                ? (!inversed ? point.high : point.low)
                : ((dataLabel.showCumulativeValues &&
                        point.cumulativeValue != null)
                    ? point.cumulativeValue
                    : point.yValue),
            series,
            chart);
    if (isRangeSeries)
      point.label2 = point.dataLabelMapper ??
          _getLabelText(!inversed ? point.low : point.high, series, chart);
    final ChartTextStyle font =
        (dataLabel.textStyle == null) ? ChartTextStyle() : dataLabel.textStyle;
    point.label = label;
    if (label.isNotEmpty) {
      _ChartLocation chartLocation,
          chartLocation2,
          chartLocation3,
          chartLocation4;
      textSize = _measureText(label, font);
      chartLocation = _ChartLocation(markerPointX, markerPointY);
      if (isRangeSeries) {
        textSize2 = _measureText(point.label2, font);
        chartLocation2 = _ChartLocation(
            series._seriesType.contains('hilo') ||
                    series._seriesType == 'candle'
                ? series._chart._requireInvertedAxis
                    ? point.region.centerLeft.dx
                    : point.region.bottomCenter.dx
                : point.markerPoint2.x,
            series._seriesType.contains('hilo') ||
                    series._seriesType == 'candle'
                ? series._chart._requireInvertedAxis
                    ? point.region.centerLeft.dy
                    : point.region.bottomCenter.dy
                : point.markerPoint2.y);
      }
      final List<_ChartLocation> alignedLabelLocations =
          _getAlignedLabelLocations(chart, series, point, dataLabel,
              chartLocation, chartLocation2, textSize);
      chartLocation = alignedLabelLocations[0];
      chartLocation2 = alignedLabelLocations[1];
      if (!series._isRectSeries &&
          series._seriesType != 'rangearea' &&
          !series._seriesType.contains('hilo') &&
          !series._seriesType.contains('candle')) {
        chartLocation.y = _calculatePathPosition(
            chartLocation.y,
            dataLabel.labelAlignment,
            textSize,
            dataLabel.borderWidth,
            series,
            index,
            transposed,
            chartLocation,
            chart,
            point,
            Size(
                series.markerSettings.isVisible
                    ? series.markerSettings.width / 2
                    : 0,
                series.markerSettings.isVisible
                    ? series.markerSettings.height / 2
                    : 0));
      } else {
        final List<_ChartLocation> _locations = _getLabelLocations(
            index,
            chart,
            series,
            point,
            dataLabel,
            chartLocation,
            chartLocation2,
            textSize,
            textSize2);
        chartLocation = _locations[0];
        chartLocation2 = _locations[1];
      }
      if (series._seriesType == 'hiloopenclose' ||
          series._seriesType.contains('candle')) {
        point.label3 = point.dataLabelMapper ??
            _getLabelText(
                point.open > point.close
                    ? !inversed ? point.close : point.open
                    : !inversed ? point.open : point.close,
                series,
                chart);
        point.label4 = point.dataLabelMapper ??
            _getLabelText(
                point.open > point.close
                    ? !inversed ? point.open : point.close
                    : !inversed ? point.close : point.open,
                series,
                chart);
        textSize3 = _measureText(point.label3, font);
        if (series._seriesType.contains('hilo')) {
          if (point.open > point.close)
            chartLocation3 = _ChartLocation(
                point.centerClosePoint.x + textSize3.width, point.closePoint.y);
          else
            chartLocation3 = _ChartLocation(
                point.centerOpenPoint.x - textSize3.width, point.openPoint.y);
        } else if (series._seriesType == 'candle' &&
            series._chart._requireInvertedAxis) {
          if (point.open > point.close) {
            chartLocation3 =
                _ChartLocation(point.closePoint.x, markerPoint2.y + 1);
          } else
            chartLocation3 =
                _ChartLocation(point.openPoint.x, markerPoint2.y + 1);
        } else {
          chartLocation3 =
              _ChartLocation(point.region.topCenter.dx, markerPoint2.y);
        }
        textSize4 = _measureText(point.label4, font);
        if (series._seriesType.contains('hilo')) {
          if (point.open > point.close)
            chartLocation4 = _ChartLocation(
                point.centerOpenPoint.x - textSize4.width, point.openPoint.y);
          else
            chartLocation4 = _ChartLocation(
                point.centerClosePoint.x + textSize4.width, point.closePoint.y);
        } else if (series._seriesType == 'candle' &&
            series._chart._requireInvertedAxis) {
          if (point.open > point.close) {
            chartLocation4 =
                _ChartLocation(point.openPoint.x, markerPoint3.y + 1);
          } else
            chartLocation4 =
                _ChartLocation(point.closePoint.x, markerPoint3.y + 1);
        } else {
          chartLocation4 =
              _ChartLocation(point.region.bottomCenter.dx, markerPoint3.y);
        }
        final List<_ChartLocation> alignedLabelLocations2 =
            _getAlignedLabelLocations(chart, series, point, dataLabel,
                chartLocation3, chartLocation4, textSize3);
        chartLocation3 = alignedLabelLocations2[0];
        chartLocation4 = alignedLabelLocations2[1];
        final List<_ChartLocation> _locations = _getLabelLocations(
            index,
            chart,
            series,
            point,
            dataLabel,
            chartLocation3,
            chartLocation4,
            textSize3,
            textSize4);
        chartLocation3 = _locations[0];
        chartLocation4 = _locations[1];
      }
      _calculateDataLabelRegion(
          point,
          dataLabel,
          chart,
          chartLocation,
          chartLocation2,
          isRangeSeries,
          clipRect,
          textSize,
          textSize2,
          chartLocation3,
          chartLocation4,
          textSize3,
          textSize4,
          series);
    }
  }
}

///Calculating the label location based on alignment value
List<_ChartLocation> _getAlignedLabelLocations(
    SfCartesianChart chart,
    XyDataSeries<dynamic, dynamic> series,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    Size textSize) {
  final bool transposed = chart._requireInvertedAxis;
  final bool isRangeSeries = series._seriesType.contains('range') ||
      series._seriesType.contains('hilo') ||
      series._seriesType.contains('candle');
  final double alignmentValue = textSize.height +
      (series.markerSettings.isVisible
          ? ((series.markerSettings.borderWidth * 2) +
              series.markerSettings.height)
          : 0);
  if ((series._seriesType.contains('bar') && !chart.isTransposed) ||
      (series._seriesType.contains('column') && chart.isTransposed) ||
      series._seriesType.contains('hilo') ||
      series._seriesType.contains('candle')) {
    chartLocation.x = (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
        ? chartLocation.x
        : _calculateAlignment(
            alignmentValue,
            chartLocation.x,
            dataLabel.alignment,
            (isRangeSeries ? point.high : point.yValue) < 0,
            transposed);
    if (isRangeSeries) {
      chartLocation2.x =
          (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
              ? chartLocation2.x
              : _calculateAlignment(
                  alignmentValue,
                  chartLocation2.x,
                  dataLabel.alignment,
                  (isRangeSeries ? point.low : point.yValue) < 0,
                  transposed);
    }
  } else {
    chartLocation.y = (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
        ? chartLocation.y
        : _calculateAlignment(
            alignmentValue,
            chartLocation.y,
            dataLabel.alignment,
            (isRangeSeries ? point.high : point.yValue) < 0,
            transposed);
    if (isRangeSeries) {
      chartLocation2.y =
          (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
              ? chartLocation2.y
              : _calculateAlignment(
                  alignmentValue,
                  chartLocation2.y,
                  dataLabel.alignment,
                  (isRangeSeries ? point.low : point.yValue) < 0,
                  transposed);
    }
  }
  return <_ChartLocation>[chartLocation, chartLocation2];
}

///calculating the label loaction based on dataLabel position value
///(for range and rect series only)
List<_ChartLocation> _getLabelLocations(
    int index,
    SfCartesianChart chart,
    XyDataSeries<dynamic, dynamic> series,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    Size textSize,
    Size textSize2) {
  final bool transposed = chart._requireInvertedAxis;
  final EdgeInsets margin = dataLabel.margin;
  final bool isRangeSeries = series._seriesType.contains('range') ||
      series._seriesType.contains('hilo') ||
      series._seriesType.contains('candle');
  final bool inversed = series._yAxis.isInversed;
  final num value = isRangeSeries ? point.high : point.yValue;
  final bool minus = (value < 0 && !inversed) || (!(value < 0) && inversed);
  if (!chart._requireInvertedAxis) {
    chartLocation.y = _calculateRectPosition(
        chartLocation.y,
        point.region,
        minus,
        isRangeSeries
            ? ((dataLabel.labelAlignment == ChartDataLabelAlignment.outer ||
                    dataLabel.labelAlignment == ChartDataLabelAlignment.top)
                ? dataLabel.labelAlignment
                : ChartDataLabelAlignment.auto)
            : dataLabel.labelAlignment,
        series,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        chart,
        transposed,
        margin);
  } else {
    chartLocation.x = _calculateRectPosition(
        chartLocation.x,
        point.region,
        minus,
        series._seriesType.contains('hilo') ||
                series._seriesType.contains('candle')
            ? ChartDataLabelAlignment.auto
            : isRangeSeries
                ? ((dataLabel.labelAlignment == ChartDataLabelAlignment.outer ||
                        dataLabel.labelAlignment == ChartDataLabelAlignment.top)
                    ? dataLabel.labelAlignment
                    : ChartDataLabelAlignment.auto)
                : dataLabel.labelAlignment,
        series,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        chart,
        transposed,
        margin);
  }
  chartLocation2 = isRangeSeries
      ? _getSecondLabelLocation(index, chart, series, point, dataLabel,
          chartLocation, chartLocation2, textSize)
      : chartLocation2;
  return <_ChartLocation>[chartLocation, chartLocation2];
}

///Finding range series second label location
_ChartLocation _getSecondLabelLocation(
    int index,
    SfCartesianChart chart,
    XyDataSeries<dynamic, dynamic> series,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    Size textSize) {
  final bool inversed = series._yAxis.isInversed;
  final bool transposed = chart._requireInvertedAxis;
  final EdgeInsets margin = dataLabel.margin;
  final bool minus =
      (point.low < 0 && !inversed) || (!(point.low < 0) && inversed);
  if (!chart._requireInvertedAxis) {
    chartLocation2.y = _calculateRectPosition(
        chartLocation2.y,
        point.region,
        minus,
        dataLabel.labelAlignment == ChartDataLabelAlignment.top
            ? ChartDataLabelAlignment.auto
            : ChartDataLabelAlignment.top,
        series,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        chart,
        transposed,
        margin);
  } else {
    chartLocation2.x = _calculateRectPosition(
        chartLocation2.x,
        point.region,
        minus,
        dataLabel.labelAlignment == ChartDataLabelAlignment.top
            ? ChartDataLabelAlignment.auto
            : ChartDataLabelAlignment.top,
        series,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        chart,
        transposed,
        margin);
  }
  return chartLocation2;
}

///Setting datalabel region
void _calculateDataLabelRegion(
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    SfCartesianChart chart,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    bool isRangeSeries,
    Rect clipRect,
    Size textSize,
    Size textSize2,
    [_ChartLocation chartLocation3,
    _ChartLocation chartLocation4,
    Size textSize3,
    Size textSize4,
    XyDataSeries<dynamic, dynamic> series]) {
  Rect rect, rect2, rect3, rect4;
  final EdgeInsets margin = dataLabel.margin;
  rect = _calculateLabelRect(chartLocation, textSize, margin,
      dataLabel.color != null || dataLabel.useSeriesColor);
  rect = _validateRect(rect, clipRect);
  if (isRangeSeries) {
    rect2 = _calculateLabelRect(chartLocation2, textSize2, margin,
        dataLabel.color != null || dataLabel.useSeriesColor);
    rect2 = _validateRect(rect2, clipRect);
  }
  if (series._seriesType.contains('candle') ||
      series._seriesType.contains('hilo') &&
          (chartLocation3 != null || chartLocation4 != null)) {
    rect3 = _calculateLabelRect(chartLocation3, textSize3, margin,
        dataLabel.color != null || dataLabel.useSeriesColor);
    rect3 = _validateRect(rect3, clipRect);

    rect4 = _calculateLabelRect(chartLocation4, textSize4, margin,
        dataLabel.color != null || dataLabel.useSeriesColor);
    rect4 = _validateRect(rect4, clipRect);
  }
  if (dataLabel.color != null ||
      dataLabel.useSeriesColor ||
      (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
    final RRect fillRect =
        _calculatePaddedFillRect(rect, dataLabel.borderRadius, margin);
    point.labelLocation = _ChartLocation(
        fillRect.center.dx - textSize.width / 2,
        fillRect.center.dy - textSize.height / 2);
    point.dataLabelRegion = Rect.fromLTWH(point.labelLocation.x,
        point.labelLocation.y, textSize.width, textSize.height);
    if (margin == const EdgeInsets.all(0)) {
      point.labelFillRect = fillRect;
    } else {
      final Rect rect = fillRect.middleRect;
      if (series._seriesType == 'candle' &&
          chart._requireInvertedAxis &&
          point.close > point.high) {
        point.labelLocation = _ChartLocation(
            rect.left - rect.width - textSize.width,
            rect.top + rect.height / 2 - textSize.height / 2);
      } else if (series._seriesType == 'candle' &&
          !chart._requireInvertedAxis &&
          point.close > point.high) {
        point.labelLocation = _ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height + textSize.height);
      } else {
        point.labelLocation = _ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height / 2 - textSize.height / 2);
      }
      point.dataLabelRegion = Rect.fromLTWH(point.labelLocation.x,
          point.labelLocation.y, textSize.width, textSize.height);
      point.labelFillRect = _rectToRrect(rect, dataLabel.borderRadius);
    }
    if (isRangeSeries) {
      final RRect fillRect2 =
          _calculatePaddedFillRect(rect2, dataLabel.borderRadius, margin);
      point.labelLocation2 = _ChartLocation(
          fillRect2.center.dx - textSize2.width / 2,
          fillRect2.center.dy - textSize2.height / 2);
      point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2.x,
          point.labelLocation2.y, textSize2.width, textSize2.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect2 = fillRect2;
      } else {
        final Rect rect2 = fillRect2.middleRect;
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width / 2 - textSize2.width / 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
        point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2.x,
            point.labelLocation2.y, textSize2.width, textSize2.height);
        point.labelFillRect2 = _rectToRrect(rect2, dataLabel.borderRadius);
      }
    }
    if (series._seriesType.contains('candle') ||
        series._seriesType.contains('hilo') &&
            (rect3 != null || rect4 != null)) {
      final RRect fillRect3 =
          _calculatePaddedFillRect(rect3, dataLabel.borderRadius, margin);
      point.labelLocation3 = _ChartLocation(
          fillRect3.center.dx - textSize3.width / 2,
          fillRect3.center.dy - textSize3.height / 2);
      point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3.x,
          point.labelLocation3.y, textSize3.width, textSize3.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect3 = fillRect3;
      } else {
        final Rect rect3 = fillRect3.middleRect;
        point.labelLocation3 = _ChartLocation(
            rect3.left + rect3.width / 2 - textSize3.width / 2,
            rect3.top + rect3.height / 2 - textSize3.height / 2);
        point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3.x,
            point.labelLocation3.y, textSize3.width, textSize3.height);
        point.labelFillRect3 = _rectToRrect(rect3, dataLabel.borderRadius);
      }
      final RRect fillRect4 =
          _calculatePaddedFillRect(rect4, dataLabel.borderRadius, margin);
      point.labelLocation4 = _ChartLocation(
          fillRect4.center.dx - textSize4.width / 2,
          fillRect4.center.dy - textSize4.height / 2);
      point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4.x,
          point.labelLocation4.y, textSize4.width, textSize4.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect4 = fillRect4;
      } else {
        final Rect rect4 = fillRect4.middleRect;
        point.labelLocation4 = _ChartLocation(
            rect4.left + rect4.width / 2 - textSize4.width / 2,
            rect4.top + rect4.height / 2 - textSize4.height / 2);
        point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4.x,
            point.labelLocation4.y, textSize4.width, textSize4.height);
        point.labelFillRect4 = _rectToRrect(rect4, dataLabel.borderRadius);
      }
    }
  } else {
    if (series._seriesType == 'candle' &&
        chart._requireInvertedAxis &&
        point.close > point.high) {
      point.labelLocation = _ChartLocation(
          rect.left - rect.width - textSize.width - 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    } else if (series._seriesType == 'candle' &&
        !chart._requireInvertedAxis &&
        point.close > point.high) {
      point.labelLocation = _ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height + textSize.height / 2);
    } else {
      point.labelLocation = _ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    }
    point.dataLabelRegion = Rect.fromLTWH(point.labelLocation.x,
        point.labelLocation.y, textSize.width, textSize.height);
    if (isRangeSeries) {
      if (series._seriesType == 'candle' &&
          chart._requireInvertedAxis &&
          point.close > point.high) {
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width + textSize2.width + 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      } else if (series._seriesType == 'candle' &&
          !chart._requireInvertedAxis &&
          point.close > point.high) {
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width / 2 - textSize2.width / 2,
            rect2.top - rect2.height - textSize2.height);
      } else {
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width / 2 - textSize2.width / 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      }
      point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2.x,
          point.labelLocation2.y, textSize2.width, textSize2.height);
    }
    if (series._seriesType.contains('candle') ||
        series._seriesType.contains('hilo') &&
            (rect3 != null || rect4 != null)) {
      point.labelLocation3 = _ChartLocation(
          rect3.left + rect3.width / 2 - textSize3.width / 2,
          rect3.top + rect3.height / 2 - textSize3.height / 2);
      point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3.x,
          point.labelLocation3.y, textSize3.width, textSize3.height);
      point.labelLocation4 = _ChartLocation(
          rect4.left + rect4.width / 2 - textSize4.width / 2,
          rect4.top + rect4.height / 2 - textSize4.height / 2);
      point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4.x,
          point.labelLocation4.y, textSize4.width, textSize4.height);
    }
  }
}

double _calculatePathPosition(
    double labelLocation,
    ChartDataLabelAlignment position,
    Size size,
    double borderWidth,
    CartesianSeries<dynamic, dynamic> series,
    int index,
    bool inverted,
    _ChartLocation point,
    SfCartesianChart chart,
    CartesianChartPoint<dynamic> currentPoint,
    Size markerSize) {
  const double padding = 5;
  final bool needFill = series.dataLabelSettings.color != null ||
      series.dataLabelSettings.color != Colors.transparent ||
      series.dataLabelSettings.useSeriesColor;
  final num fillSpace = needFill ? padding : 0;
  if (series._seriesType.contains('area') &&
      series._seriesType != 'rangearea' &&
      series._yAxis.isInversed) {
    position = position == ChartDataLabelAlignment.top
        ? ChartDataLabelAlignment.bottom
        : (position == ChartDataLabelAlignment.bottom
            ? ChartDataLabelAlignment.top
            : position);
  }
  position = (chart._chartSeries.visibleSeries.length == 1 &&
          (series._seriesType == 'stackedarea100' ||
              series._seriesType == 'stackedline100') &&
          position == ChartDataLabelAlignment.auto)
      ? ChartDataLabelAlignment.bottom
      : position;
  switch (position) {
    case ChartDataLabelAlignment.top:
    case ChartDataLabelAlignment.outer:
      labelLocation = labelLocation -
          markerSize.height -
          borderWidth -
          (size.height / 2) -
          padding -
          fillSpace;
      break;
    case ChartDataLabelAlignment.bottom:
      labelLocation = labelLocation +
          markerSize.height +
          borderWidth +
          (size.height / 2) +
          padding +
          fillSpace;
      break;
    case ChartDataLabelAlignment.auto:
      labelLocation = _calculatePathActualPosition(
          series,
          size,
          index,
          inverted,
          borderWidth,
          point,
          chart,
          currentPoint,
          series._yAxis.isInversed);
      break;
    case ChartDataLabelAlignment.middle:
      break;
  }
  return labelLocation;
}

///Below method is for dataLabel alignment calculation
double _calculateAlignment(double value, double labelLocation,
    ChartAlignment alignment, bool isMinus, bool inverted) {
  switch (alignment) {
    case ChartAlignment.far:
      labelLocation = !inverted
          ? (isMinus ? labelLocation + value : labelLocation - value)
          : (isMinus ? labelLocation - value : labelLocation + value);
      break;
    case ChartAlignment.near:
      labelLocation = !inverted
          ? (isMinus ? labelLocation - value : labelLocation + value)
          : (isMinus ? labelLocation + value : labelLocation - value);
      break;
    case ChartAlignment.center:
      labelLocation = labelLocation;
      break;
  }
  return labelLocation;
}

///Calculate label position for non rect series
double _calculatePathActualPosition(
    CartesianSeries<dynamic, dynamic> series,
    Size size,
    int index,
    bool inverted,
    double borderWidth,
    _ChartLocation point,
    SfCartesianChart chart,
    CartesianChartPoint<dynamic> currentPoint,
    bool inversed) {
  double yLocation;
  bool isBottom, isOverLap = true;
  Rect labelRect;
  int positionIndex;
  final ChartDataLabelAlignment position =
      _getActualPathDataLabelAlignment(series, index, inversed);
  isBottom = position == ChartDataLabelAlignment.bottom;
  final List<String> dataLabelPosition = List<String>(5);
  dataLabelPosition[0] = 'DataLabelPosition.Outer';
  dataLabelPosition[1] = 'DataLabelPosition.Top';
  dataLabelPosition[2] = 'DataLabelPosition.Bottom';
  dataLabelPosition[3] = 'DataLabelPosition.Middle';
  dataLabelPosition[4] = 'DataLabelPosition.Auto';
  positionIndex = dataLabelPosition.indexOf(position.toString()).toInt();
  while (isOverLap && positionIndex < 4) {
    yLocation = _calculatePathPosition(
        point.y.toDouble(),
        position,
        size,
        borderWidth,
        series,
        index,
        inverted,
        point,
        chart,
        currentPoint,
        Size(
            series.markerSettings.width / 2, series.markerSettings.height / 2));
    labelRect = _calculateLabelRect(
        _ChartLocation(point.x, yLocation),
        size,
        series.dataLabelSettings.margin,
        series.dataLabelSettings.color != null ||
            series.dataLabelSettings.useSeriesColor);
    isOverLap = labelRect.top < 0 ||
        ((labelRect.top + labelRect.height) >
            chart._chartAxis._axisClipRect.height) ||
        _isCollide(labelRect, chart._chartState.renderDatalabelRegions);
    positionIndex = isBottom ? positionIndex - 1 : positionIndex + 1;
    isBottom = false;
  }
  return yLocation;
}

/// Finding the label position for non rect series
ChartDataLabelAlignment _getActualPathDataLabelAlignment(
    CartesianSeries<dynamic, dynamic> series, int index, bool inversed) {
  final List<CartesianChartPoint<dynamic>> points = series._dataPoints;
  final num yValue = points[index].yValue;
  final CartesianChartPoint<dynamic> nextPoint =
      points.length - 1 > index ? points[index + 1] : null;
  final CartesianChartPoint<dynamic> previousPoint =
      index > 0 ? points[index - 1] : null;
  ChartDataLabelAlignment position;
  if (series._seriesType == 'bubble' || index == points.length - 1) {
    position = ChartDataLabelAlignment.top;
  } else {
    if (index == 0) {
      position = (!nextPoint.isVisible ||
              yValue > nextPoint.yValue ||
              (yValue < nextPoint.yValue && inversed))
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else if (index == points.length - 1) {
      position = (!previousPoint.isVisible ||
              yValue > previousPoint.yValue ||
              (yValue < previousPoint.yValue && inversed))
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else {
      if (!nextPoint.isVisible && !previousPoint.isVisible) {
        position = ChartDataLabelAlignment.top;
      } else if (!nextPoint.isVisible) {
        position = (nextPoint.yValue > yValue || previousPoint.yValue > yValue)
            ? ChartDataLabelAlignment.bottom
            : ChartDataLabelAlignment.top;
      } else {
        final num slope = (nextPoint.yValue - previousPoint.yValue) / 2;
        final num intersectY =
            (slope * index) + (nextPoint.yValue - (slope * (index + 1)));
        position = !inversed
            ? intersectY < yValue
                ? ChartDataLabelAlignment.top
                : ChartDataLabelAlignment.bottom
            : intersectY < yValue
                ? ChartDataLabelAlignment.bottom
                : ChartDataLabelAlignment.top;
      }
    }
  }
  return position;
}

ChartDataLabelAlignment _getPosition(int position) {
  ChartDataLabelAlignment dataLabelPosition;
  switch (position) {
    case 0:
      dataLabelPosition = ChartDataLabelAlignment.outer;
      break;
    case 1:
      dataLabelPosition = ChartDataLabelAlignment.top;
      break;
    case 2:
      dataLabelPosition = ChartDataLabelAlignment.bottom;
      break;
    case 3:
      dataLabelPosition = ChartDataLabelAlignment.middle;
      break;
    case 4:
      dataLabelPosition = ChartDataLabelAlignment.auto;
      break;
  }
  return dataLabelPosition;
}

/// getting label rect
Rect _calculateLabelRect(
    _ChartLocation location, Size textSize, EdgeInsets margin, bool needRect) {
  return needRect
      ? Rect.fromLTWH(
          location.x - (textSize.width / 2) - margin.left,
          location.y - (textSize.height / 2) - margin.top,
          textSize.width + margin.left + margin.right,
          textSize.height + margin.top + margin.bottom)
      : Rect.fromLTWH(location.x - (textSize.width / 2),
          location.y - (textSize.height / 2), textSize.width, textSize.height);
}

/// Below method is for Rendering data label
void _drawDataLabel(
    Canvas canvas,
    CartesianSeries<dynamic, dynamic> series,
    SfCartesianChart chart,
    DataLabelSettings dataLabel,
    CartesianChartPoint<dynamic> point,
    int index,
    Animation<double> dataLabelAnimation) {
  final double opacity =
      dataLabelAnimation != null ? dataLabelAnimation.value : 1;
  DataLabelRenderArgs dataLabelArgs;
  ChartTextStyle dataLabelStyle;
  String label = point.dataLabelMapper ?? point.label;
  dataLabelStyle = dataLabel.textStyle;
  if (chart.onDataLabelRender != null) {
    dataLabelArgs = DataLabelRenderArgs();
    dataLabelArgs.text = label;
    dataLabelArgs.textStyle = dataLabelStyle;
    dataLabelArgs.series = series;
    dataLabelArgs.dataPoints = series._dataPoints;
    dataLabelArgs.pointIndex = index;
    chart.onDataLabelRender(dataLabelArgs);
    label = point.label = dataLabelArgs.text;
    dataLabelStyle = dataLabelArgs.textStyle;
    index = dataLabelArgs.pointIndex;
  }
  if (label != null &&
      point != null &&
      point.isVisible &&
      point.isGap != true &&
      _isLabelWithinRange(series, point)) {
    final ChartTextStyle font =
        (dataLabelStyle == null) ? ChartTextStyle() : dataLabelStyle;
    final Color fontColor = font.color != null
        ? font.color
        : _getDataLabelSaturationColor(point, series, chart);
    final Rect labelRect = (point.labelFillRect != null)
        ? Rect.fromLTWH(point.labelFillRect.left, point.labelFillRect.top,
            point.labelFillRect.width, point.labelFillRect.height)
        : Rect.fromLTWH(point.labelLocation.x, point.labelLocation.y,
            point.dataLabelRegion.width, point.dataLabelRegion.height);
    final bool isDatalabelCollide =
        _isCollide(labelRect, chart._chartState.renderDatalabelRegions);
    if (label.isNotEmpty && isDatalabelCollide
        ? dataLabel.labelIntersectAction == LabelIntersectAction.none
        : true) {
      final ChartTextStyle textStyle = ChartTextStyle(
          color: fontColor.withOpacity(opacity),
          fontSize: font.fontSize,
          fontFamily: font.fontFamily,
          fontStyle: font.fontStyle,
          fontWeight: font.fontWeight);
      _drawDataLabelPath(canvas, series, index, dataLabel, point, textStyle,
          opacity, label, chart);
      chart._chartState.renderDatalabelRegions.add(labelRect);
    }
  }
}

///Draw the datalabel text and datalabel rect
void _drawDataLabelPath(
    Canvas canvas,
    CartesianSeries<dynamic, dynamic> series,
    int index,
    DataLabelSettings dataLabel,
    CartesianChartPoint<dynamic> point,
    ChartTextStyle textStyle,
    double opacity,
    String label,
    [SfCartesianChart chart]) {
  final String label2 = point.dataLabelMapper ?? point.label2;
  final String label3 = point.dataLabelMapper ?? point.label3;
  final String label4 = point.dataLabelMapper ?? point.label4;
  final bool isRangeSeries = series._seriesType.contains('range') ||
      series._seriesType.contains('hilo') ||
      series._seriesType.contains('candle');
  if (dataLabel.color != null ||
      dataLabel.useSeriesColor ||
      (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
    final RRect fillRect = point.labelFillRect;
    final Path path = Path();
    path.addRRect(fillRect);
    final RRect fillRect2 = point.labelFillRect2;
    final Path path2 = Path();
    if (isRangeSeries) {
      path2.addRRect(fillRect2);
    }
    final RRect fillRect3 = point.labelFillRect3;
    final Path path3 = Path();
    final RRect fillRect4 = point.labelFillRect4;
    final Path path4 = Path();
    if (series._seriesType.contains('hilo') ||
        series._seriesType.contains('candle')) {
      path3.addRRect(fillRect3);
      path4.addRRect(fillRect4);
    }
    if (dataLabel.borderColor != null && dataLabel.borderWidth > 0) {
      final Paint strokePaint = Paint()
        ..color = dataLabel.borderColor.withOpacity(
            (opacity - (1 - dataLabel.opacity)) < 0
                ? 0
                : opacity - (1 - dataLabel.opacity))
        ..strokeWidth = dataLabel.borderWidth
        ..style = PaintingStyle.stroke;
      dataLabel.borderWidth == 0
          ? strokePaint.color = Colors.transparent
          : strokePaint.color = strokePaint.color;
      canvas.drawPath(path, strokePaint);
      if (isRangeSeries) {
        canvas.drawPath(path2, strokePaint);
      }
    }
    if (dataLabel.color != null || dataLabel.useSeriesColor) {
      final Paint paint = Paint()
        ..color =
            (dataLabel.color ?? (point.pointColorMapper ?? series._seriesColor))
                .withOpacity((opacity - (1 - dataLabel.opacity)) < 0
                    ? 0
                    : opacity - (1 - dataLabel.opacity))
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
      if (isRangeSeries) {
        canvas.drawPath(path2, paint);
      }
    }
  }

  series.drawDataLabel(
      index,
      canvas,
      label,
      dataLabel.angle != 0
          ? point.dataLabelRegion.center.dx
          : point.labelLocation.x,
      dataLabel.angle != 0
          ? point.dataLabelRegion.center.dy
          : point.labelLocation.y,
      dataLabel.angle,
      textStyle);

  if (isRangeSeries) {
    series.drawDataLabel(index, canvas, label2, point.labelLocation2.x,
        point.labelLocation2.y, dataLabel.angle, textStyle);
    if (series._seriesType == 'hiloopenclose' &&
        (label3 != null &&
                label4 != null &&
                (point.labelLocation3.y - point.labelLocation4.y).round() >=
                    8 ||
            (point.labelLocation4.x - point.labelLocation3.x).round() >= 15)) {
      series.drawDataLabel(index, canvas, label3, point.labelLocation3.x,
          point.labelLocation3.y, dataLabel.angle, textStyle);
      series.drawDataLabel(index, canvas, label4, point.labelLocation4.x,
          point.labelLocation4.y, dataLabel.angle, textStyle);
    } else if (label3 != null &&
        label4 != null &&
        ((point.labelLocation3.y - point.labelLocation4.y).round() >= 8 ||
            (point.labelLocation4.x - point.labelLocation3.x).round() >= 15)) {
      final Color fontColor = _getOpenCloseDataLabelColor(point, series, chart);
      final ChartTextStyle textStyleOpenClose = ChartTextStyle(
          color: fontColor.withOpacity(opacity),
          fontSize: textStyle.fontSize,
          fontFamily: textStyle.fontFamily,
          fontStyle: textStyle.fontStyle,
          fontWeight: textStyle.fontWeight);
      if ((point.labelLocation2.y - point.labelLocation3.y).abs() >= 8 ||
          (point.labelLocation2.x - point.labelLocation3.x).abs() >= 8) {
        series.drawDataLabel(index, canvas, label3, point.labelLocation3.x,
            point.labelLocation3.y, dataLabel.angle, textStyleOpenClose);
      }
      if ((point.labelLocation.y - point.labelLocation4.y).abs() >= 8 ||
          (point.labelLocation.x - point.labelLocation4.x).abs() >= 8) {
        series.drawDataLabel(index, canvas, label4, point.labelLocation4.x,
            point.labelLocation4.y, dataLabel.angle, textStyleOpenClose);
      }
    }
  }
}

/// Following method returns the data label text
String _getLabelText(dynamic labelValue,
    CartesianSeries<dynamic, dynamic> series, SfCartesianChart chart) {
  if (labelValue.toString().split('.').length > 1) {
    final String str = labelValue.toString();
    final List<dynamic> list = str.split('.');
    labelValue = double.parse(labelValue.toStringAsFixed(6));
    if (list[1] == '0' ||
        list[1] == '00' ||
        list[1] == '000' ||
        list[1] == '0000' ||
        list[1] == '00000' ||
        list[1] == '000000') {
      labelValue = labelValue.round();
    }
  }
  final dynamic yAxis = series._yAxis;
  final dynamic value = yAxis.numberFormat != null
      ? yAxis.numberFormat.format(labelValue)
      : labelValue;
  return (yAxis.labelFormat != null && yAxis.labelFormat != '')
      ? yAxis.labelFormat.replaceAll(RegExp('{value}'), value.toString())
      : value.toString();
}

/// Calculating rect position for dataLabel
double _calculateRectPosition(
    double labelLocation,
    Rect rect,
    bool isMinus,
    ChartDataLabelAlignment position,
    CartesianSeries<dynamic, dynamic> series,
    Size textSize,
    double borderWidth,
    int index,
    _ChartLocation point,
    SfCartesianChart chart,
    bool inverted,
    EdgeInsets margin) {
  double padding;
  padding = series._seriesType.contains('hilo') ||
          series._seriesType.contains('candle') ||
          series._seriesType.contains('rangecolumn')
      ? 2
      : 5;
  final bool needFill = series.dataLabelSettings.color != null ||
      series.dataLabelSettings.color != Colors.transparent ||
      series.dataLabelSettings.useSeriesColor;
  final double textLength = !inverted ? textSize.height : textSize.width;
  final double extraSpace =
      borderWidth + textLength / 2 + padding + (needFill ? padding : 0);
  if (series._seriesType.contains('stack')) {
    position = position == ChartDataLabelAlignment.outer
        ? ChartDataLabelAlignment.top
        : position;
  }

  /// Locating the data label based on position
  switch (position) {
    case ChartDataLabelAlignment.bottom:
      labelLocation = !inverted
          ? (isMinus
              ? (labelLocation - rect.height + extraSpace)
              : (labelLocation + rect.height - extraSpace))
          : (isMinus
              ? (labelLocation + rect.width - extraSpace)
              : (labelLocation - rect.width + extraSpace));
      break;
    case ChartDataLabelAlignment.middle:
      labelLocation = !inverted
          ? (isMinus
              ? labelLocation - (rect.height / 2)
              : labelLocation + (rect.height / 2))
          : (isMinus
              ? labelLocation + (rect.width / 2)
              : labelLocation - (rect.width / 2));
      break;
    case ChartDataLabelAlignment.auto:
      labelLocation = _calculateRectActualPosition(labelLocation, rect, isMinus,
          series, textSize, index, point, inverted, borderWidth, chart, margin);
      break;
    default:
      labelLocation = _calculateTopAndOuterPosition(
          textSize,
          labelLocation,
          rect,
          position,
          series,
          index,
          extraSpace,
          isMinus,
          point,
          inverted,
          borderWidth,
          chart);
      break;
  }
  return labelLocation;
}

/// Calculating the label location if position is given as auto
double _calculateRectActualPosition(
    double labelLocation,
    Rect rect,
    bool minus,
    CartesianSeries<dynamic, dynamic> series,
    Size textSize,
    int index,
    _ChartLocation point,
    bool inverted,
    double borderWidth,
    SfCartesianChart chart,
    EdgeInsets margin) {
  double location;
  Rect labelRect;
  bool isOverLap = true;
  int position = 0;
  final int finalPosition = series._seriesType.contains('range') ? 2 : 4;
  while (isOverLap && position < finalPosition) {
    location = _calculateRectPosition(
        labelLocation,
        rect,
        minus,
        _getPosition(position),
        series,
        textSize,
        borderWidth,
        index,
        point,
        chart,
        inverted,
        margin);
    if (!inverted) {
      labelRect = _calculateLabelRect(
          _ChartLocation(point.x, location),
          textSize,
          margin,
          series.dataLabelSettings.color != null ||
              series.dataLabelSettings.useSeriesColor);
      isOverLap = labelRect.top < 0 ||
          labelRect.top > chart._chartAxis._axisClipRect.height ||
          _isCollide(labelRect, chart._chartState.renderDatalabelRegions);
    } else {
      labelRect = _calculateLabelRect(
          _ChartLocation(location, point.y),
          textSize,
          margin,
          series.dataLabelSettings.color != null ||
              series.dataLabelSettings.useSeriesColor);
      isOverLap = labelRect.left < 0 ||
          labelRect.left + labelRect.width >
              chart._chartAxis._axisClipRect.right ||
          _isCollide(labelRect, chart._chartState.renderDatalabelRegions);
    }
    series._dataPoints[index].dataLabelSaturationRegionInside =
        isOverLap || series._dataPoints[index].dataLabelSaturationRegionInside
            ? true
            : false;
    position++;
  }
  return location;
}

///calculation for top and outer position of datalabel for rect series
double _calculateTopAndOuterPosition(
    Size textSize,
    double location,
    Rect rect,
    ChartDataLabelAlignment position,
    CartesianSeries<dynamic, dynamic> series,
    int index,
    double extraSpace,
    bool isMinus,
    _ChartLocation point,
    bool inverted,
    double borderWidth,
    SfCartesianChart chart) {
  final num markerHeight =
      series.markerSettings.isVisible ? series.markerSettings.height / 2 : 0;
  if (((isMinus && !series._seriesType.contains('range')) &&
          position == ChartDataLabelAlignment.top) ||
      ((!isMinus || series._seriesType.contains('range')) &&
          position == ChartDataLabelAlignment.outer)) {
    location = !inverted
        ? location - extraSpace - markerHeight
        : location + extraSpace + markerHeight;
  } else {
    location = !inverted
        ? location + extraSpace + markerHeight
        : location - extraSpace - markerHeight;
  }
  return location;
}

/// Add padding for fill rect (if datalabel fill color is given)
RRect _calculatePaddedFillRect(Rect rect, num radius, EdgeInsets margin) {
  rect = Rect.fromLTRB(rect.left - margin.left, rect.top - margin.top,
      rect.right + margin.right, rect.bottom + margin.bottom);

  return _rectToRrect(rect, radius);
}

/// Converting rect into rounded rect
RRect _rectToRrect(Rect rect, num radius) => RRect.fromRectAndCorners(rect,
    topLeft: Radius.elliptical(radius, radius),
    topRight: Radius.elliptical(radius, radius),
    bottomLeft: Radius.elliptical(radius, radius),
    bottomRight: Radius.elliptical(radius, radius));

/// Checking the condition whether data Label has been exist in the clip rect
Rect _validateRect(Rect rect, Rect clipRect) {
  const int padding = 5;
  num left, top;
  left = rect.left < clipRect.left ? clipRect.left + padding : rect.left;
  top = double.parse(rect.top.toStringAsFixed(2)) < clipRect.top
      ? clipRect.top + padding
      : rect.top;
  left -= ((double.parse(left.toStringAsFixed(2)) + rect.width) >
          clipRect.right)
      ? (double.parse(left.toStringAsFixed(2)) + rect.width) - clipRect.right
      : 0;
  top -= (double.parse(top.toStringAsFixed(2)) + rect.height) > clipRect.bottom
      ? (double.parse(top.toStringAsFixed(2)) + rect.height) -
          clipRect.bottom +
          padding
      : 0;
  left = left < clipRect.left ? clipRect.left + padding : left;
  rect = Rect.fromLTWH(left, top, rect.width, rect.height);
  return rect;
}

bool _isLabelWithinRange(
    XyDataSeries<dynamic, dynamic> series, CartesianChartPoint<dynamic> point) {
  bool withInRange = true;
  if (!(series._yAxis is LogarithmicAxis)) {
    withInRange = _withIn(point.xValue, series._xAxis._visibleRange) &&
        (series._seriesType.contains('range') || series._seriesType == 'hilo'
            ? (_withIn(point.low, series._yAxis._visibleRange) &&
                _withIn(point.high, series._yAxis._visibleRange))
            : series._seriesType == 'hiloopenclose' ||
                    series._seriesType.contains('candle')
                ? (_withIn(point.low, series._yAxis._visibleRange) &&
                    _withIn(point.high, series._yAxis._visibleRange) &&
                    _withIn(point.open, series._yAxis._visibleRange) &&
                    _withIn(point.close, series._yAxis._visibleRange))
                : _withIn(point.yValue, series._yAxis._visibleRange));
  }
  return withInRange;
}
