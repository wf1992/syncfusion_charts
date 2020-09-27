part of charts;

class _ChartSeries {
  _ChartSeries();
  SfCartesianChart chart;
  bool isStacked100;
  int paletteIndex = 0;

  /// Contains the visible series for chart
  List<ChartSeries<dynamic, dynamic>> visibleSeries;
  List<_ClusterStackedItemInfo> clusterStackedItemInfo;

  void _processData() {
    final List<ChartSeries<dynamic, dynamic>> seriesList = visibleSeries;
    isStacked100 = false;
    paletteIndex = 0;
    _findAreaType(seriesList);
    if (chart.indicators.isNotEmpty) {
      _populateDataPoints(seriesList);
      _calculateIndicators();
      chart._chartAxis?._calculateVisibleAxes();
      _findMinMax(seriesList);
      _renderTrendline();
    } else {
      chart._chartAxis?._calculateVisibleAxes();
      _populateDataPoints(seriesList);
    }
    _calculateStackedValues(_findSeriesCollection(chart));
    _renderTrendline();
  }

  /// Find the data points for each series
  void _populateDataPoints(List<CartesianSeries<dynamic, dynamic>> seriesList) {
    for (CartesianSeries<dynamic, dynamic> series in seriesList) {
      final dynamic xValue = series.xValueMapper;
      final dynamic yValue = series.yValueMapper;
      final dynamic sortField = series.sortFieldValueMapper;
      final dynamic _pointColor = series.pointColorMapper;
      final dynamic _bubbleSize = series.sizeValueMapper;
      final dynamic _pointText = series.dataLabelMapper;
      final dynamic _highValue = series.highValueMapper;
      final dynamic _lowValue = series.lowValueMapper;
      CartesianChartPoint<dynamic> currentPoint;
      series._dataPoints = <CartesianChartPoint<dynamic>>[];
      series._xValues = <dynamic>[];
      if (!isStacked100 && series._seriesType.contains('100')) {
        isStacked100 = true;
      }
      final bool needSorting = series.sortingOrder != SortingOrder.none &&
          series.sortFieldValueMapper != null;
      if (series.dataSource != null) {
        for (int pointIndex = 0;
            pointIndex < series.dataSource.length;
            pointIndex++) {
          final dynamic xVal = xValue(pointIndex);
          final dynamic yVal = (series is RangeColumnSeries ||
                  series is RangeAreaSeries ||
                  series is HiloSeries ||
                  series is HiloOpenCloseSeries ||
                  series is CandleSeries)
              ? null
              : yValue(pointIndex);
          if (xVal != null) {
            dynamic sortVal,
                pointColor,
                bubbleSize,
                pointText,
                highValue,
                lowValue,
                openValue,
                volumeValue,
                closeValue;
            if (series.sortFieldValueMapper != null) {
              sortVal = sortField(pointIndex);
            }
            series._dataPoints.add(CartesianChartPoint<dynamic>(xVal, yVal));
            series._xValues.add(xVal);
            currentPoint = series._dataPoints[series._dataPoints.length - 1];
            if (series is BubbleSeries) {
              bubbleSize = series.sizeValueMapper == null
                  ? 4
                  : _bubbleSize(pointIndex) ?? 4;
              currentPoint.bubbleSize = bubbleSize.toDouble();
              series._maxSize ??= currentPoint.bubbleSize;
              series._minSize ??= currentPoint.bubbleSize;
              series._maxSize =
                  math.max(series._maxSize, currentPoint.bubbleSize);
              series._minSize =
                  math.min(series._minSize, currentPoint.bubbleSize);
            }
            if (series.sizeValueMapper != null) {
              bubbleSize = _bubbleSize(pointIndex);
              series._dataPoints[series._dataPoints.length - 1].bubbleSize =
                  (bubbleSize != null) ? bubbleSize.toDouble() : bubbleSize;
            }
            if (series.pointColorMapper != null) {
              pointColor = _pointColor(pointIndex);
              series._dataPoints[series._dataPoints.length - 1]
                  .pointColorMapper = pointColor;
            }
            if (series.dataLabelMapper != null) {
              pointText = _pointText(pointIndex);
              series._dataPoints[series._dataPoints.length - 1]
                  .dataLabelMapper = pointText;
            }

            /// for range series
            if (series.highValueMapper != null) {
              highValue = _highValue(pointIndex);
              series._dataPoints[series._dataPoints.length - 1].high =
                  highValue;
            }
            if (series.lowValueMapper != null) {
              lowValue = _lowValue(pointIndex);
              series._dataPoints[series._dataPoints.length - 1].low = lowValue;
            }

            if (series is _FinancialSeriesBase) {
              final dynamic _openValue = series.openValueMapper;
              final dynamic _closeValue = series.closeValueMapper;
              if (series.openValueMapper != null) {
                openValue = _openValue(pointIndex);
                series._dataPoints[series._dataPoints.length - 1].open =
                    openValue;
              }
              if (series is HiloOpenCloseSeries) {
                final dynamic _volumeValue = series.volumeValueMapper;
                if (series.volumeValueMapper != null) {
                  volumeValue = _volumeValue(pointIndex);
                  series._dataPoints[series._dataPoints.length - 1].volume =
                      volumeValue;
                }
              }
              if (series.closeValueMapper != null) {
                closeValue = _closeValue(pointIndex);
                series._dataPoints[series._dataPoints.length - 1].close =
                    closeValue;
              }
            }

            if (series.sortingOrder != SortingOrder.none && sortVal != null)
              series._dataPoints[series._dataPoints.length - 1].sortValue =
                  sortVal;

            if (series._seriesType.contains('range') ||
                    series._seriesType.contains('hilo') ||
                    series._seriesType.contains('candle')
                ? series._seriesType == 'hiloopenclose' ||
                        series._seriesType.contains('candle')
                    ? (currentPoint.low == null ||
                        currentPoint.high == null ||
                        currentPoint.open == null ||
                        currentPoint.close == null)
                    : (currentPoint.low == null || currentPoint.high == null)
                : currentPoint.y == null) {
              if (series is XyDataSeries)
                series.calculateEmptyPointValue(pointIndex, currentPoint);
            }

            /// Below lines for changing high, low values based on input
            if ((series._seriesType.contains('range') ||
                    series._seriesType.contains('hilo') ||
                    series._seriesType.contains('candle')) &&
                currentPoint.isVisible) {
              final num high = currentPoint.high;
              final num low = currentPoint.low;
              currentPoint.high = math.max<num>(high, low);
              currentPoint.low = math.min<num>(high, low);
            }
            if (series._xAxis != null &&
                series._yAxis != null &&
                !needSorting &&
                chart.indicators.isEmpty) {
              _findMinMaxValue(series._xAxis, series, currentPoint, pointIndex,
                  series.dataSource.length);
            }
          }
        }
        if (needSorting) {
          _sortDataSource(series);
          if (chart.indicators.isEmpty) {
            _findSeriesMinMax(series);
          }
        }
      }
    }
  }

  void _findMinMaxValue(
      ChartAxis axis,
      CartesianSeries<dynamic, dynamic> series,
      CartesianChartPoint<dynamic> currentPoint,
      int pointIndex,
      int dataLength) {
    if (series._visible) {
      if (axis is NumericAxis) {
        axis._findAxisMinMax(series, currentPoint, pointIndex, dataLength);
      } else if (axis is CategoryAxis) {
        axis._findAxisMinMax(series, currentPoint, pointIndex, dataLength);
      } else if (axis is DateTimeAxis) {
        axis._findAxisMinMax(series, currentPoint, pointIndex, dataLength);
      } else if (axis is LogarithmicAxis) {
        axis._findAxisMinMax(series, currentPoint, pointIndex, dataLength);
      }
    }
  }

  void _findSeriesMinMax(CartesianSeries<dynamic, dynamic> series) {
    final dynamic axis = series._xAxis;
    if (series._visible) {
      for (int pointIndex = 0;
          pointIndex < series._dataPoints.length;
          pointIndex++) {
        _findMinMaxValue(axis, series, series._dataPoints[pointIndex],
            pointIndex, series._dataPoints.length);
      }
    }
  }

  void _findMinMax(List<CartesianSeries<dynamic, dynamic>> seriesCollection) {
    for (int seriesIndex = 0;
        seriesIndex < seriesCollection.length;
        seriesIndex++) {
      _findSeriesMinMax(seriesCollection[seriesIndex]);
    }
  }

  void _renderTrendline() {
    for (CartesianSeries<dynamic, dynamic> series in visibleSeries) {
      if (series.trendlines != null) {
        for (Trendline trendline in series.trendlines) {
          trendline._isNeedRender = trendline._visible == true &&
              series._visible &&
              (trendline.type == TrendlineType.polynomial
                  ? (trendline.polynomialOrder >= 2 &&
                      trendline.polynomialOrder <= 6)
                  : trendline.type == TrendlineType.movingAverage
                      ? (trendline.period >= 2 &&
                          trendline.period <= series.dataSource.length - 1)
                      : true);
          if (trendline._isNeedRender) {
            trendline._setDataSource(series, chart);
          }
        }
      }
    }
  }

  /// Sort the dataSource
  void _sortDataSource(CartesianSeries<dynamic, dynamic> series) {
    series._dataPoints.sort(
        // ignore: missing_return
        (CartesianChartPoint<dynamic> firstPoint,
            CartesianChartPoint<dynamic> secondPoint) {
      if (series.sortingOrder == SortingOrder.ascending) {
        return (firstPoint.sortValue == null)
            ? -1
            : (secondPoint.sortValue == null
                ? 1
                : (firstPoint.sortValue is String
                    ? firstPoint.sortValue
                        .toLowerCase()
                        .compareTo(secondPoint.sortValue.toLowerCase())
                    : firstPoint.sortValue.compareTo(secondPoint.sortValue)));
      } else if (series.sortingOrder == SortingOrder.descending) {
        return (firstPoint.sortValue == null)
            ? 1
            : (secondPoint.sortValue == null
                ? -1
                : (firstPoint.sortValue is String
                    ? secondPoint.sortValue
                        .toLowerCase()
                        .compareTo(firstPoint.sortValue.toLowerCase())
                    : secondPoint.sortValue.compareTo(firstPoint.sortValue)));
      }
    });
  }

  void _calculateStackedValues(
      List<CartesianSeries<dynamic, dynamic>> seriesCollection) {
    String groupName = ' ';
    List<_StackingInfo> positiveValues;
    List<_StackingInfo> negativeValues;
    if (isStacked100) {
      _calculateStackingPercentage(seriesCollection);
    }

    chart._chartSeries.clusterStackedItemInfo = <_ClusterStackedItemInfo>[];
    for (int i = 0; i < seriesCollection.length; i++) {
      final CartesianSeries<dynamic, dynamic> series = seriesCollection[i];
      if (series is _StackedSeriesBase) {
        if (series._dataPoints.isNotEmpty) {
          groupName = (series._seriesType.contains('stackedarea'))
              ? 'stackedareagroup'
              : (series.groupName ?? 'series ' + i.toString());
          final _StackedItemInfo stackedItemInfo = _StackedItemInfo(i, series);
          if (chart._chartSeries.clusterStackedItemInfo.isNotEmpty) {
            for (int k = 0;
                k < chart._chartSeries.clusterStackedItemInfo.length;
                k++) {
              final _ClusterStackedItemInfo clusterStackedItemInfo =
                  chart._chartSeries.clusterStackedItemInfo[k];
              if (clusterStackedItemInfo.stackName == groupName) {
                clusterStackedItemInfo.stackedItemInfo.add(stackedItemInfo);
                break;
              } else if (k ==
                  chart._chartSeries.clusterStackedItemInfo.length - 1) {
                chart._chartSeries.clusterStackedItemInfo.add(
                    _ClusterStackedItemInfo(
                        groupName, <_StackedItemInfo>[stackedItemInfo]));
                break;
              }
            }
          } else {
            chart._chartSeries.clusterStackedItemInfo.add(
                _ClusterStackedItemInfo(
                    groupName, <_StackedItemInfo>[stackedItemInfo]));
          }

          series._stackingValues = <_StackedValues>[];
          _StackingInfo currentPositiveStackInfo;

          if (positiveValues == null || negativeValues == null) {
            positiveValues = <_StackingInfo>[];
            currentPositiveStackInfo = _StackingInfo(groupName, <double>[]);
            positiveValues.add(currentPositiveStackInfo);
            negativeValues = <_StackingInfo>[];
            negativeValues.add(_StackingInfo(groupName, <double>[]));
          }
          _addStackingValues(series, isStacked100, positiveValues,
              negativeValues, currentPositiveStackInfo, groupName);
        }
      }
    }
  }

  void _addStackingValues(
      _StackedSeriesBase<dynamic, dynamic> series,
      bool isStacked100,
      List<_StackingInfo> positiveValues,
      List<_StackingInfo> negativeValues,
      _StackingInfo currentPositiveStackInfo,
      String groupName) {
    num lastValue, value;
    CartesianChartPoint<dynamic> point;
    _StackingInfo currentNegativeStackInfo;
    final List<double> startValues = <double>[];
    final List<double> endValues = <double>[];
    for (int j = 0; j < series._dataPoints.length; j++) {
      point = series._dataPoints[j];
      value = point.y;
      if (positiveValues.isNotEmpty) {
        for (int k = 0; k < positiveValues.length; k++) {
          if (groupName == positiveValues[k].groupName) {
            currentPositiveStackInfo = positiveValues[k];
            break;
          } else if (k == positiveValues.length - 1) {
            currentPositiveStackInfo = _StackingInfo(groupName, <double>[]);
            positiveValues.add(currentPositiveStackInfo);
          }
        }
      }
      if (negativeValues.isNotEmpty) {
        for (int k = 0; k < negativeValues.length; k++) {
          if (groupName == negativeValues[k].groupName) {
            currentNegativeStackInfo = negativeValues[k];
            break;
          } else if (k == negativeValues.length - 1) {
            currentNegativeStackInfo = _StackingInfo(groupName, <double>[]);
            negativeValues.add(currentNegativeStackInfo);
          }
        }
      }
      if (currentPositiveStackInfo._stackingValues != null) {
        final int length = currentPositiveStackInfo._stackingValues.length;
        if (length == 0 || j > length - 1) {
          currentPositiveStackInfo._stackingValues.add(0);
        }
      }
      if (currentNegativeStackInfo._stackingValues != null) {
        final int length = currentNegativeStackInfo._stackingValues.length;
        if (length == 0 || j > length - 1) {
          currentNegativeStackInfo._stackingValues.add(0);
        }
      }
      if (isStacked100) {
        value = value / series._percentageValues[j] * 100;
        value = value.isNaN ? 0 : value;
      }
      if (value > 0) {
        lastValue = currentPositiveStackInfo._stackingValues[j];
        currentPositiveStackInfo._stackingValues[j] = lastValue + value;
      } else {
        lastValue = currentNegativeStackInfo._stackingValues[j];
        currentNegativeStackInfo._stackingValues[j] = lastValue + value;
      }
      startValues.add(lastValue.toDouble());
      endValues.add(value + lastValue);
      if (isStacked100 && endValues[j] > 100) {
        endValues[j] = 100;
      }
      point.cumulativeValue = !series._seriesType.contains('100')
          ? endValues[j]
          : endValues[j].truncateToDouble();
    }
    series._stackingValues.add(_StackedValues(startValues, endValues));
    series._minimumY = startValues.reduce(min);
    series._maximumY = endValues.reduce(max);

    if (series._minimumY > endValues.reduce(min)) {
      series._minimumY = isStacked100 ? -100 : endValues.reduce(min);
    }
    if (series._maximumY < startValues.reduce(max)) {
      series._maximumY = 0;
    }
  }

  void _calculateStackingPercentage(
      List<CartesianSeries<dynamic, dynamic>> seriesCollection) {
    List<_StackingInfo> percentageValues;
    String groupName;
    _StackingInfo stackingInfo;
    num lastValue, value;
    CartesianChartPoint<dynamic> point;
    for (int i = 0; i < seriesCollection.length; i++) {
      final CartesianSeries<dynamic, dynamic> series = seriesCollection[i];
      series._yAxis.isStack100 = true;
      if (series is _StackedSeriesBase) {
        if (series._dataPoints.isNotEmpty) {
          groupName = (series._seriesType == 'stackedarea100')
              ? 'stackedareagroup'
              : (series.groupName ?? 'series ' + i.toString());

          if (percentageValues == null) {
            percentageValues = <_StackingInfo>[];
            stackingInfo = _StackingInfo(groupName, <double>[]);
          }
          for (int j = 0; j < series._dataPoints.length; j++) {
            point = series._dataPoints[j];
            value = point.y;
            if (percentageValues.isNotEmpty) {
              for (int k = 0; k < percentageValues.length; k++) {
                if (groupName == percentageValues[k].groupName) {
                  stackingInfo = percentageValues[k];
                  break;
                } else if (k == percentageValues.length - 1) {
                  stackingInfo = _StackingInfo(groupName, <double>[]);
                  percentageValues.add(stackingInfo);
                }
              }
            }
            if (stackingInfo._stackingValues != null) {
              final int length = stackingInfo._stackingValues.length;
              if (length == 0 || j > length - 1) {
                stackingInfo._stackingValues.add(0);
              }
            }
            if (value >= 0) {
              lastValue = stackingInfo._stackingValues[j];
              stackingInfo._stackingValues[j] = lastValue + value;
            } else {
              lastValue = stackingInfo._stackingValues[j];
              stackingInfo._stackingValues[j] = lastValue - value;
            }
            if (j == series._dataPoints.length - 1)
              percentageValues.add(stackingInfo);
          }
        }
        if (percentageValues != null) {
          for (int i = 0; i < percentageValues.length; i++) {
            if (series._seriesType == 'stackedarea100') {
              series._percentageValues = percentageValues[i]._stackingValues;
            } else {
              if (series.groupName == percentageValues[i].groupName)
                series._percentageValues = percentageValues[i]._stackingValues;
            }
          }
        }
      }
    }
  }

  /// Calculate area type
  void _findAreaType(List<CartesianSeries<dynamic, dynamic>> seriesList) {
    if (visibleSeries.isNotEmpty) {
      int index = -1;
      for (CartesianSeries<dynamic, dynamic> series in seriesList) {
        _setSeriesType(series, index += 1);
      }
    }
  }

  void _setSeriesType(CartesianSeries<dynamic, dynamic> series, int index) {
    if (series.color == null) {
      series._seriesColor = chart.palette[paletteIndex % chart.palette.length];
      paletteIndex++;
    } else {
      series._seriesColor = series.color;
    }
    if (series is AreaSeries)
      series._seriesType = 'area';
    else if (series is BarSeries)
      series._seriesType = 'bar';
    else if (series is BubbleSeries)
      series._seriesType = 'bubble';
    else if (series is ColumnSeries)
      series._seriesType = 'column';
    else if (series is FastLineSeries)
      series._seriesType = 'fastline';
    else if (series is LineSeries)
      series._seriesType = 'line';
    else if (series is ScatterSeries)
      series._seriesType = 'scatter';
    else if (series is SplineSeries)
      series._seriesType = 'spline';
    else if (series is StepLineSeries)
      series._seriesType = 'stepline';
    else if (series is StackedColumnSeries)
      series._seriesType = 'stackedcolumn';
    else if (series is StackedBarSeries)
      series._seriesType = 'stackedbar';
    else if (series is StackedAreaSeries)
      series._seriesType = 'stackedarea';
    else if (series is StackedArea100Series)
      series._seriesType = 'stackedarea100';
    else if (series is StackedLineSeries)
      series._seriesType = 'stackedline';
    else if (series is StackedLine100Series)
      series._seriesType = 'stackedline100';
    else if (series is RangeColumnSeries)
      series._seriesType = 'rangecolumn';
    else if (series is RangeAreaSeries)
      series._seriesType = 'rangearea';
    else if (series is StackedColumn100Series)
      series._seriesType = 'stackedcolumn100';
    else if (series is StackedBar100Series)
      series._seriesType = 'stackedbar100';
    else if (series is SplineAreaSeries)
      series._seriesType = 'splinearea';
    else if (series is StepAreaSeries) {
      series._seriesType = 'steparea';
    } else if (series is HiloSeries) {
      series._seriesType = 'hilo';
    } else if (series is HiloOpenCloseSeries) {
      series._seriesType = 'hiloopenclose';
    } else if (series is CandleSeries) {
      series._seriesType = 'candle';
    }
    if (index == 0)
      chart._requireInvertedAxis = (!chart.isTransposed &&
              series._seriesType.toLowerCase().contains('bar')) ||
          (chart.isTransposed &&
              !series._seriesType.toLowerCase().contains('bar'));
  }

  ///below method is for indicator rendering
  void _calculateIndicators() {
    if (chart.indicators != null && chart.indicators.isNotEmpty) {
      dynamic indicator;
      bool existField;
      Map<String, int> _map;
      if (!chart.legend.isVisible) {
        final List<String> textCollection = <String>[];
        for (int i = 0; i < chart.indicators.length; i++) {
          final dynamic indicator = chart.indicators[i];
          _setIndicatorType(indicator);
          textCollection.add(indicator._indicatorType);
        }
        //ignore: prefer_collection_literals
        _map = Map<String, int>();
        //ignore: avoid_function_literals_in_foreach_calls
        textCollection.forEach((dynamic str) =>
            _map[str] = !_map.containsKey(str) ? (1) : (_map[str] + 1));
      }

      final List<String> indicatorTextCollection = <String>[];
      for (int i = 0; i < chart.indicators.length; i++) {
        indicator = chart.indicators[i];
        indicator._index = i;
        if (!chart.legend.isVisible) {
          final int count =
              indicatorTextCollection.contains(indicator._indicatorType)
                  ? _getIndicatorId(
                      indicatorTextCollection, indicator._indicatorType)
                  : 0;
          indicatorTextCollection.add(indicator._indicatorType);
          indicator._name = indicator.name ??
              (indicator._indicatorType +
                  (_map[indicator._indicatorType] == 1
                      ? ''
                      : ' ' + count.toString()));
        }
        if (indicator != null &&
            indicator.isVisible &&
            (indicator.dataSource != null || indicator.seriesName != null)) {
          if (indicator.dataSource != null && indicator.dataSource.isNotEmpty) {
            existField = indicator._indicatorType == 'SMA' ||
                indicator._indicatorType == 'TMA' ||
                indicator._indicatorType == 'EMA';
            final String valueField =
                existField ? _getFieldType(indicator).toLowerCase() : '';
            CartesianChartPoint<dynamic> currentPoint;
            for (int pointIndex = 0;
                pointIndex < indicator.dataSource.length;
                pointIndex++) {
              if (indicator.xValueMapper != null) {
                final dynamic xVal = indicator.xValueMapper(pointIndex);
                num highValue, lowValue, openValue, closeValue, volumeValue;
                indicator._dataPoints
                    .add(CartesianChartPoint<dynamic>(xVal, null));
                currentPoint =
                    indicator._dataPoints[indicator._dataPoints.length - 1];
                if (indicator.highValueMapper != null) {
                  highValue = indicator.highValueMapper(pointIndex);
                  indicator._dataPoints[indicator._dataPoints.length - 1].high =
                      highValue;
                }
                if (indicator.lowValueMapper != null) {
                  lowValue = indicator.lowValueMapper(pointIndex);
                  indicator._dataPoints[indicator._dataPoints.length - 1].low =
                      lowValue;
                }

                ///changing high,low value
                if (currentPoint.high != null && currentPoint.low != null) {
                  final num high = currentPoint.high;
                  final num low = currentPoint.low;
                  currentPoint.high = math.max<num>(high, low);
                  currentPoint.low = math.min<num>(high, low);
                }
                if (indicator.openValueMapper != null) {
                  openValue = indicator.openValueMapper(pointIndex);
                  indicator._dataPoints[indicator._dataPoints.length - 1].open =
                      openValue;
                }
                if (indicator.closeValueMapper != null) {
                  closeValue = indicator.closeValueMapper(pointIndex);
                  indicator._dataPoints[indicator._dataPoints.length - 1]
                      .close = closeValue;
                }
                if (indicator is AccumulationDistributionIndicator &&
                    indicator.volumeValueMapper != null) {
                  volumeValue = indicator.volumeValueMapper(pointIndex);
                  indicator._dataPoints[indicator._dataPoints.length - 1]
                      .volume = volumeValue;
                }

                if ((closeValue == null &&
                        (!existField || valueField == 'close')) ||
                    (highValue == null &&
                        (valueField == 'high' ||
                            indicator._indicatorType == 'AD' ||
                            indicator._indicatorType == 'ATR' ||
                            indicator._indicatorType == 'RSI' ||
                            indicator._indicatorType == 'Stochastic')) ||
                    (lowValue == null &&
                        (valueField == 'low' ||
                            indicator._indicatorType == 'AD' ||
                            indicator._indicatorType == 'ATR' ||
                            indicator._indicatorType == 'RSI' ||
                            indicator._indicatorType == 'Stochastic')) ||
                    (openValue == null && valueField == 'open') ||
                    (volumeValue == null && indicator._indicatorType == 'AD')) {
                  indicator._dataPoints
                      .removeAt(indicator._dataPoints.length - 1);
                }
              }
            }
          } else if (indicator.seriesName != null) {
            dynamic series;
            for (int i = 0; i < chart.series.length; i++) {
              if (indicator.seriesName == chart.series[i].name) {
                series = chart.series[i];
                break;
              }
            }
            indicator._dataPoints = (series != null &&
                    (series._seriesType == 'hiloopenclose' ||
                        series._seriesType == 'candle'))
                ? series._dataPoints
                : null;
          }
          if (indicator._dataPoints != null &&
              indicator._dataPoints.isNotEmpty) {
            indicator._initSeriesCollection(indicator, chart);
            indicator._initDataSource(indicator);
            if (indicator._renderPoints.isNotEmpty)
              chart._chartSeries.visibleSeries.addAll(indicator._targetSeries);
          }
        }
      }
    }
  }

  String _getFieldType(TechnicalIndicators<dynamic, dynamic> indicator) {
    String valueField;
    if (indicator is EmaIndicator)
      valueField = indicator.valueField;
    else if (indicator is TmaIndicator)
      valueField = indicator.valueField;
    else if (indicator is SmaIndicator) {
      valueField = indicator.valueField;
    }
    return valueField;
  }

  int _getIndicatorId(List<String> list, String str) {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == str) {
        count++;
      }
    }
    return count;
  }

  ///Setting indicator type
  void _setIndicatorType(TechnicalIndicators<dynamic, dynamic> indicator) {
    if (indicator is AtrIndicator)
      indicator._indicatorType = 'ATR';
    else if (indicator is AccumulationDistributionIndicator)
      indicator._indicatorType = 'AD';
    else if (indicator is BollingerBandIndicator)
      indicator._indicatorType = 'Bollinger';
    else if (indicator is EmaIndicator)
      indicator._indicatorType = 'EMA';
    else if (indicator is MacdIndicator)
      indicator._indicatorType = 'MACD';
    else if (indicator is MomentumIndicator)
      indicator._indicatorType = 'Momentum';
    else if (indicator is RsiIndicator)
      indicator._indicatorType = 'RSI';
    else if (indicator is SmaIndicator)
      indicator._indicatorType = 'SMA';
    else if (indicator is StochasticIndicator)
      indicator._indicatorType = 'Stochastic';
    else if (indicator is TmaIndicator) {
      indicator._indicatorType = 'TMA';
    }
  }
}
