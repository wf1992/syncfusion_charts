part of charts;

// ignore: must_be_immutable
class _ChartTooltipRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ChartTooltipRenderer({this.chartWidget});

  final dynamic chartWidget;

  _ChartTooltipRendererState state;

  @override
  State<StatefulWidget> createState() {
    return _ChartTooltipRendererState();
  }
}

class _ChartTooltipRendererState extends State<_ChartTooltipRenderer>
    with SingleTickerProviderStateMixin {
  /// Animation controller for series
  AnimationController animationController;

  /// Repaint notifier for crosshair container
  ValueNotifier<int> tooltipRepaintNotifier;

  bool show;

  //ignore: prefer_final_fields
  bool _needMarker = true;

  @override
  void initState() {
    show = false;
    tooltipRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(_repaintTooltipElements);
    super.initState();
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController.removeListener(_repaintTooltipElements);
      animationController.dispose();
      animationController = null;
    }
    super.dispose();
  }

  void _repaintTooltipElements() {
    tooltipRepaintNotifier.value++;
  }

  void _showTooltip(double x, double y) {
    if (x != null &&
        y != null &&
        widget.chartWidget.tooltipBehavior._painter != null) {
      show = true;
      widget.chartWidget.tooltipBehavior._painter._chart.tooltipBehavior
              ._isHovering
          ? widget.chartWidget.tooltipBehavior._painter.showMouseTooltip(x, y)
          : widget.chartWidget.tooltipBehavior._painter.show(x, y);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = const Duration(milliseconds: 300);
    final Animation<double> tooltipAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));
    animationController.forward(from: 0.0);
    final _TooltipPainter tooltipPainter = _TooltipPainter(
        tooltipAnimation: tooltipAnimation,
        chartTooltipState: this,
        notifier: tooltipRepaintNotifier,
        animationController: animationController);
    tooltipPainter._chart = widget.chartWidget;
    tooltipPainter.tooltip = widget.chartWidget.tooltipBehavior;
    tooltipPainter._chartState = widget.chartWidget._chartState;
    widget.chartWidget.tooltipBehavior._painter = tooltipPainter;
    return Container(child: CustomPaint(painter: tooltipPainter));
  }
}

/// Holds the tooltip series and point index
///
/// This class is used to provide the [seriesIndex] and [pointIndex] for the Tooltip.
class TooltipValue {
  TooltipValue(this.seriesIndex, this.pointIndex);

  ///Index of the series.
  int seriesIndex;

  ///Index of data points.
  int pointIndex;
}

class _TooltipPainter extends CustomPainter {
  _TooltipPainter(
      {this.chartTooltipState,
      this.animationController,
      this.tooltipAnimation,
      ValueNotifier<num> notifier})
      : super(repaint: notifier);
  double pointerLength = 10;
  double nosePointY = 0;
  double nosePointX = 0;
  double totalWidth = 0;
  double x;
  double y;
  double xPos;
  double yPos;
  ValueNotifier<int> valueNotifier;
  bool isTop = false;
  double borderRadius = 5;
  Path arrowPath = Path();
  bool canResetPath = false;
  Timer timer;
  bool isLeft = false;
  bool isRight = false;
  Animation<double> tooltipAnimation;
  dynamic _chart;
  bool enable;
  double padding = 0;
  String stringValue;
  num markerPointY;
  List<String> textValues = <String>[];
  List<XyDataSeries<dynamic, dynamic>> seriesCollection =
      <XyDataSeries<dynamic, dynamic>>[];
  String header;
  Rect boundaryRect = const Rect.fromLTWH(0, 0, 0, 0);
  dynamic tooltip;
  dynamic _chartState;
  dynamic currentSeries;
  num pointIndex;
  DataMarkerType markerType;
  double markerSize;
  Color markerColor;
  XyDataSeries<dynamic, dynamic> series;
  TooltipValue prevTooltipValue;
  TooltipValue currentTooltipValue;

  final _ChartTooltipRendererState chartTooltipState;

  final AnimationController animationController;

  // ignore:unused_element
  void _renderTooltipView(Offset position) {
    if (tooltip._painter._chart is SfCartesianChart) {
      _renderCartesianChartTooltip(position);
    } else if (tooltip._painter._chart is SfCircularChart) {
      _renderCircularChartTooltip(position);
    } else {
      _renderTriangularChartTooltip(position);
    }
  }

  void _renderCartesianChartTooltip(Offset position) {
    final SfCartesianChart chart = tooltip._painter._chart;
    tooltip._painter.boundaryRect = chart._chartAxis._axisClipRect;
    bool isContains = false;
    if (chart._chartAxis._axisClipRect.contains(position)) {
      for (int i = 0; i < chart._chartSeries.visibleSeries.length; i++) {
        series = chart._chartSeries.visibleSeries[i];
        if (series._visible &&
            series.enableTooltip &&
            series._regionalData != null) {
          int count = 0;
          series._regionalData.forEach((dynamic regionRect, dynamic values) {
            final bool isTrendLine = values[values.length - 1].contains('true');
            final double padding = ((series._seriesType == 'bubble' ||
                        series._seriesType == 'scatter' ||
                        series._seriesType.contains('column') ||
                        series._seriesType.contains('bar')) &&
                    !isTrendLine)
                ? 0
                : chart.tooltipBehavior._isHovering
                    ? 0
                    : 15; // regional padding to detect smooth touch
            final Rect region = regionRect[0];
            final double left = region.left - padding;
            final double right = region.right + padding;
            final double top = region.top - padding;
            final double bottom = region.bottom + padding;
            final Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
            if (paddedRegion.contains(position) &&
                (isTrendLine ? regionRect[4].isVisible : true)) {
              if (!region.contains(position)) {
                tooltip._painter.boundaryRect = chart._chartState.containerRect;
              }
              tooltip._painter.prevTooltipValue = TooltipValue(i, count);
              if (tooltip._painter.prevTooltipValue != null &&
                  tooltip._painter.currentTooltipValue != null &&
                  (tooltip._painter.prevTooltipValue.pointIndex !=
                          tooltip._painter.currentTooltipValue.pointIndex ||
                      tooltip._painter.prevTooltipValue.seriesIndex !=
                          tooltip._painter.currentTooltipValue.seriesIndex)) {
                tooltip._painter.currentTooltipValue = null;
              }
              currentSeries = series;
              pointIndex = count;
              markerType = series.markerSettings.shape;
              markerColor = regionRect[2] != null
                  ? regionRect[2]
                  : series.markerSettings.borderColor ?? series._seriesColor;
              Offset tooltipPosition = regionRect[1];
              Offset padding;
              if (series._seriesType == 'bubble' && !isTrendLine) {
                padding = Offset(region.center.dx - region.centerLeft.dx,
                    2 * (region.center.dy - region.topCenter.dy));
                tooltipPosition = Offset(tooltipPosition.dx, paddedRegion.top);
              } else if (series._seriesType == 'scatter') {
                padding = Offset(series.markerSettings.width,
                    series.markerSettings.height / 2);
                tooltipPosition =
                    Offset(tooltipPosition.dx, tooltipPosition.dy);
              } else if (series._seriesType == 'rangearea') {
                padding = Offset(series.markerSettings.width,
                    series.markerSettings.height * 2);
                tooltipPosition =
                    Offset(tooltipPosition.dx, tooltipPosition.dy);
              } else {
                padding = (series.markerSettings.isVisible)
                    ? Offset(
                        series.markerSettings.width / 2,
                        series.markerSettings.height / 2 +
                            series.markerSettings.borderWidth / 2)
                    : const Offset(2, 2);
              }
              if (series._isRectSeries &&
                  tooltip.tooltipPosition == TooltipPosition.pointer) {
                tooltipPosition = position;
              }
              tooltip._painter.padding = padding.dy;
              String header = tooltip.header;
              header = (header == null)
                  ? (tooltip.shared
                      ? values[0]
                      : (isTrendLine
                          ? values[values.length - 2]
                          : series.name ?? series._seriesName))
                  : header;
              tooltip._painter.header = header;
              tooltip._painter.stringValue = '';
              if (tooltip.shared) {
                textValues = <String>[];
                seriesCollection = <XyDataSeries<dynamic, dynamic>>[];
                for (int j = 0;
                    j < chart._chartSeries.visibleSeries.length;
                    j++) {
                  final XyDataSeries<dynamic, dynamic> _series =
                      chart._chartSeries.visibleSeries[j];
                  if (_series._visible && _series.enableTooltip) {
                    final int index = _series._xValues.indexOf(regionRect[4].x);
                    if (index > -1) {
                      final String text =
                          (tooltip._painter.stringValue != '' ? '\n' : '') +
                              _calculateCartesianTooltipText(
                                  _series,
                                  _series._dataPoints[index],
                                  values,
                                  tooltipPosition);
                      tooltip._painter.stringValue += text;
                      textValues.add(text);
                      seriesCollection.add(_series);
                    }
                  }
                }
              } else {
                tooltip._painter.stringValue = _calculateCartesianTooltipText(
                    series, regionRect[4], values, tooltipPosition);
              }
              tooltip._painter._calculateLocation(tooltipPosition);
              isContains = true;
            }
            count++;
          });
        }
      }
    }
    if (!isContains) {
      tooltip._painter.prevTooltipValue =
          tooltip._painter.currentTooltipValue = null;
      if (!chart.tooltipBehavior._isHovering) {
        tooltip.hide();
      }
    }
  }

  String _calculateCartesianTooltipText(
      XyDataSeries<dynamic, dynamic> series,
      CartesianChartPoint<dynamic> point,
      dynamic values,
      Offset tooltipPosition) {
    final bool isTrendLine = values[values.length - 1].contains('true');
    String resultantString;
    final dynamic axis = series._yAxis;
    final int digits = series._chart.tooltipBehavior.decimalPlaces;
    if (tooltip.format != null) {
      resultantString = (series._seriesType.contains('range') || series._seriesType == 'hilo') && !isTrendLine
          ? (tooltip.format
              .replaceAll('point.x', values[0])
              .replaceAll(
                  'point.high', _getLabelValue(point.high, axis, digits))
              .replaceAll('point.low', _getLabelValue(point.low, axis, digits))
              .replaceAll('series.name', series.name ?? series._seriesName))
          : (series._seriesType.contains('hiloopenclose') ||
                      series._seriesType.contains('candle')) &&
                  !isTrendLine
              ? (tooltip.format
                  .replaceAll('point.x', values[0])
                  .replaceAll(
                      'point.high', _getLabelValue(point.high, axis, digits))
                  .replaceAll(
                      'point.low', _getLabelValue(point.low, axis, digits))
                  .replaceAll(
                      'point.open', _getLabelValue(point.open, axis, digits))
                  .replaceAll(
                      'point.close', _getLabelValue(point.close, axis, digits))
                  .replaceAll('series.name', series.name ?? series._seriesName))
              : (tooltip.format
                  .replaceAll('point.x', values[0])
                  .replaceAll('point.y', _getLabelValue(point.y, axis, digits))
                  .replaceAll('series.name', series.name ?? series._seriesName)
                  .replaceAll('point.size', _getLabelValue(point.bubbleSize, axis, digits)));
      if (series._seriesType.contains('stacked')) {
        resultantString = resultantString.replaceAll('point.cumulativeValue',
            _getLabelValue(point.cumulativeValue, axis, digits));
      }
    } else {
      resultantString =
          (tooltip.shared ? series.name ?? series._seriesName : values[0]) +
              (((series._seriesType.contains('range') ||
                          series._seriesType == 'hilo') &&
                      !isTrendLine)
                  ? ('\nHigh: ' +
                      _getLabelValue(point.high, axis, digits) +
                      '\nLow: ' +
                      _getLabelValue(point.low, axis, digits))
                  : (series._seriesType == 'hiloopenclose' ||
                          series._seriesType == 'candle'
                      ? ('\nHigh: ' +
                          _getLabelValue(point.high, axis, digits) +
                          '\nLow: ' +
                          _getLabelValue(point.low, axis, digits) +
                          '\nOpen: ' +
                          _getLabelValue(point.open, axis, digits) +
                          '\nClose: ' +
                          _getLabelValue(point.close, axis, digits))
                      : ' : ' + _getLabelValue(point.y, axis, digits)));
    }
    return resultantString;
  }

  void _renderCircularChartTooltip(Offset position) {
    final SfCircularChart chart = tooltip._painter._chart;
    chart.tooltipBehavior._painter.boundaryRect =
        chart._chartState.chartContainerRect;
    bool isContains = false;
    final _Region pointRegion = _getPointRegion(chart, position);
    if (pointRegion != null &&
        chart._chartSeries.visibleSeries[pointRegion.seriesIndex]
            .enableTooltip) {
      tooltip._painter.prevTooltipValue =
          TooltipValue(pointRegion.seriesIndex, pointRegion.pointIndex);
      if (tooltip._painter.prevTooltipValue != null &&
          tooltip._painter.currentTooltipValue != null &&
          tooltip._painter.prevTooltipValue.pointIndex !=
              tooltip._painter.currentTooltipValue.pointIndex) {
        tooltip._painter.currentTooltipValue = null;
      }
      final ChartPoint<dynamic> chartPoint = chart
          ._chartSeries
          .visibleSeries[pointRegion.seriesIndex]
          ._renderPoints[pointRegion.pointIndex];
      final Offset location =
          chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer
              ? position
              : _degreeToPoint(
                  chartPoint.midAngle,
                  (chartPoint.innerRadius + chartPoint.outerRadius) / 2,
                  chartPoint.center);
      currentSeries = pointRegion.seriesIndex;
      pointIndex = pointRegion.pointIndex;
      String header = chart.tooltipBehavior.header;
      header = (header == null)
          ? chart._chartSeries.visibleSeries[pointRegion.seriesIndex].name !=
                  null
              ? chart._chartSeries.visibleSeries[pointRegion.seriesIndex].name
              : null
          : header;
      chart.tooltipBehavior._painter.header = header;
      if (chart.tooltipBehavior.format != null) {
        final String resultantString = chart.tooltipBehavior.format
            .replaceAll('point.x', chartPoint.x.toString())
            .replaceAll('point.y', chartPoint.y.toString())
            .replaceAll(
                'series.name',
                chart._chartSeries.visibleSeries[pointRegion.seriesIndex]
                        .name ??
                    'series.name');
        chart.tooltipBehavior._painter.stringValue = resultantString;
        chart.tooltipBehavior._painter._calculateLocation(location);
      } else {
        chart.tooltipBehavior._painter.stringValue =
            chartPoint.x.toString() + ' : ' + chartPoint.y.toString();
        chart.tooltipBehavior._painter._calculateLocation(location);
      }
      isContains = true;
    } else {
      chart.tooltipBehavior.hide();
      isContains = false;
    }
    if (!isContains) {
      tooltip._painter.prevTooltipValue =
          tooltip._painter.currentTooltipValue = null;
    }
  }

  void _renderTriangularChartTooltip(Offset position) {
    final dynamic chart = tooltip._painter._chart;
    chart.tooltipBehavior._painter.boundaryRect =
        chart._chartState.chartContainerRect;
    bool isContains = false;
    const num seriesIndex = 0;
    pointIndex = chart._chartState._tooltipPointIndex ??
        chart._chartState.currentActive.pointIndex;
    chart._chartState._tooltipPointIndex = null;
    if (chart.tooltipBehavior.enable) {
      tooltip._painter.prevTooltipValue = TooltipValue(seriesIndex, pointIndex);
      if (tooltip._painter.prevTooltipValue != null &&
          tooltip._painter.currentTooltipValue != null &&
          tooltip._painter.prevTooltipValue.pointIndex !=
              tooltip._painter.currentTooltipValue.pointIndex) {
        tooltip._painter.currentTooltipValue = null;
      }
      final PointInfo<dynamic> chartPoint = chart
          ._chartSeries.visibleSeries[seriesIndex]._renderPoints[pointIndex];
      final Offset location =
          chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer
              ? position
              : chartPoint.symbolLocation;
      currentSeries = seriesIndex;
      pointIndex = pointIndex;
      String header = chart.tooltipBehavior.header;
      header = (header == null)
          ? chart._chartSeries.visibleSeries[seriesIndex].name != null
              ? chart._chartSeries.visibleSeries[seriesIndex].name
              : null
          : header;
      chart.tooltipBehavior._painter.header = header;
      if (chart.tooltipBehavior.format != null) {
        final String resultantString = chart.tooltipBehavior.format
            .replaceAll('point.x', chartPoint.x.toString())
            .replaceAll('point.y', chartPoint.y.toString())
            .replaceAll(
                'series.name',
                chart._chartSeries.visibleSeries[seriesIndex].name ??
                    'series.name');
        chart.tooltipBehavior._painter.stringValue = resultantString;
        chart.tooltipBehavior._painter._calculateLocation(location);
      } else {
        chart.tooltipBehavior._painter.stringValue =
            chartPoint.x.toString() + ' : ' + chartPoint.y.toString();
        chart.tooltipBehavior._painter._calculateLocation(location);
      }
      isContains = true;
    } else {
      chart.tooltipBehavior.hide();
      isContains = false;
    }
    if (!isContains) {
      tooltip._painter.prevTooltipValue =
          tooltip._painter.currentTooltipValue = null;
    }
  }

  void _calculateLocation(Offset position) {
    x = position?.dx;
    y = position?.dy;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (chartTooltipState.show) {
      if (_chart is SfCartesianChart) {
        final SfCartesianChart sfChart = _chart;
        sfChart.tooltipBehavior.onPaint(canvas);
      } else if (_chart is SfCircularChart) {
        final SfCircularChart sfCircularChart = _chart;
        sfCircularChart.tooltipBehavior.onPaint(canvas);
      } else if (_chart is SfPyramidChart) {
        final SfPyramidChart sfPyramidChart = _chart;
        sfPyramidChart.tooltipBehavior.onPaint(canvas);
      } else if (_chart is SfFunnelChart) {
        final SfFunnelChart sfFunnelChart = _chart;
        sfFunnelChart.tooltipBehavior.onPaint(canvas);
      }
    }
  }

  void _renderTooltip(Canvas canvas) {
    isLeft = false;
    isRight = false;
    double height = 0, width = 0, headerTextWidth = 0, headerTextHeight = 0;
    TooltipArgs tooltipArgs;
    markerSize = 0;

    if (x != null &&
        y != null &&
        stringValue != null &&
        _chart.onTooltipRender != null) {
      const num index = 0;
      tooltipArgs = TooltipArgs();
      tooltipArgs.text = stringValue;
      tooltipArgs.header = header;
      tooltipArgs.locationX = x;
      tooltipArgs.locationY = y;
      tooltipArgs.pointIndex = pointIndex;
      tooltipArgs.seriesIndex = _chart is SfCartesianChart
          ? currentSeries.segments[index]._seriesIndex
          : currentSeries;
      tooltipArgs.dataPoints = _chart
          ._chartSeries.visibleSeries[tooltipArgs.seriesIndex]._dataPoints;
      _chart.onTooltipRender(tooltipArgs);
      stringValue = tooltipArgs.text;
      header = tooltipArgs.header;
      x = tooltipArgs.locationX;
      y = tooltipArgs.locationY;
    }

    totalWidth = boundaryRect.left.toDouble() + boundaryRect.width.toDouble();
    final ChartTextStyle textStyle = ChartTextStyle(
        color: tooltip.textStyle.color ??
            _chart._chartState._chartTheme.tooltipLabelColor,
        fontSize: tooltip.textStyle.fontSize,
        fontFamily: tooltip.textStyle.fontFamily,
        fontWeight: tooltip.textStyle.fontWeight,
        fontStyle: tooltip.textStyle.fontStyle);
    width = _measureText(stringValue, textStyle).width;
    height = _measureText(stringValue, textStyle).height;
    if (header != null && header.isNotEmpty) {
      final ChartTextStyle headerTextStyle = ChartTextStyle(
          color: tooltip.textStyle.color ??
              _chart._chartState._chartTheme.tooltipLabelColor,
          fontSize: tooltip.textStyle.fontSize,
          fontFamily: tooltip.textStyle.fontFamily,
          fontStyle: tooltip.textStyle.fontStyle,
          fontWeight: FontWeight.bold);
      headerTextWidth = _measureText(header, headerTextStyle).width;
      headerTextHeight = _measureText(header, headerTextStyle).height + 10;
      width = width > headerTextWidth ? width : headerTextWidth;
    }

    if (width < 10) {
      width = 10; // minimum width for tooltip to render
      borderRadius = borderRadius > 5 ? 5 : borderRadius;
    }
    if (borderRadius > 15) {
      borderRadius = 15;
    }

    if (x != null &&
        y != null &&
        padding != null &&
        (stringValue != '' && stringValue != null ||
            header != '' && header != null)) {
      _calculateBackgroundRect(canvas, height, width, headerTextHeight);
    }
  }

  /// calculate tooltip rect and arrow head
  void _calculateBackgroundRect(
      Canvas canvas, double height, double width, double headerTextHeight) {
    double widthPadding = 15;
    if (_chart is SfCartesianChart &&
        tooltip.canShowMarker != null &&
        tooltip.canShowMarker &&
        chartTooltipState._needMarker) {
      markerSize = 5;
      widthPadding = 17;
    }

    Rect rect = Rect.fromLTWH(x, y, width + (2 * markerSize) + widthPadding,
        height + headerTextHeight + 10);
    final Rect newRect = Rect.fromLTWH(boundaryRect.left + 20, boundaryRect.top,
        boundaryRect.width - 40, boundaryRect.height);
    final Rect leftRect = Rect.fromLTWH(
        boundaryRect.left - 5,
        boundaryRect.top - 20,
        newRect.left - (boundaryRect.left - 5),
        boundaryRect.height + 40);
    final Rect rightRect = Rect.fromLTWH(newRect.right, boundaryRect.top - 20,
        (boundaryRect.right + 5) + newRect.right, boundaryRect.height + 40);

    if (leftRect.contains(Offset(x, y))) {
      isLeft = true;
      isRight = false;
    } else if (rightRect.contains(Offset(x, y))) {
      isLeft = false;
      isRight = true;
    }

    if (y > pointerLength + rect.height && y > boundaryRect.top) {
      if (_chart is SfCartesianChart) {
        if (currentSeries._seriesType == 'bubble') {
          padding = 2;
        }
      }
      isTop = true;
      xPos = x - (rect.width / 2);
      yPos = (y - rect.height) - padding;
      nosePointY = rect.top - padding;
      nosePointX = rect.left;
      final double tooltipRightEnd = x + (rect.width / 2);
      xPos = xPos < boundaryRect.left
          ? boundaryRect.left
          : tooltipRightEnd > totalWidth ? totalWidth - rect.width : xPos;
      yPos = yPos - (pointerLength / 2);
    } else {
      isTop = false;
      xPos = x - (rect.width / 2);
      yPos =
          ((y >= boundaryRect.top ? y : boundaryRect.top) + pointerLength / 2) +
              padding;
      nosePointX = rect.left;
      nosePointY = (y >= boundaryRect.top ? y : boundaryRect.top) + padding;
      final double tooltipRightEnd = x + (rect.width / 2);
      xPos = xPos < boundaryRect.left
          ? boundaryRect.left
          : tooltipRightEnd > totalWidth ? totalWidth - rect.width : xPos;
    }
    if (xPos <= boundaryRect.left + 5) {
      xPos = xPos + 5;
    } else if (xPos + rect.width >= totalWidth - 5) {
      xPos = xPos - 5;
    }
    rect = Rect.fromLTWH(xPos, yPos, rect.width, rect.height);
    _drawBackground(canvas, rect, nosePointX, nosePointY, borderRadius, isTop,
        arrowPath, isLeft, isRight, tooltipAnimation);
  }

  void _drawBackground(
      Canvas canvas,
      Rect rectF,
      double xPos,
      double yPos,
      double borderRadius,
      bool isTop,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      Animation<double> tooltipAnimation) {
    final double startArrow = pointerLength / 2;
    final double endArrow = pointerLength / 2;
    if (isTop) {
      _drawTooltip(
          canvas,
          isTop,
          rectF,
          xPos,
          yPos,
          xPos - startArrow,
          yPos - startArrow,
          xPos + endArrow,
          yPos - endArrow,
          borderRadius,
          backgroundPath,
          isLeft,
          isRight,
          tooltipAnimation);
    } else {
      _drawTooltip(
          canvas,
          isTop,
          rectF,
          xPos,
          yPos,
          xPos - startArrow,
          yPos + startArrow,
          xPos + endArrow,
          yPos + endArrow,
          borderRadius,
          backgroundPath,
          isLeft,
          isRight,
          tooltipAnimation);
    }
  }

  void _drawTooltip(
      Canvas canvas,
      bool isTop,
      Rect rectF,
      double xPos,
      double yPos,
      double startX,
      double startY,
      double endX,
      double endY,
      double borderRadius,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      Animation<double> tooltipAnimation) {
    double animationFactor = 0;
    if (tooltipAnimation == null) {
      animationFactor = 1;
    } else {
      animationFactor = tooltipAnimation.value;
    }
    backgroundPath.reset();
    if (!canResetPath) {
      if (isLeft) {
        startX = rectF.left + (2 * borderRadius);
        endX = startX + pointerLength;
      } else if (isRight) {
        startX = endX - pointerLength;
        endX = rectF.right - (2 * borderRadius);
      }

      final Rect rect = Rect.fromLTWH(
          rectF.width / 2 + (rectF.left - rectF.width / 2 * animationFactor),
          rectF.height / 2 + (rectF.top - rectF.height / 2 * animationFactor),
          rectF.width * animationFactor,
          rectF.height * animationFactor);

      final RRect tooltipRect = RRect.fromRectAndCorners(
        rect,
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      );
      _drawTooltipPath(canvas, tooltipRect, rect, backgroundPath, isTop, isLeft,
          isRight, startX, endX, animationFactor, xPos, yPos);

      final ChartTextStyle textStyle = ChartTextStyle(
          color: tooltip.textStyle.color?.withOpacity(tooltip.opacity) ??
              _chart._chartState._chartTheme.tooltipLabelColor,
          fontSize: tooltip.textStyle.fontSize * animationFactor,
          fontFamily: tooltip.textStyle.fontFamily,
          fontWeight: tooltip.textStyle.fontWeight,
          fontStyle: tooltip.textStyle.fontStyle);
      final Size result = _measureText(stringValue, textStyle);
      _drawTooltipText(canvas, tooltipRect, textStyle, result, animationFactor);
      if (_chart is SfCartesianChart &&
          tooltip.canShowMarker &&
          chartTooltipState._needMarker) {
        _drawTooltipMarker(canvas, tooltipRect, textStyle, animationFactor);
      }
      xPos = null;
      yPos = null;
    }
  }

  /// draw the tooltip rect path
  void _drawTooltipPath(
      Canvas canvas,
      RRect tooltipRect,
      Rect rect,
      Path backgroundPath,
      bool isTop,
      bool isLeft,
      bool isRight,
      double startX,
      double endX,
      double animationFactor,
      double xPos,
      double yPos) {
    double factor = 0;
    if (isTop && isRight) {
      factor = rect.bottom;
      backgroundPath.moveTo(rect.right - 20, factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(rect.right - 20, rect.top + rect.height / 2);
      backgroundPath.lineTo(rect.right - 20, factor);
    } else if (!isTop && isRight) {
      factor = rect.top;
      backgroundPath.moveTo(rect.right - 20, factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(rect.right - 20, rect.top + rect.height / 2);
      backgroundPath.lineTo(rect.right - 20, factor);
    } else if (isTop && isLeft) {
      factor = rect.bottom;
      backgroundPath.moveTo(rect.left + 20, factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(rect.left + 20, rect.top + rect.height / 2);
      backgroundPath.lineTo(rect.left + 20, factor);
    } else if (!isTop && isLeft) {
      factor = rect.top;
      backgroundPath.moveTo(rect.left + 20, factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(rect.left + 20, rect.top + rect.height / 2);
      backgroundPath.lineTo(rect.left + 20, factor);
    } else {
      if (isTop) {
        factor = tooltipRect.bottom;
      } else {
        factor = tooltipRect.top;
      }
      backgroundPath.moveTo(startX - ((endX - startX) / 4), factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(endX + ((endX - startX) / 4), factor);
      backgroundPath.lineTo(startX + ((endX - startX) / 4), factor);
    }
    final Paint fillPaint = Paint()
      ..color = (tooltip.color ?? _chart._chartState._chartTheme.tooltipColor)
          .withOpacity(tooltip.opacity)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = tooltip.borderColor == Colors.transparent
          ? Colors.transparent
          : tooltip.borderColor.withOpacity(tooltip.opacity)
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = tooltip.borderWidth;
    tooltip.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;

    final Path tooltipPath = Path();
    tooltipPath.addRRect(tooltipRect);
    if (tooltip.elevation > 0) {
      if (tooltipRect.width * animationFactor > tooltipRect.width * 0.85) {
        canvas.drawShadow(arrowPath, tooltip.shadowColor ?? fillPaint.color,
            tooltip.elevation, true);
      }
      canvas.drawShadow(tooltipPath, tooltip.shadowColor ?? fillPaint.color,
          tooltip.elevation, true);
    }

    if (tooltipRect.width * animationFactor > tooltipRect.width * 0.85) {
      canvas.drawPath(arrowPath, fillPaint);
      canvas.drawPath(arrowPath, strokePaint);
    }
    canvas.drawPath(tooltipPath, fillPaint);
    canvas.drawPath(tooltipPath, strokePaint);
  }

  /// draw marker inside the tooltip
  void _drawTooltipMarker(Canvas canvas, RRect tooltipRect,
      ChartTextStyle textStyle, double animationFactor) {
    final Size tooltipStringResult = _measureText(stringValue, textStyle);
    if (tooltip.shared) {
      Size result1 = const Size(0, 0);
      String str = '';
      for (int i = 0; i < textValues.length; i++) {
        str += textValues[i];
        final Size result = _measureText(str, textStyle);
        final Offset markerPoint = Offset(
            tooltipRect.left +
                tooltipRect.width / 2 -
                tooltipStringResult.width / 2,
            (markerPointY + result1.height) - markerSize);
        result1 = result;
        final XyDataSeries<dynamic, dynamic> _series = seriesCollection[i];
        _renderMarker(markerPoint, _series, animationFactor, canvas);
      }
    } else {
      final Offset markerPoint = Offset(
          tooltipRect.left +
              tooltipRect.width / 2 -
              tooltipStringResult.width / 2,
          ((tooltipRect.top + tooltipRect.height) -
                  tooltipStringResult.height / 2) -
              markerSize);
      _renderMarker(markerPoint, series, animationFactor, canvas);
    }
  }

  void _renderMarker(Offset markerPoint, XyDataSeries<dynamic, dynamic> _series,
      double animationFactor, Canvas canvas) {
    final Path markerPath = _getMarkerShapes(
        markerType,
        markerPoint,
        Size((2 * markerSize) * animationFactor,
            (2 * markerSize) * animationFactor),
        _series);

    if (_series.markerSettings.shape == DataMarkerType.image) {
      _drawImageMarker(_series, canvas, markerPoint.dx, markerPoint.dy);
    }

    Paint markerPaint = Paint();
    markerPaint.color = (!tooltip.shared
            ? markerColor
            : _series.markerSettings.borderColor ??
                _series._seriesColor ??
                _series.color)
        .withOpacity(tooltip.opacity);
    if (_series.gradient != null) {
      markerPaint = _getLinearGradientPaint(
          _series.gradient,
          _getMarkerShapes(
                  markerType,
                  Offset(markerPoint.dx, markerPoint.dy),
                  Size((2 * markerSize) * animationFactor,
                      (2 * markerSize) * animationFactor),
                  _series)
              .getBounds(),
          _series._chart._requireInvertedAxis);
    }
    canvas.drawPath(markerPath, markerPaint);
    final Paint markerBorderPaint = Paint();
    markerBorderPaint.color = Colors.white.withOpacity(tooltip.opacity);
    markerBorderPaint.strokeWidth = 1;
    markerBorderPaint.style = PaintingStyle.stroke;
    canvas.drawPath(markerPath, markerBorderPaint);
  }

  /// draw tooltip header, divider,text
  void _drawTooltipText(Canvas canvas, RRect tooltipRect,
      ChartTextStyle textStyle, Size result, double animationFactor) {
    const double padding = 10;
    final num _maxLinesOfTooltipContent = getMaxLinesContent(stringValue);
    if (header != null && header.isNotEmpty) {
      final ChartTextStyle headerTextStyle = ChartTextStyle(
          color: tooltip.textStyle.color?.withOpacity(tooltip.opacity) ??
              _chart._chartState._chartTheme.tooltipLabelColor,
          fontSize: tooltip.textStyle.fontSize * animationFactor,
          fontFamily: tooltip.textStyle.fontFamily,
          fontStyle: tooltip.textStyle.fontStyle,
          fontWeight: FontWeight.bold);
      final Size headerResult = _measureText(header, headerTextStyle);

      _drawText(
          tooltip,
          canvas,
          header,
          Offset(
              (tooltipRect.left + tooltipRect.width / 2) -
                  headerResult.width / 2,
              tooltipRect.top + padding / 2),
          headerTextStyle);

      final Paint dividerPaint = Paint();
      dividerPaint.color = _chart._chartState._chartTheme.tooltipLabelColor
          .withOpacity(tooltip.opacity);
      dividerPaint.strokeWidth = 0.5 * animationFactor;
      dividerPaint.style = PaintingStyle.stroke;

      canvas.drawLine(
          Offset(tooltipRect.left + padding,
              tooltipRect.top + headerResult.height + padding),
          Offset(tooltipRect.right - padding,
              tooltipRect.top + headerResult.height + padding),
          dividerPaint);
      markerPointY = tooltipRect.top + headerResult.height + (padding * 2) + 6;
      _drawText(
          tooltip,
          canvas,
          stringValue,
          Offset(
              (tooltipRect.left + 2 * markerSize + tooltipRect.width / 2) -
                  result.width / 2,
              (tooltipRect.top + tooltipRect.height) - result.height - 5),
          textStyle,
          _maxLinesOfTooltipContent);
    } else {
      _drawText(
          tooltip,
          canvas,
          stringValue,
          Offset(
              (tooltipRect.left + 2 * markerSize + tooltipRect.width / 2) -
                  result.width / 2,
              (tooltipRect.top + tooltipRect.height / 2) - result.height / 2),
          textStyle,
          _maxLinesOfTooltipContent);
    }
  }

  ///draw tooltip text
  void _drawText(dynamic tooltip, Canvas canvas, String text, Offset point,
      ChartTextStyle style,
      [int maxLines, int rotation]) {
    TextAlign tooltipTextAlign = TextAlign.start;
    if (tooltip != null &&
        tooltip.format != null &&
        tooltip.format.isNotEmpty) {
      if (tooltip.textAlignment == ChartAlignment.near) {
        tooltipTextAlign = TextAlign.start;
      } else if (tooltip.textAlignment == ChartAlignment.center) {
        tooltipTextAlign = TextAlign.center;
      } else if (tooltip.textAlignment == ChartAlignment.far) {
        tooltipTextAlign = TextAlign.end;
      }
    }

    final Color color = style.color;
    final double fontSize = style.fontSize;
    final String fontFamily = style.fontFamily;
    final FontStyle fontStyle = style.fontStyle;
    final FontWeight fontWeight = style.fontWeight;
    final TextSpan span = TextSpan(
        text: text,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontStyle: fontStyle,
            fontWeight: fontWeight));

    final TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: tooltipTextAlign,
        maxLines: maxLines ?? 1);
    tp.layout();
    canvas.save();
    canvas.translate(point.dx, point.dy);
    if (rotation != null && rotation > 0) {
      canvas.rotate(_degreeToRadian(rotation));
    }
    tp.paint(canvas, const Offset(0.0, 0.0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void show(double x, double y) {
    if (tooltip.enable &&
        tooltip._painter != null &&
        tooltip._painter._chart._chartState.animateCompleted) {
      tooltip._painter.canResetPath = false;
      tooltip._painter._renderTooltipView(Offset(x, y));
      if (tooltip._painter.prevTooltipValue != null &&
          tooltip._painter.currentTooltipValue == null &&
          !(tooltip.tooltipPosition == TooltipPosition.pointer)) {
        chartTooltipState.animationController.forward(from: 0.0);
        tooltip._painter.currentTooltipValue =
            tooltip._painter.prevTooltipValue;
      } else {
        if (tooltip.tooltipPosition == TooltipPosition.pointer) {
          chartTooltipState.animationController.forward(from: 0.0);
          tooltip._painter.currentTooltipValue =
              tooltip._painter.prevTooltipValue;
        }
      }
      if (tooltip._painter.timer != null) {
        tooltip._painter.timer.cancel();
      }
      if (!tooltip.shouldAlwaysShow) {
        tooltip._painter.timer =
            Timer(Duration(milliseconds: tooltip.duration.toInt()), () {
          chartTooltipState.show = false;
          tooltip._painter.currentTooltipValue =
              tooltip._painter.prevTooltipValue = null;
          chartTooltipState.tooltipRepaintNotifier.value++;
          tooltip._painter.canResetPath = true;
        });
      }
    }
  }

  //this method shows the tooltip for any logical pixel outside point region
  //ignore: unused_element
  void _showChartAreaTooltip(
      Offset position, ChartAxis xAxis, ChartAxis yAxis) {
    if (tooltip.enable &&
        tooltip._painter != null &&
        tooltip._painter._chart._chartState.animateCompleted) {
      chartTooltipState.animationController.forward(from: 0.0);
      tooltip._painter.canResetPath = false;
      //render
      final SfCartesianChart chart = tooltip._painter._chart;
      chart.tooltipBehavior._painter.boundaryRect =
          chart._chartAxis._axisClipRect;
      if (chart._chartAxis._axisClipRect.contains(position)) {
        chart.tooltipBehavior._painter.currentSeries = chart.series[0];
        chart.tooltipBehavior._painter.series = chart.series[0];
        chart.tooltipBehavior._painter.padding = 5;
        chart.tooltipBehavior._painter.header = null;
        dynamic xValue = _pointToXValue(
            chart,
            xAxis,
            xAxis._bounds,
            position.dx -
                (chart._chartAxis._axisClipRect.left + xAxis.plotOffset),
            position.dy -
                (chart._chartAxis._axisClipRect.top + xAxis.plotOffset));
        dynamic yValue = _pointToYValue(
            chart,
            yAxis,
            yAxis._bounds,
            position.dx -
                (chart._chartAxis._axisClipRect.left + yAxis.plotOffset),
            position.dy -
                (chart._chartAxis._axisClipRect.top + yAxis.plotOffset));
        if (xAxis is DateTimeAxis)
          xValue = (xAxis.dateFormat ?? xAxis._getLabelFormat(xAxis))
              .format(DateTime.fromMillisecondsSinceEpoch(xValue.floor()));
        else if (xAxis is CategoryAxis)
          xValue = xAxis._visibleLabels[xValue.toInt()].text;
        else if (xAxis is NumericAxis)
          xValue = xValue.toStringAsFixed(2).contains('.00')
              ? xValue.floor()
              : xValue.toStringAsFixed(2);

        if (yAxis is DateTimeAxis)
          yValue = (yAxis.dateFormat ?? yAxis._getLabelFormat(yAxis))
              .format(DateTime.fromMillisecondsSinceEpoch(yValue.floor()));
        else if (yAxis is NumericAxis)
          yValue = yValue.toStringAsFixed(2).contains('.00')
              ? yValue.floor()
              : yValue.toStringAsFixed(2);
        chart.tooltipBehavior._painter.stringValue = ' $xValue :  $yValue ';
        chart.tooltipBehavior._painter._calculateLocation(position);
      }
      if (tooltip._painter.timer != null) {
        tooltip._painter.timer.cancel();
      }
      if (!tooltip.shouldAlwaysShow) {
        tooltip._painter.timer =
            Timer(Duration(milliseconds: tooltip.duration.toInt()), () {
          chartTooltipState.show = false;
          chartTooltipState.tooltipRepaintNotifier.value++;
          tooltip._painter.canResetPath = true;
        });
      }
    }
  }

  void hide() {
    if (tooltip._painter.timer != null) {
      tooltip._painter.timer.cancel();
    }

    if (tooltip._painter.prevTooltipValue == null &&
        tooltip._painter.currentTooltipValue == null) {
      tooltip._painter.timer =
          Timer(Duration(milliseconds: tooltip.duration.toInt()), () {
        chartTooltipState.show = false;
        tooltip._painter.currentTooltipValue =
            tooltip._painter.prevTooltipValue = null;
        chartTooltipState.tooltipRepaintNotifier.value++;
        tooltip._painter.canResetPath = true;
      });
    }
  }

  void showMouseTooltip(double x, double y) {
    if (tooltip.enable &&
        tooltip._painter != null &&
        tooltip._painter._chart._chartState.animateCompleted) {
      tooltip._painter.canResetPath = false;
      tooltip._painter._renderTooltipView(Offset(x, y));
      if (tooltip._painter.timer != null) {
        tooltip._painter.timer.cancel();
      }
      if (tooltip._painter.prevTooltipValue != null &&
          tooltip._painter.currentTooltipValue == null) {
        chartTooltipState.animationController.forward(from: 0.0);
        tooltip._painter.currentTooltipValue =
            tooltip._painter.prevTooltipValue;
      }
      if (tooltip._painter._chart is SfCartesianChart) {
        hide();
      }
    }
  }
}
