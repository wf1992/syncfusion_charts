part of charts;

/// Returns the LegendRenderArgs.
typedef FunnelLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArganimateCompleteds);

/// Returns the TooltipArgs.
typedef FunnelTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the DataLabelRenderArgs.
typedef FunnelDataLabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the SelectionArgs.
typedef FunnelSelectionCallback = void Function(SelectionArgs selectionArgs);

///Renders the funnel chart
///
///A funnel chart is a specialized chart type that demonstrates the flow of users through a business or sales process.
/// The chart begins with a broad head and ends in a narrow neck.
///
/// The number of users at each stage of the process are indicated from the funnel's width as it narrows
///
/// To render a funnel chart, create an instance of FunnelSeries, and add it to the series property of [SfFunnelChart].
//ignore:must_be_immutable
class SfFunnelChart extends StatefulWidget {
  SfFunnelChart({
    Key key,
    this.backgroundColor,
    this.backgroundImage,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.onLegendItemRender,
    this.onTooltipRender,
    this.onDataLabelRender,
    this.onLegendTapped,
    this.onSelectionChanged,
    ChartTitle title,
    FunnelSeries<dynamic, dynamic> series,
    EdgeInsets margin,
    Legend legend,
    this.palette = const <Color>[
      Color.fromRGBO(53, 92, 125, 1),
      Color.fromRGBO(192, 108, 132, 1),
      Color.fromRGBO(246, 114, 128, 1),
      Color.fromRGBO(248, 177, 149, 1),
      Color.fromRGBO(116, 180, 155, 1),
      Color.fromRGBO(0, 168, 181, 1),
      Color.fromRGBO(73, 76, 162, 1),
      Color.fromRGBO(255, 205, 96, 1),
      Color.fromRGBO(255, 240, 219, 1),
      Color.fromRGBO(238, 238, 238, 1)
    ],
    TooltipBehavior tooltipBehavior,
    SmartLabelMode smartLabelMode,
    ActivationMode selectionGesture,
    bool enableMultiSelection,
  })  : title = title ?? ChartTitle(),
        series = series ?? FunnelSeries<dynamic, dynamic>(),
        margin = margin ?? const EdgeInsets.fromLTRB(10, 10, 10, 10),
        legend = legend ?? Legend(),
        tooltipBehavior = tooltipBehavior ?? TooltipBehavior(),
        smartLabelMode = smartLabelMode ?? SmartLabelMode.hide,
        selectionGesture = selectionGesture ?? ActivationMode.singleTap,
        enableMultiSelection = enableMultiSelection ?? false,
        super(key: key) {
    _chartSeries = _FunnelSeries();
    _chartLegend = _ChartLegend();
    _funnelplotArea = _FunnelPlotArea();
  }

  ///Customizes the chart title
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            title: ChartTitle(text: 'Funnel Chart')
  ///        ));
  ///}
  ///```
  final ChartTitle title;

  ///Background color of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color backgroundColor;

  ///Background color of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Customizes the chart series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<_FunnelData, String>(
  ///                          dataSource: data,
  ///                          xValueMapper: (_FunnelData data, _) => data.xData,
  ///                          yValueMapper: (_FunnelData data, _) => data.yData)
  ///        ));
  ///}
  ///```
  final FunnelSeries<dynamic, dynamic> series;

  ///Margin for chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            margin: const EdgeInsets.all(2),
  ///        ));
  ///}
  ///```
  final EdgeInsets margin;

  ///Customizes the legend in the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            legend: Legend(isVisible: true)
  ///        ));
  ///}
  ///```
  final Legend legend;

  ///Color palette for the data points in the chart series.
  ///
  ///If the series color is not specified, then the series will be rendered with appropriate palette color.
  ///
  ///Ten colors are available by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        ));
  ///}
  ///```
  final List<Color> palette;

  ///Customizes the tooltip in chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///        ));
  ///}
  ///```
  final TooltipBehavior tooltipBehavior;

  /// Occurs while legend is rendered.
  ///
  ///  Here, you can get the legend's text, shape, series index, and point index case of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRendererArgs args) => legend(args),
  ///        ));
  ///}
  ///dynamic legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  ///}
  ///```
  final FunnelLegendRenderCallback onLegendItemRender;

  /// Occurs while tooltip is rendered.
  ///
  ///  Here, you can get the Tooltip render arguments and customize them.
  final FunnelTooltipCallback onTooltipRender;

  /// Occurs when the data label is rendered
  ///
  /// Here we can get get the datalabel render arguments and customise the datalabel parameters.
  final FunnelDataLabelRenderCallback onDataLabelRender;

  ///occurs when the legend is tapped ,using this event the legend tap arguments can be customized.
  final ChartLegendTapCallback onLegendTapped;

  ///Overlapping of the labels can be avoided by using the smartLabelMode property.
  ///
  ///The default value is true for accumulation type series and false for other series types.
  final SmartLabelMode smartLabelMode;

  ///Data points or series can be selected while performing interaction on the chart.
  ///
  ///It can also be selected at the initial rendering using this property.
  ///
  ///Defaults to `[]`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///           series: FunnelSeries<ChartData, String>(
  ///                  initialSelectedDataIndexes: <int>[1,0],
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```

  ///Gesture for activating the selection.
  ///
  ///Selection can be activated in tap, double tap, and long press.
  ///
  ///Defaults to `ActivationMode.tap`.
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///           selectionGesture: ActivationMode.singleTap,
  ///           series: FunnelSeries<ChartData, String>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```
  final ActivationMode selectionGesture;

  ///Enables or disables the multiple data points selection.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///           enableMultiSelection: true,
  ///           series: FunnelSeries<ChartData, String>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```
  final bool enableMultiSelection;

  ///Background image for chart.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        ));
  ///}
  ///```
  final ImageProvider backgroundImage;

  final FunnelSelectionCallback onSelectionChanged;

  //Internal variables
  String _seriesType;
  List<PointInfo<dynamic>> _dataPoints;
  List<PointInfo<dynamic>> _renderPoints;
  _FunnelSeries _chartSeries;
  _SfFunnelChartState _chartState;
  _ChartLegend _chartLegend;
  //ignore: unused_field
  _FunnelPlotArea _funnelplotArea;
  @override
  State<StatefulWidget> createState() => _SfFunnelChartState();
}

class _SfFunnelChartState extends State<SfFunnelChart>
    with TickerProviderStateMixin {
  List<AnimationController>
      controllerList; // Holds the animation controller list for all series
  AnimationController
      animationController; // Animation controller for Annotations
  AnimationController annotationController;
  ValueNotifier<int> seriesRepaintNotifier;
  List<_MeasureWidgetContext>
      legendWidgetContext; // To measure legend size and position
  List<_ChartTemplateInfo> templates; // Chart Template info
  List<Widget> _chartWidgets;

  /// Holds the information of chart theme arguments
  SfChartThemeData _chartTheme;
  Rect chartContainerRect;
  Rect chartAreaRect;
  _ChartTemplate _chartTemplate;
  _ChartInteraction currentActive;
  bool initialRender;
  List<_LegendRenderContext> legendToggleStates;
  List<_MeasureWidgetContext> legendToggleTemplateStates;
  bool _isLegendToggled;
  Offset _tapPosition;
  bool animateCompleted;
  Animation<double> chartElementAnimation;
  _FunnelDataLabelRenderer renderDataLabel;
  bool widgetNeedUpdate;
  List<int> explodedPoints;
  List<Rect> dataLabelTemplateRegions;
  List<int> selectionData;
  int _tooltipPointIndex;

  @override
  void initState() {
    _initializeDefaultValues();
    super.initState();
  }

  void _initializeDefaultValues() {
    initialRender = true;
    controllerList = <AnimationController>[];
    annotationController = AnimationController(vsync: this);
    seriesRepaintNotifier = ValueNotifier<int>(0);
    legendToggleStates = <_LegendRenderContext>[];
    legendToggleTemplateStates = <_MeasureWidgetContext>[];
    explodedPoints = <int>[];
    animateCompleted = true;
    _isLegendToggled = false;
    widgetNeedUpdate = false;
    dataLabelTemplateRegions = <Rect>[];
    selectionData = <int>[];
    legendWidgetContext = <_MeasureWidgetContext>[];
    animationController = AnimationController(vsync: this)
      ..addListener(repaintChartElements);
  }

  @override
  void didChangeDependencies() {
    _chartTheme = SfChartTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfFunnelChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isLegendToggled = false;
    widgetNeedUpdate = true;
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController.removeListener(repaintChartElements);
      animationController.dispose();
      animationController = null;
    }
    super.dispose();
  }

  void repaintChartElements() {
    seriesRepaintNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    //SyncfusionLicense.validateLicense(context);
    widget._chartState = this;
    return Container(
        child: GestureDetector(
            child: Container(
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    image: widget.backgroundImage != null
                        ? DecorationImage(
                            image: widget.backgroundImage, fit: BoxFit.fill)
                        : null,
                    border: Border.all(
                        color: widget.borderColor, width: widget.borderWidth)),
                child: Column(
                  children: <Widget>[
                    _renderChartTitle(widget),
                    _renderChartElements()
                  ],
                ))));
  }

  Widget _renderChartElements() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Widget element;
      if (widget.series.dataSource != null) {
        _initialize(constraints);
        widget._chartSeries._findVisibleSeries();
        widget._chartSeries._processDataPoints();
        final List<Widget> legendTemplates = _bindLegendTemplateWidgets(widget);
        if (legendTemplates.isNotEmpty && legendWidgetContext.isEmpty) {
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance.addPostFrameCallback((_) => _refresh());
        } else {
          widget._chartLegend
              ._calculateLegendBounds(widget._chartLegend.chartSize);
          element =
              _getElements(widget, _FunnelPlotArea(chart: widget), constraints);
        }
      } else {
        element = Container();
      }
      return element;
    }));
  }

  void _refresh() {
    if (widget._chartState.legendWidgetContext.isNotEmpty) {
      for (int i = 0; i < widget._chartState.legendWidgetContext.length; i++) {
        final _MeasureWidgetContext templateContext =
            widget._chartState.legendWidgetContext[i];
        final RenderBox renderBox = templateContext.context.findRenderObject();
        templateContext.size = renderBox.size;
      }
      setState(() {});
    }
  }

  // ignore:unused_element
  void _redraw() {
    widget._chartState.initialRender = false;
    setState(() {});
  }

  void _initialize(BoxConstraints constraints) {
    widget._chartLegend.chart = widget;
    widget._chartSeries.chart = widget;
    widget._chartState._chartWidgets = <Widget>[];
    final dynamic width = constraints.maxWidth;
    final dynamic height = constraints.maxHeight;
    final EdgeInsets margin = widget.margin;
    if (widget.legend.position == LegendPosition.auto) {
      widget.legend.legendPosition =
          height > width ? LegendPosition.bottom : LegendPosition.right;
    } else {
      widget.legend.legendPosition = widget.legend.position;
    }
    widget._chartLegend.chartSize = Size(width - margin.left - margin.right,
        height - margin.top - margin.bottom);
  }
}

// ignore: must_be_immutable
class _FunnelPlotArea extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _FunnelPlotArea({this.chart});
  final SfFunnelChart chart;
  FunnelSeries<dynamic, dynamic> series;
  RenderBox renderBox;
  _Region pointRegion;
  TapDownDetails tapDownDetails;
  Offset doubleTapPosition;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          child: Stack(children: <Widget>[
        _initializeChart(constraints, context),
        MouseRegion(
            child: Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                decoration: const BoxDecoration(color: Colors.transparent)),
            onHover: (PointerEvent event) => _onHover(event),
            onExit: (PointerEvent event) {
              chart.tooltipBehavior._isHovering = false;
            }),
        Listener(
            onPointerUp: (PointerUpEvent event) => _onTapUp(event),
            onPointerDown: (PointerDownEvent event) => _onTapDown(event),
            child: GestureDetector(
                onLongPress: _onLongPress,
                onDoubleTap: _onDoubleTap,
                child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: _initializeChart(constraints, context))))
      ]));
    });
  }

  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateSize(constraints);
    return GestureDetector(
        child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: _renderWidgets(constraints, context)));
  }

  void _calculateSize(BoxConstraints constraints) {
    final dynamic width = constraints.maxWidth;
    final dynamic height = constraints.maxHeight;
    chart._chartState.chartContainerRect = Rect.fromLTWH(0, 0, width, height);
    final EdgeInsets margin = chart.margin;
    chart._chartState.chartAreaRect = Rect.fromLTWH(
        margin.left,
        margin.top,
        width - margin.right - margin.left,
        height - margin.top - margin.bottom);
  }

  Widget _renderWidgets(BoxConstraints constraints, BuildContext context) {
    _bindSeriesWidgets();
    _calculatePathRegion();
    _findTemplates(chart);
    _renderTemplates(chart);
    _bindTooltipWidgets(constraints);
    renderBox = context.findRenderObject();
    chart._funnelplotArea = this;
    return Container(child: Stack(children: chart._chartState._chartWidgets));
  }

  void _calculatePathRegion() {
    if (chart._chartSeries.visibleSeries.isNotEmpty) {
      final FunnelSeries<dynamic, dynamic> series =
          chart._chartSeries.visibleSeries[0];
      for (int i = 0; i < series._renderPoints.length; i++) {
        if (series._renderPoints[i].isVisible) {
          chart._chartSeries._calculateFunnelPathRegion(i);
        }
      }
    }
  }

  void _bindSeriesWidgets() {
    CustomPainter seriesPainter;
    Animation<double> seriesAnimation;
    for (int i = 0; i < chart._chartSeries.visibleSeries.length; i++) {
      series = chart._chartSeries.visibleSeries[i];
      chart._chartSeries._initializeSeriesProperties(series);
      if (series.selectionSettings != null) {
        if (series.initialSelectedDataIndexes.isNotEmpty) {
          for (int index = 0;
              index < series.initialSelectedDataIndexes.length;
              index++) {
            chart._chartState.selectionData
                .add(series.initialSelectedDataIndexes[index]);
          }
        }
      }
      if (series.animationDuration > 0 &&
          (chart._chartState.initialRender ||
              chart._chartState.widgetNeedUpdate ||
              chart._chartState._isLegendToggled)) {
        chart._chartState.animationController.duration =
            Duration(milliseconds: series.animationDuration.toInt());
        seriesAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: chart._chartState.animationController,
          curve: const Interval(0.1, 0.8, curve: Curves.linear),
        )..addStatusListener((AnimationStatus status) {
                if (status == AnimationStatus.completed) {
                  chart._chartState.animateCompleted = true;
                  if (chart._chartState.renderDataLabel != null) {
                    chart._chartState.renderDataLabel.state.render();
                  }
                  if (chart._chartState._chartTemplate != null &&
                      chart._chartState._chartTemplate.state != null) {
                    chart._chartState._chartTemplate.state.templateRender();
                  }
                }
              }));
        chart._chartState.chartElementAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: chart._chartState.animationController,
          curve: const Interval(0.85, 1.0, curve: Curves.decelerate),
        ));
        chart._chartState.animationController.forward(from: 0.0);
      } else {
        chart._chartState.animateCompleted = true;
      }
      seriesPainter = _FunnelChartPainter(
          chart: chart,
          seriesIndex: i,
          isRepaint: series._needsRepaint,
          animationController: chart._chartState.animationController,
          seriesAnimation: seriesAnimation,
          notifier: chart._chartState.seriesRepaintNotifier);
      chart._chartState._chartWidgets
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      chart._chartState.renderDataLabel = _FunnelDataLabelRenderer(
          funnelChart: chart,
          show: series.animationDuration > 0
              ? false
              : chart._chartState.animateCompleted);
      chart._chartState._chartWidgets.add(chart._chartState.renderDataLabel);
    }
  }

  void _bindTooltipWidgets(BoxConstraints constraints) {
    if (chart.tooltipBehavior.enable) {
      if (chart.tooltipBehavior.builder != null) {
        chart.tooltipBehavior._tooltipTemplate = _TooltipTemplate(
            show: false, clipRect: chart._chartState.chartContainerRect);
        chart.tooltipBehavior._chart = chart;
        chart._chartState._chartWidgets
            .add(chart.tooltipBehavior._tooltipTemplate);
      } else {
        chart.tooltipBehavior._chart = chart;
        chart.tooltipBehavior.chartTooltip =
            _ChartTooltipRenderer(chartWidget: chart);
        chart._chartState._chartWidgets.add(chart.tooltipBehavior.chartTooltip);
      }
    }
  }

  // void tapDown(PointerDownEvent event) {
  //   _onTapDown(event);
  //   _onTapUp(PointerUpEvent(position:event.position));
  // }

  void _onTapDown(PointerDownEvent event) {
    // renderBox = context.findRenderObject();
    chart.tooltipBehavior._isHovering = false;
    chart._chartState.currentActive = null;
    chart._chartState._tapPosition = renderBox.globalToLocal(event.position);
    bool isPoint;
    const num seriesIndex = 0;
    num pointIndex;
    final FunnelSeries<dynamic, dynamic> series =
        chart._chartSeries.visibleSeries[seriesIndex];
    for (int j = 0; j < series._renderPoints.length; j++) {
      if (series._renderPoints[j].isVisible) {
        isPoint = _isPointInPolygon(
            series._renderPoints[j].pathRegion, chart._chartState._tapPosition);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    doubleTapPosition = chart._chartState._tapPosition;
    if (chart._chartState._tapPosition != null && isPoint != null && isPoint) {
      chart._chartState.currentActive = _ChartInteraction(
        seriesIndex,
        pointIndex,
        chart._chartSeries.visibleSeries[seriesIndex],
        chart._chartSeries.visibleSeries[seriesIndex]._renderPoints[pointIndex],
      );
    } else {
      //hides the tooltip if the point of interaction is outside funnel region of the chart
      chart.tooltipBehavior._tooltipTemplate.show = false;
      chart.tooltipBehavior?._tooltipTemplate?.state?.hideOnTimer();
    }
  }

  void _onDoubleTap() {
    const num seriesIndex = 0;
    if (doubleTapPosition != null && chart._chartState.currentActive != null) {
      final num pointIndex = chart._chartState.currentActive.pointIndex;
      chart._chartState.currentActive = _ChartInteraction(
          seriesIndex,
          pointIndex,
          chart._chartSeries.visibleSeries[seriesIndex],
          chart._chartSeries.visibleSeries[seriesIndex]
              ._renderPoints[pointIndex]);
      if (chart._chartState.currentActive != null) {
        if (chart._chartState.currentActive.series.explodeGesture ==
            ActivationMode.doubleTap) {
          chart._chartSeries._pointExplode(pointIndex);
        }
      }
      chart._chartSeries
          ._seriesPointSelection(pointIndex, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        if (chart.tooltipBehavior.builder != null) {
          _showFunnelTooltipTemplate();
        } else {
          chart.tooltipBehavior.onDoubleTap(
              doubleTapPosition.dx.toDouble(), doubleTapPosition.dy.toDouble());
        }
      }
    }
  }

  void _onLongPress() {
    const num seriesIndex = 0;
    if (chart._chartState._tapPosition != null &&
        chart._chartState.currentActive != null) {
      final num pointIndex = chart._chartState.currentActive.pointIndex;
      chart._chartState.currentActive = _ChartInteraction(
          seriesIndex,
          pointIndex,
          chart._chartSeries.visibleSeries[seriesIndex],
          chart._chartSeries.visibleSeries[seriesIndex]
              ._renderPoints[pointIndex],
          pointRegion);
      chart._chartSeries
          ._seriesPointSelection(pointIndex, ActivationMode.longPress);
      if (chart._chartState.currentActive != null) {
        if (chart._chartState.currentActive.series.explodeGesture ==
            ActivationMode.longPress) {
          chart._chartSeries._pointExplode(pointIndex);
        }
      }
      if (chart.tooltipBehavior.enable &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        if (chart.tooltipBehavior.builder != null) {
          _showFunnelTooltipTemplate();
        } else {
          chart.tooltipBehavior.onLongPress(
              chart._chartState._tapPosition.dx.toDouble(),
              chart._chartState._tapPosition.dy.toDouble());
        }
      }
    }
  }

  void _onTapUp(PointerUpEvent event) {
    chart.tooltipBehavior._isHovering = false;
    chart._chartState._tapPosition = renderBox.globalToLocal(event.position);
    if (chart._chartState._tapPosition != null) {
      if (chart._chartState.currentActive != null &&
          chart._chartState.currentActive.series != null &&
          chart._chartState.currentActive.series.explodeGesture ==
              ActivationMode.singleTap) {
        chart._chartSeries
            ._pointExplode(chart._chartState.currentActive.pointIndex);
      }
      if (chart._chartState._tapPosition != null &&
          chart._chartState.currentActive != null) {
        chart._chartSeries._seriesPointSelection(
            chart._chartState.currentActive.pointIndex,
            ActivationMode.singleTap);
      }
      if (chart.tooltipBehavior.enable &&
          chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
          chart._chartState.currentActive != null &&
          chart._chartState.currentActive.series != null) {
        if (chart.tooltipBehavior.builder != null) {
          _showFunnelTooltipTemplate();
        } else {
          // final RenderBox renderBox = context.findRenderObject();
          final Offset position = renderBox.globalToLocal(event.position);
          chart.tooltipBehavior
              .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
        }
      }
    }
    chart._chartState._tapPosition = null;
  }

  void _onHover(PointerEvent event) {
    chart._chartState.currentActive = null;
    chart._chartState._tapPosition = renderBox.globalToLocal(event.position);
    bool isPoint;
    const num seriesIndex = 0;
    num pointIndex;
    final FunnelSeries<dynamic, dynamic> series =
        chart._chartSeries.visibleSeries[seriesIndex];
    for (int j = 0; j < series._renderPoints.length; j++) {
      if (series._renderPoints[j].isVisible) {
        isPoint = _isPointInPolygon(
            series._renderPoints[j].pathRegion, chart._chartState._tapPosition);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    if (chart._chartState._tapPosition != null && isPoint) {
      chart._chartState.currentActive = _ChartInteraction(
        seriesIndex,
        pointIndex,
        chart._chartSeries.visibleSeries[seriesIndex],
        chart._chartSeries.visibleSeries[seriesIndex]._renderPoints[pointIndex],
      );
    } else {
      //hides the tooltip if the point of interaction is outside funnel region of the chart
      chart.tooltipBehavior?._tooltipTemplate?.show = false;
      chart.tooltipBehavior?._tooltipTemplate?.state?.hideOnTimer();
    }
    if (chart._chartState._tapPosition != null) {
      if (chart.tooltipBehavior.enable &&
          chart._chartState.currentActive != null &&
          chart._chartState.currentActive.series != null) {
        chart.tooltipBehavior._isHovering = true;
        if (chart.tooltipBehavior.builder != null) {
          _showFunnelTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          chart.tooltipBehavior
              .onEnter(position.dx.toDouble(), position.dy.toDouble());
        }
      } else {
        chart?.tooltipBehavior?._painter?.prevTooltipValue = null;
        chart?.tooltipBehavior?._painter?.currentTooltipValue = null;
        chart?.tooltipBehavior?._painter?.hide();
      }
    }
    chart._chartState._tapPosition = null;
  }

  // this method gets executed for showing tooltip when builder is provided in behavior
  void _showFunnelTooltipTemplate([int pointIndex]) {
    chart.tooltipBehavior._tooltipTemplate?._alwaysShow =
        chart.tooltipBehavior.shouldAlwaysShow;
    if (!chart.tooltipBehavior._isHovering) {
      //assingning null for the previous and current tooltip values in case of touch interaction
      chart.tooltipBehavior._tooltipTemplate?.state?.prevTooltipValue = null;
      chart.tooltipBehavior._tooltipTemplate?.state?.currentTooltipValue = null;
    }
    final FunnelSeries<dynamic, dynamic> chartSeries =
        chart._chartState.currentActive?.series ?? chart.series;
    final PointInfo<dynamic> point = pointIndex == null
        ? chart._chartState.currentActive?.point
        : chart.series._dataPoints[pointIndex];
    final Offset location = point.symbolLocation;
    if (location != null && (chartSeries.enableTooltip ?? true)) {
      chart.tooltipBehavior._tooltipTemplate.rect =
          Rect.fromLTWH(location.dx, location.dy, 0, 0);
      chart.tooltipBehavior._tooltipTemplate.template = chart.tooltipBehavior
          .builder(
              chartSeries.dataSource[
                  pointIndex ?? chart._chartState.currentActive?.pointIndex],
              point,
              chartSeries,
              0,
              pointIndex ?? chart._chartState.currentActive?.pointIndex);
      if (chart.tooltipBehavior._isHovering) {
        //assingning values for the previous and current tooltip values on mouse hover
        chart.tooltipBehavior._tooltipTemplate.state.prevTooltipValue =
            chart.tooltipBehavior._tooltipTemplate.state.currentTooltipValue;
        chart.tooltipBehavior._tooltipTemplate.state.currentTooltipValue =
            TooltipValue(
                0, pointIndex ?? chart._chartState.currentActive?.pointIndex);
      }
      chart.tooltipBehavior._tooltipTemplate.show = true;
      chart.tooltipBehavior._tooltipTemplate?.state?._performTooltip();
    }
  }
}
