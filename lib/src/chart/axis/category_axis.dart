part of charts;

/// This class has the properties of the category axis.
///
/// Category axis displays text labels instead of numbers. When the string values are bound to x values, then the x-axis
/// must be initialized with CategoryAxis.
///
/// Provides the options for Label placement, arrange by index and interval are used to customize the appearance.
///
class CategoryAxis extends ChartAxis {
  CategoryAxis(
      {String name,
      bool isVisible,
      AxisTitle title,
      AxisLine axisLine,
      bool arrangeByIndex,
      ChartRangePadding rangePadding,
      LabelPlacement labelPlacement,
      EdgeLabelPlacement edgeLabelPlacement,
      ChartDataLabelPosition labelPosition,
      TickPosition tickPosition,
      int labelRotation,
      AxisLabelIntersectAction labelIntersectAction,
      LabelAlignment labelAlignment,
      bool isInversed,
      bool opposedPosition,
      int minorTicksPerInterval,
      int maximumLabels,
      MajorTickLines majorTickLines,
      MinorTickLines minorTickLines,
      MajorGridLines majorGridLines,
      MinorGridLines minorGridLines,
      ChartTextStyle labelStyle,
      double plotOffset,
      double zoomFactor,
      double zoomPosition,
      InteractiveTooltip interactiveTooltip,
      this.minimum,
      this.maximum,
      double interval,
      this.visibleMinimum,
      this.visibleMaximum,
      dynamic crossesAt,
      String associatedAxisName,
      bool placeLabelsNearAxisLine,
      List<PlotBand> plotBands,
      int desiredIntervals,
      RangeController rangeController})
      : arrangeByIndex = arrangeByIndex ?? false,
        labelPlacement = labelPlacement ?? LabelPlacement.betweenTicks,
        super(
          name: name,
          isVisible: isVisible,
          isInversed: isInversed,
          plotOffset: plotOffset,
          rangePadding: rangePadding,
          opposedPosition: opposedPosition,
          edgeLabelPlacement: edgeLabelPlacement,
          labelRotation: labelRotation,
          labelPosition: labelPosition,
          tickPosition: tickPosition,
          labelIntersectAction: labelIntersectAction,
          minorTicksPerInterval: minorTicksPerInterval,
          maximumLabels: maximumLabels,
          labelAlignment: labelAlignment,
          labelStyle: labelStyle,
          title: title,
          axisLine: axisLine,
          majorTickLines: majorTickLines,
          minorTickLines: minorTickLines,
          majorGridLines: majorGridLines,
          minorGridLines: minorGridLines,
          zoomFactor: zoomFactor,
          zoomPosition: zoomPosition,
          interactiveTooltip: interactiveTooltip,
          interval: interval,
          crossesAt: crossesAt,
          associatedAxisName: associatedAxisName,
          placeLabelsNearAxisLine: placeLabelsNearAxisLine,
          plotBands: plotBands,
          desiredIntervals: desiredIntervals,
          rangeController: rangeController,
        ) {
    _labels = <dynamic>[];
  }
  SfCartesianChart _chart;

  ///Position of the category axis labels.
  ///
  ///The labels can be placed either
  ///between the ticks or at the major ticks.
  ///
  ///Defaults to `LabelPlacement.betweenTicks`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(labelPlacement: LabelPlacement.onTicks),
  ///        ));
  ///}
  ///```
  final LabelPlacement labelPlacement;

  ///Plots the data points based on the index value.
  ///
  ///By default, data points will be
  ///grouped and plotted based on the x-value. They can also be grouped by the data
  ///point index value.
  ///
  ///Defaults to `false`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(arrangeByIndex: true),
  ///        ));
  ///}
  ///```
  final bool arrangeByIndex;

  ///The minimum value of the axis.
  ///
  ///The axis will start from this value.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(minimum: 0),
  ///        ));
  ///}
  ///```
  final double minimum;

  ///The maximum value of the axis.
  ///
  /// The axis will end at this value.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(maximum: 10),
  ///        ));
  ///}
  ///```
  final double maximum;

  ///The minimum visible value of the axis. The axis is rendered from this value
  ///initially.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(visibleMinimum: 0),
  ///        ));
  ///}
  ///```
  final double visibleMinimum;

  ///The maximum visible value of the axis.
  ///
  /// The axis is rendered to this value initially.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(visibleMaximum: 20),
  ///        ));
  ///}
  ///```
  final double visibleMaximum;
  dynamic _labels;
  Rect _rect;

  void _findAxisMinMax(CartesianSeries<dynamic, dynamic> series,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength) {
    if (arrangeByIndex) {
      pointIndex < _labels.length && _labels[pointIndex] != null
          ? _labels[pointIndex] += ', ' + point.x
          : _labels.add(point.x.toString());
      point.xValue = pointIndex;
    } else {
      if (_labels.indexOf(point.x.toString()) < 0) {
        _labels.add(point.x.toString());
      }
      point.xValue = _labels.indexOf(point.x.toString());
    }
    point.yValue = point.y;
    series._minimumX ??= point.xValue;
    series._maximumX ??= point.xValue;
    if (!series._seriesType.contains('range')) {
      series._minimumY ??= point.yValue;
      series._maximumY ??= point.yValue;
    }
    _lowMin ??= point.low;
    _lowMax ??= point.low;
    _highMin ??= point.high;
    _highMax ??= point.high;
    if (point.xValue != null) {
      series._minimumX = math.min(series._minimumX, point.xValue);
      series._maximumX = math.max(series._maximumX, point.xValue);
    }
    if (point.yValue != null &&
        (!series._seriesType.contains('range') &&
            !series._seriesType.contains('hilo') &&
            !series._seriesType.contains('candle'))) {
      series._minimumY = math.min(series._minimumY, point.yValue);
      series._maximumY = math.max(series._maximumY, point.yValue);
    }
    if (point.high != null) {
      _highMin = math.min(_highMin, point.high);
      _highMax = math.max(_highMax, point.high);
    }
    if (point.low != null) {
      _lowMin = math.min(_lowMin, point.low);
      _lowMax = math.max(_lowMax, point.low);
    }
    if (pointIndex >= dataLength - 1) {
      if (series._seriesType.contains('range') ||
          series._seriesType.contains('hilo') ||
          series._seriesType.contains('candle')) {
        _lowMin ??= 0;
        _lowMax ??= 5;
        _highMin ??= 0;
        _highMax ??= 5;
        series._minimumY = math.min(_lowMin, _highMin);
        series._maximumY = math.max(_lowMax, _highMax);
      }
      series._minimumY ??= 0;
      series._maximumY ??= 5;
    }
  }

  void _controlListener() {
    if (rangeController != null) {
      _chart._chartState.rangeChangeBySlider = true;
      _rangeMinimum = rangeController.start;
      _rangeMaximum = rangeController.end;
      _chart._chartState.redrawByRangeChange();
    }
  }

  /// Calculate the range and interval
  void _calculateRangeAndInterval(SfCartesianChart chart, [String type]) {
    _chart = chart;
    if (rangeController != null) {
      rangeController.addListener(_controlListener);
    }
    final Rect containerRect = chart._chartState.containerRect;
    _rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    calculateRange(this);
    _calculateActualRange();
    if (_actualRange != null) {
      applyRangePadding(_actualRange, _actualRange.interval);
      if (type == null && type != 'AxisCross') {
        generateVisibleLabels();
      }
    }
  }

  void _calculateActualRange() {
    if (_min != null && _max != null) {
      _actualRange = _VisibleRange(
          _chart._chartState.rangeChangeBySlider && rangeController != null
              ? _rangeMinimum
              : minimum ?? _min,
          _chart._chartState.rangeChangeBySlider && rangeController != null
              ? _rangeMaximum
              : maximum ?? _max);
      final List<CartesianSeries<dynamic, dynamic>> seriesCollection = _series;
      CartesianSeries<dynamic, dynamic> series;
      for (int i = 0; i < seriesCollection.length; i++) {
        series = seriesCollection[i];
        if (_actualRange.maximum > series._dataPoints.length - 1) {
          for (int i = _labels.length; i < _actualRange.maximum + 1; i++) {
            _labels.add(i.toString());
          }
        }
      }
      _actualRange = _VisibleRange(minimum ?? _min, maximum ?? _max);

      ///Below condition is for checking the min, max value is equal
      if ((_actualRange.minimum == _actualRange.maximum) &&
          (labelPlacement == LabelPlacement.onTicks)) {
        _actualRange.maximum += 1;
      }
      _actualRange.delta = _actualRange.maximum - _actualRange.minimum;
      _actualRange.interval = interval ??
          calculateInterval(_actualRange, Size(_rect.width, _rect.height));
      _actualRange.delta = _actualRange.maximum - _actualRange.minimum;
    }
  }

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    _visibleRange = _VisibleRange(_actualRange.minimum, _actualRange.maximum);
    _visibleRange.delta = _actualRange.delta;
    _visibleRange.interval = _actualRange.interval;
    _checkWithZoomState(this, _chart._chartState.zoomedAxisStates);
    if (_zoomFactor < 1 || _zoomPosition > 0) {
      _calculateZoomRange(this, availableSize);
    }
  }

  /// Applies range padding
  @override
  void applyRangePadding(_VisibleRange range, num interval) {
    ActualRangeChangedArgs rangeChangedArgs;
    if (labelPlacement == LabelPlacement.betweenTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
      range.delta = range.maximum - range.minimum;
    }

    if (!(minimum != null && maximum != null)) {
      ///Calculating range padding
      _applyRangePadding(this, _chart, range, interval);
    }

    calculateVisibleRange(Size(_rect.width, _rect.height));

    /// Setting range as visible zoomRange
    if ((visibleMinimum != null || visibleMaximum != null) &&
        (visibleMinimum != visibleMaximum) &&
        _chart._chartState.zoomedAxisStates != null &&
        _chart._chartState.zoomedAxisStates.isEmpty) {
      _visibleRange.minimum =
          visibleMinimum != null ? visibleMinimum : _visibleRange.minimum;
      _visibleRange.maximum =
          visibleMaximum != null ? visibleMaximum : _visibleRange.maximum;
      _visibleRange.delta = _visibleRange.maximum - _visibleRange.minimum;
      _zoomFactor = _visibleRange.delta / (range.delta);
      _zoomPosition =
          (_visibleRange.minimum - _actualRange.minimum) / range.delta;
    }
    if (_chart.onActualRangeChanged != null) {
      rangeChangedArgs = ActualRangeChangedArgs();
      rangeChangedArgs.axisName = _name;
      rangeChangedArgs.orientation = _orientation;
      rangeChangedArgs.axis = this;
      rangeChangedArgs.actualMin = range.minimum;
      rangeChangedArgs.actualMax = range.maximum;
      rangeChangedArgs.actualInterval = range.interval;
      rangeChangedArgs.visibleMin = _visibleRange.minimum;
      rangeChangedArgs.visibleMax = _visibleRange.maximum;
      rangeChangedArgs.visibleInterval = _visibleRange.interval;
      _chart.onActualRangeChanged(rangeChangedArgs);
      _visibleRange.minimum = rangeChangedArgs.visibleMin;
      _visibleRange.maximum = rangeChangedArgs.visibleMax;
      _visibleRange.interval = rangeChangedArgs.visibleInterval;
    }
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _visibleRange.minimum.ceil();
    num position;
    String labelText;
    _visibleLabels = <AxisLabel>[];
    for (;
        tempInterval <= _visibleRange.maximum;
        tempInterval += _visibleRange.interval) {
      if (_withIn(tempInterval, _visibleRange)) {
        position = tempInterval.round();
        if (position <= -1 ||
            (_labels.isNotEmpty && position >= _labels.length)) {
          continue;
        } else if (_labels.isNotEmpty && _labels[position] != null) {
          labelText = _labels[position];
        } else {
          continue;
        }
        _triggerLabelRenderEvent(labelText, tempInterval);
      }
    }
    _calculateMaximumLabelSize(this, _chart);
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(_VisibleRange range, Size availableSize) => math
      .max(
          1,
          (_actualRange.delta /
                  _calculateDesiredIntervalCount(
                      Size(_rect.width, _rect.height), this))
              .floor())
      .toInt();
}
