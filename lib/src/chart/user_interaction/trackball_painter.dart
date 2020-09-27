part of charts;

class _TrackballPainter extends CustomPainter {
  _TrackballPainter({this.chart, this.valueNotifier})
      : super(repaint: valueNotifier);
  final SfCartesianChart chart;
  Timer timer;
  ValueNotifier<int> valueNotifier;
  double pointerLength;
  double pointerWidth;
  double nosePointY = 0;
  double nosePointX = 0;
  double totalWidth = 0;
  double x;
  double y;
  double xPos;
  double yPos;
  bool isTop = false;
  double borderRadius;
  Path backgroundPath = Path();
  bool canResetPath = false;
  bool isLeft = false;
  bool isRight = false;
  bool enable;
  double padding = 0;
  double groupAllPadding = 10;
  List<String> stringValue = <String>[];
  Rect boundaryRect = const Rect.fromLTWH(0, 0, 0, 0);
  double leftPadding = 0;
  double topPadding = 0;
  bool isHorizontalOrientation = false;
  bool isRectSeries = false;
  ChartTextStyle labelStyle;
  List<_ChartPointInfo> chartPointInfo = <_ChartPointInfo>[];
  bool divider = true;

  @override
  void paint(Canvas canvas, Size size) =>
      chart.trackballBehavior.onPaint(canvas);

  Paint _getLinePainter(Paint trackballLinePaint) => trackballLinePaint;

  void _drawTrackball(Canvas canvas) {
    borderRadius = chart.trackballBehavior.tooltipSettings.borderRadius;
    pointerLength = chart.trackballBehavior.tooltipSettings.arrowLength;
    pointerWidth = chart.trackballBehavior.tooltipSettings.arrowWidth;
    isLeft = false;
    isRight = false;
    double height = 0, width = 0;
    boundaryRect = chart._chartAxis._axisClipRect;
    totalWidth = boundaryRect.left + boundaryRect.width;
    labelStyle = ChartTextStyle(
        color: chart.trackballBehavior.tooltipSettings.textStyle.color ??
            chart._chartState._chartTheme.crosshairLabelColor,
        fontSize: chart.trackballBehavior.tooltipSettings.textStyle.fontSize,
        fontFamily:
            chart.trackballBehavior.tooltipSettings.textStyle.fontFamily,
        fontStyle: chart.trackballBehavior.tooltipSettings.textStyle.fontStyle,
        fontWeight:
            chart.trackballBehavior.tooltipSettings.textStyle.fontWeight);

    for (int index = 0; index < chartPointInfo.length; index++) {
      if (((chartPointInfo[index].series._seriesType == 'column' ||
                  chartPointInfo[index]
                      .series
                      ._seriesType
                      .contains('stackedcolumn') ||
                  chartPointInfo[index].series._seriesType == 'rangecolumn' ||
                  chartPointInfo[index].series._seriesType == 'candle' ||
                  chartPointInfo[index].series._seriesType.contains('hilo')) &&
              !chart.isTransposed) ||
          (chartPointInfo[index].series._seriesType == 'bar' ||
              chartPointInfo[index].series._seriesType.contains('stackedbar') &&
                  chart.isTransposed)) {
        isHorizontalOrientation = true;
      }
      isRectSeries = false;
      if (((chartPointInfo[index].series._seriesType == 'column' ||
                  chartPointInfo[index]
                      .series
                      ._seriesType
                      .contains('stackedcolumn') ||
                  chartPointInfo[index].series._seriesType == 'rangecolumn' ||
                  chartPointInfo[index].series._seriesType == 'candle' ||
                  chartPointInfo[index].series._seriesType.contains('hilo')) &&
              chart.isTransposed) ||
          ((chartPointInfo[index].series._seriesType == 'bar' ||
                  chartPointInfo[index]
                      .series
                      ._seriesType
                      .contains('stackedbar')) &&
              !chart.isTransposed)) {
        isRectSeries = true;
      }
      if (!canResetPath &&
          chart.trackballBehavior.lineType != TrackballLineType.none) {
        final Paint trackballLinePaint = Paint();
        trackballLinePaint.color = chart.trackballBehavior.lineColor ??
            chart._chartState._chartTheme.crosshairLineColor;
        trackballLinePaint.strokeWidth = chart.trackballBehavior.lineWidth;
        trackballLinePaint.style = PaintingStyle.stroke;
        chart.trackballBehavior.lineWidth == 0
            ? trackballLinePaint.color = Colors.transparent
            : trackballLinePaint.color = trackballLinePaint.color;
        chart.trackballBehavior._drawLine(canvas,
            chart.trackballBehavior._linePainter(trackballLinePaint), index);
      }
      final Size size = _getTooltipSize(height, width, index);
      height = size.height;
      width = size.width;
      if (width < 10) {
        width = 10; // minimum width for tooltip to render
        borderRadius = borderRadius > 5 ? 5 : borderRadius;
      }
      if (borderRadius > 15) {
        borderRadius = 15;
      }
      padding = 5;
      if (x != null &&
          y != null &&
          chart.trackballBehavior.tooltipSettings.enable) {
        if (chart.trackballBehavior.tooltipDisplayMode ==
                TrackballDisplayMode.groupAllPoints &&
            ((chartPointInfo[index].header != null &&
                    chartPointInfo[index].header != '') ||
                (chartPointInfo[index].label != null &&
                    chartPointInfo[index].label != ''))) {
          _calculateTrackballRect(canvas, width, height, index);
        } else {
          if (chartPointInfo[index].label != null &&
              chartPointInfo[index].label != '') {
            _calculateTrackballRect(canvas, width, height, index);
          }
        }
      }

      if (chart.trackballBehavior.tooltipDisplayMode ==
          TrackballDisplayMode.groupAllPoints) {
        break;
      }
    }
  }

  bool headerText = false;
  bool xFormat = false;
  bool isColon = true;
  Size _getTooltipSize(double height, double width, int index) {
    final Offset position = Offset(
        chartPointInfo[index].xPosition, chartPointInfo[index].yPosition);
    stringValue = <String>[];
    final String format = chartPointInfo[index]
        .series
        ._chart
        .trackballBehavior
        .tooltipSettings
        .format;
    if (format != null &&
        format.contains('point.x') &&
        !format.contains('point.y')) {
      xFormat = true;
    }
    if (format != null &&
        format.contains('point.x') &&
        format.contains('point.y') &&
        !format.contains(':')) {
      isColon = false;
    }
    if (chartPointInfo[index].header != null &&
        chartPointInfo[index].header != '') {
      stringValue.add(chartPointInfo[index].header);
    }
    if (chart.trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.groupAllPoints) {
      String str1 = '';
      for (int i = 0; i < chartPointInfo.length; i++) {
        if (chartPointInfo[i].header.contains(':')) {
          headerText = true;
        }
        bool isHeader =
            chartPointInfo[i].header != null && chartPointInfo[i].header != '';
        bool isLabel =
            chartPointInfo[i].label != null && chartPointInfo[i].label != '';
        if (chartPointInfo[i].series._isIndicator) {
          isHeader = chartPointInfo[0].header != null &&
              chartPointInfo[0].header != '';
          isLabel =
              chartPointInfo[0].label != null && chartPointInfo[0].label != '';
        }
        final String str = (i == 0 && isHeader) ? '\n' : '';
        final String seriesType = chartPointInfo[i].series._seriesType;
        if (chartPointInfo[i].series._isIndicator &&
            chartPointInfo[i].series.name == 'rangearea') {
          str1 = i == 0 ? '\n' : '';
          continue;
        } else if ((seriesType.contains('hilo') ||
                seriesType.contains('candle') ||
                seriesType.contains('range')) &&
            chartPointInfo[i]
                    .series
                    ._chart
                    .trackballBehavior
                    .tooltipSettings
                    .format ==
                null &&
            isLabel) {
          stringValue.add(((chartPointInfo[index].header == null ||
                      chartPointInfo[index].header == '')
                  ? ''
                  : '\n') +
              '${chartPointInfo[i].series.name}\n${chartPointInfo[i].label}');
          divider = isHeader && isLabel;
        } else if (chartPointInfo[i].series.name != null) {
          if (chartPointInfo[i]
                  .series
                  ._chart
                  .trackballBehavior
                  .tooltipSettings
                  .format !=
              null) {
            if (isHeader && isLabel && i == 0) {
              stringValue.add('');
            }
            if (isLabel) {
              stringValue.add(chartPointInfo[i].label);
            }
            divider = isHeader && isLabel;
          } else if (chartPointInfo[i].label.contains(':') &&
              (chartPointInfo[i].header == null ||
                  chartPointInfo[i].header == '') &&
              isLabel) {
            stringValue.add(chartPointInfo[i].label);
            divider = false;
          } else {
            if (isLabel) {
              stringValue.add(str1 +
                  str +
                  chartPointInfo[i].series.name +
                  ': ' +
                  chartPointInfo[i].label);
            }
            divider = (chartPointInfo[0].header != null &&
                    chartPointInfo[0].header != '') &&
                isLabel;
          }
          if (str1 != '') {
            str1 = '';
          }
        } else {
          if (isLabel) {
            stringValue.add(chartPointInfo[i].label);
          }
        }
      }
      for (int i = 0; i < stringValue.length; i++) {
        String measureString = stringValue[i];
        if (measureString.contains('<b>') && measureString.contains('</b>')) {
          measureString =
              measureString.replaceAll('<b>', '').replaceAll('</b>', '');
        }
        if (_measureText(measureString, labelStyle).width > width) {
          width = _measureText(measureString, labelStyle).width;
        }
        height += _measureText(measureString, labelStyle).height;
      }
      x = position.dx;
      if (chart.trackballBehavior.tooltipAlignment == ChartAlignment.center) {
        y = chart._chartAxis._axisClipRect.center.dy;
      } else if (chart.trackballBehavior.tooltipAlignment ==
          ChartAlignment.near) {
        y = chart._chartAxis._axisClipRect.top;
      } else {
        y = chart._chartAxis._axisClipRect.bottom;
      }
    } else {
      stringValue = <String>[];
      if (chartPointInfo[index].label != null &&
          chartPointInfo[index].label != '') {
        stringValue.add(chartPointInfo[index].label);
      }
      String measureString = stringValue.isNotEmpty ? stringValue[0] : null;
      if (measureString != null &&
          measureString.contains('<b>') &&
          measureString.contains('</b>')) {
        measureString =
            measureString.replaceAll('<b>', '').replaceAll('</b>', '');
      }
      final Size size = _measureText(measureString, labelStyle);
      width = size.width;
      height = size.height;

      if (chartPointInfo[index].series._seriesType == 'column' ||
          chartPointInfo[index].series._seriesType == 'bar' ||
          chartPointInfo[index].series._seriesType == 'rangecolumn' ||
          chartPointInfo[index].series._seriesType == 'candle' ||
          chartPointInfo[index].series._seriesType.contains('hilo') ||
          chartPointInfo[index].series._seriesType.contains('stacked')) {
        x = chartPointInfo[index].chartDataPoint.markerPoint.x;
        y = chartPointInfo[index].chartDataPoint.markerPoint.y;
      } else if (chartPointInfo[index].series._seriesType == 'rangearea') {
        x = chartPointInfo[index].chartDataPoint.markerPoint.x;
        y = (chartPointInfo[index].chartDataPoint.markerPoint.y +
                chartPointInfo[index].chartDataPoint.markerPoint2.y) /
            2;
      } else {
        x = position.dx;
        y = position.dy;
      }
    }
    return Size(width, height);
  }

  void _calculateTrackballRect(
      Canvas canvas, double width, double height, int index) {
    Rect labelRect = Rect.fromLTWH(x, y, width + 15, height + 10);
    final Rect backgroundRect = Rect.fromLTWH(boundaryRect.left + 25,
        boundaryRect.top, boundaryRect.width - 50, boundaryRect.height);
    final Rect leftRect = Rect.fromLTWH(boundaryRect.left - 5, boundaryRect.top,
        backgroundRect.left - (boundaryRect.left - 5), boundaryRect.height);
    final Rect rightRect = Rect.fromLTWH(backgroundRect.right, boundaryRect.top,
        (boundaryRect.right + 5) - backgroundRect.right, boundaryRect.height);
    if (leftRect.contains(Offset(x, y))) {
      isLeft = true;
      isRight = false;
    } else if (rightRect.contains(Offset(x, y))) {
      isLeft = false;
      isRight = true;
    }

    if (y > pointerLength + labelRect.height) {
      _calculateTooltipSize(labelRect);
    } else {
      isTop = false;
      if (isHorizontalOrientation) {
        xPos = x - (labelRect.width / 2);
        yPos = (y + pointerLength) + padding;
        nosePointX = labelRect.left;
        nosePointY = labelRect.top + padding;
        final double tooltipRightEnd = x + (labelRect.width / 2);
        xPos = xPos < boundaryRect.left
            ? boundaryRect.left
            : tooltipRightEnd > totalWidth
                ? totalWidth - labelRect.width
                : xPos;
      } else {
        if (chart.trackballBehavior.tooltipDisplayMode ==
            TrackballDisplayMode.groupAllPoints) {
          xPos = x - labelRect.width / 2;
          yPos = y;
        } else {
          xPos = x + padding + pointerLength;
          yPos = (y + pointerLength / 2) + padding;
        }
        nosePointX = labelRect.left;
        nosePointY = labelRect.top;
        final double tooltipRightEnd = x + labelRect.width;
        if (xPos < boundaryRect.left) {
          xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                  TrackballDisplayMode.groupAllPoints)
              ? boundaryRect.left + groupAllPadding
              : boundaryRect.left;
        } else if (tooltipRightEnd > totalWidth) {
          xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                  TrackballDisplayMode.groupAllPoints)
              ? (xPos - (labelRect.width / 2) - groupAllPadding)
              : ((xPos - labelRect.width - (2 * padding)) - 2 * pointerLength);

          isRight = true;
        } else {
          xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                      TrackballDisplayMode.groupAllPoints &&
                  chart.trackballBehavior.tooltipAlignment ==
                      ChartAlignment.near)
              ? x + padding + pointerLength
              : xPos;
        }
      }
    }
    if (chart.trackballBehavior.tooltipDisplayMode !=
        TrackballDisplayMode.groupAllPoints) {
      if (xPos <= boundaryRect.left + 5) {
        xPos = xPos + 10;
      } else if (xPos + labelRect.width >= totalWidth - 5) {
        xPos = xPos - 10;
      }
    }
    labelRect = Rect.fromLTWH(xPos, yPos, labelRect.width, labelRect.height);
    _drawBackground(canvas, labelRect, nosePointX, nosePointY, borderRadius,
        isTop, backgroundPath, isLeft, isRight, index);
  }

  void _calculateTooltipSize(Rect labelRect) {
    isTop = true;
    if (isHorizontalOrientation) {
      xPos = x - (labelRect.width / 2);
      yPos = (y - labelRect.height) - padding;
      nosePointY = labelRect.top - padding;
      nosePointX = labelRect.left;
      final double tooltipRightEnd = x + (labelRect.width / 2);
      xPos = xPos < boundaryRect.left
          ? boundaryRect.left
          : tooltipRightEnd > totalWidth ? totalWidth - labelRect.width : xPos;
      yPos = yPos - pointerLength;
      if (yPos + labelRect.height >= boundaryRect.bottom) {
        yPos = boundaryRect.bottom - labelRect.height;
      }
    } else {
      xPos = x + padding + pointerLength;
      yPos = y - labelRect.height / 2;
      nosePointY = labelRect.top;
      nosePointX = labelRect.left;
      final double tooltipRightEnd = xPos + (labelRect.width);
      if (xPos < boundaryRect.left) {
        xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                    TrackballDisplayMode.groupAllPoints &&
                chart.trackballBehavior.tooltipAlignment == ChartAlignment.far)
            ? boundaryRect.left + groupAllPadding
            : boundaryRect.left;
      } else if (tooltipRightEnd > totalWidth) {
        xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                    TrackballDisplayMode.groupAllPoints &&
                chart.trackballBehavior.tooltipAlignment == ChartAlignment.far)
            ? xPos - labelRect.width / 2 - groupAllPadding
            : ((xPos - labelRect.width - (2 * padding)) - 2 * pointerLength);

        isRight = true;
      } else {
        xPos = xPos;
      }
      if (yPos + labelRect.height >= boundaryRect.bottom) {
        yPos = boundaryRect.bottom - labelRect.height;
      }
    }
  }

  void _drawTrackBallLine(Canvas canvas, Paint paint, int index) {
    final Path dashArrayPath = Path();
    if (chart.trackballBehavior.lineType == TrackballLineType.vertical) {
      if (isRectSeries) {
        dashArrayPath.moveTo(chart.trackballBehavior._position.dx,
            chart._chartAxis._axisClipRect.top);
        dashArrayPath.lineTo(chart.trackballBehavior._position.dx,
            chart._chartAxis._axisClipRect.bottom);
        chart.trackballBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.trackballBehavior.lineDashArray,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      } else if (chart.isTransposed) {
        dashArrayPath.moveTo(chart.trackballBehavior._position.dx,
            chart._chartAxis._axisClipRect.top);
        dashArrayPath.lineTo(chart.trackballBehavior._position.dx,
            chart._chartAxis._axisClipRect.bottom);
        chart.trackballBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.trackballBehavior.lineDashArray,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      } else {
        dashArrayPath.moveTo(chartPointInfo[index].xPosition,
            chart._chartAxis._axisClipRect.top);
        dashArrayPath.lineTo(chartPointInfo[index].xPosition,
            chart._chartAxis._axisClipRect.bottom);
        chart.trackballBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.trackballBehavior.lineDashArray,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
    } else {
      if (isRectSeries) {
        dashArrayPath.moveTo(chart._chartAxis._axisClipRect.left,
            chartPointInfo[index].yPosition);
        dashArrayPath.lineTo(chart._chartAxis._axisClipRect.right,
            chartPointInfo[index].yPosition);
        chart.trackballBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.trackballBehavior.lineDashArray,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      } else if (chart.isTransposed) {
        dashArrayPath.moveTo(chart._chartAxis._axisClipRect.left,
            chartPointInfo[index].yPosition);
        dashArrayPath.lineTo(chart._chartAxis._axisClipRect.right,
            chartPointInfo[index].yPosition);
        chart.trackballBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.trackballBehavior.lineDashArray,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      } else {
        dashArrayPath.moveTo(chart._chartAxis._axisClipRect.left,
            chart.trackballBehavior._position.dy);
        dashArrayPath.lineTo(chart._chartAxis._axisClipRect.right,
            chart.trackballBehavior._position.dy);
        chart.trackballBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.trackballBehavior.lineDashArray,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
    }
  }

  void _drawBackground(
      Canvas canvas,
      Rect labelRect,
      double xPos,
      double yPos,
      double borderRadius,
      bool isTop,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      int index) {
    final double startArrow = pointerLength;
    final double endArrow = pointerLength;
    if (isTop) {
      _drawTooltip(
          canvas,
          labelRect,
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
          index);
    } else {
      _drawTooltip(
          canvas,
          labelRect,
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
          index);
    }
  }

  void _drawTooltip(
      Canvas canvas,
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
      int index) {
    backgroundPath.reset();
    if (!canResetPath &&
        chart.trackballBehavior.tooltipDisplayMode !=
            TrackballDisplayMode.none) {
      if (chart.trackballBehavior.tooltipDisplayMode !=
          TrackballDisplayMode.groupAllPoints) {
        if (isHorizontalOrientation) {
          if (isLeft) {
            startX = rectF.left + borderRadius;
            endX = startX + pointerWidth;
          } else if (isRight) {
            endX = rectF.right - borderRadius;
            startX = endX - pointerWidth;
          }
          backgroundPath.moveTo(
              (rectF.left + rectF.width / 2) - pointerWidth, startY);
          backgroundPath.lineTo(xPos, yPos);
          backgroundPath.lineTo(
              (rectF.right - rectF.width / 2) + pointerWidth, endY);
        } else {
          if (isRight) {
            backgroundPath.moveTo(
                rectF.right, rectF.top + rectF.height / 2 - pointerWidth);
            backgroundPath.lineTo(
                rectF.right, rectF.bottom - rectF.height / 2 + pointerWidth);
            backgroundPath.lineTo(rectF.right + pointerLength, yPos);
            backgroundPath.lineTo(rectF.right + pointerLength, yPos);
            backgroundPath.lineTo(
                rectF.right, rectF.top + rectF.height / 2 - pointerWidth);
          } else {
            backgroundPath.moveTo(
                rectF.left, rectF.top + rectF.height / 2 - pointerWidth);
            backgroundPath.lineTo(
                rectF.left, rectF.bottom - rectF.height / 2 + pointerWidth);
            backgroundPath.lineTo(rectF.left - pointerLength, yPos);
            backgroundPath.lineTo(rectF.left - pointerLength, yPos);
            backgroundPath.lineTo(
                rectF.left, rectF.top + rectF.height / 2 - pointerWidth);
          }
        }
      }
      _drawRectandText(canvas, backgroundPath, rectF, index);
      xPos = null;
      yPos = null;
    }
  }

  /// draw trackball tooltip rect and text
  void _drawRectandText(
      Canvas canvas, Path backgroundPath, Rect rect, int index) {
    final RRect tooltipRect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );
    const double padding = 10;
    backgroundPath.addRRect(tooltipRect);

    final Paint fillPaint = Paint()
      ..color = chart.trackballBehavior.tooltipSettings.color != null
          ? chart.trackballBehavior.tooltipSettings.color
          : (chartPointInfo[index].series.color != null
              ? chartPointInfo[index].series.color
              : chart._chartState._chartTheme.crosshairBackgroundColor)
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    final Paint stokePaint = Paint()
      ..color = chart.trackballBehavior.tooltipSettings.borderColor != null
          ? chart.trackballBehavior.tooltipSettings.borderColor
          : (chartPointInfo[index].series.color != null
              ? chartPointInfo[index].series.color
              : chart._chartState._chartTheme.crosshairBackgroundColor)
      ..strokeWidth = chart.trackballBehavior.tooltipSettings.borderWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawPath(backgroundPath, stokePaint);
    canvas.drawPath(backgroundPath, fillPaint);
    final Paint dividerPaint = Paint();
    dividerPaint.color = Colors.white;
    dividerPaint.strokeWidth = 1;
    dividerPaint.style = PaintingStyle.stroke;
    if (chart.trackballBehavior.tooltipDisplayMode ==
            TrackballDisplayMode.groupAllPoints &&
        chart.series[index].name != null &&
        divider) {
      final Size headerResult = _measureText(stringValue[0], labelStyle);
      canvas.drawLine(
          Offset(tooltipRect.left + padding,
              tooltipRect.top + headerResult.height + padding),
          Offset(tooltipRect.right - padding,
              tooltipRect.top + headerResult.height + padding),
          dividerPaint);
    }
    double eachTextHeight = 0;
    Size labelSize;
    double totalHeight = 0;

    for (int i = 0; i < stringValue.length; i++) {
      labelSize = _measureText(stringValue[i], labelStyle);
      totalHeight += labelSize.height;
    }

    eachTextHeight =
        (tooltipRect.top + tooltipRect.height / 2) - totalHeight / 2;

    for (int i = 0; i < stringValue.length; i++) {
      labelStyle.fontWeight = FontWeight.normal;
      labelSize = _measureText(stringValue[i], labelStyle);
      eachTextHeight += labelSize.height;
      if (!stringValue[i].contains(':') &&
          !stringValue[i].contains('<b>') &&
          !stringValue[i].contains('</b>')) {
        labelStyle.fontWeight = FontWeight.bold;
        _drawText(
            canvas,
            stringValue[i],
            Offset(
                (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2,
                eachTextHeight - labelSize.height),
            labelStyle,
            0);
      } else {
        if (stringValue[i] != null) {
          final List<String> str = stringValue[i].split('\n');
          double padding = 0;
          if (str.length > 1) {
            for (int j = 0; j < str.length; j++) {
              final List<String> str1 = str[j].split(':');
              if (str1.length > 1) {
                for (int k = 0; k < str1.length; k++) {
                  final double width =
                      k > 0 ? _measureText(str1[k - 1], labelStyle).width : 0;
                  str1[k] = k == 1 ? ':' + str1[k] : str1[k];
                  labelStyle.fontWeight =
                      k > 0 ? FontWeight.bold : FontWeight.normal;
                  _drawText(
                      canvas,
                      str1[k],
                      Offset((tooltipRect.left + 4) + width,
                          (eachTextHeight - labelSize.height) + padding),
                      labelStyle,
                      0);
                  padding = k > 0
                      ? padding +
                          (labelStyle.fontSize + (labelStyle.fontSize * 0.15))
                      : padding;
                }
              } else {
                labelStyle.fontWeight = FontWeight.bold;
                _drawText(
                    canvas,
                    str1[str1.length - 1],
                    Offset(tooltipRect.left + 4,
                        eachTextHeight - labelSize.height + padding),
                    labelStyle,
                    0);
                padding = padding +
                    (labelStyle.fontSize + (labelStyle.fontSize * 0.15));
              }
            }
          } else {
            List<String> str1 = str[str.length - 1].split(':');
            final List<String> boldString = <String>[];
            if (str[str.length - 1].contains('<b>')) {
              str1 = <String>[];
              final List<String> boldSplit = str[str.length - 1].split('</b>');
              for (int i = 0; i < boldSplit.length; i++) {
                if (boldSplit[i] != '') {
                  boldString.add(boldSplit[i].substring(
                      boldSplit[i].indexOf('<b>') + 3, boldSplit[i].length));
                  final List<String> str2 = boldSplit[i].split('<b>');
                  for (int s = 0; s < str2.length; s++) {
                    str1.add(str2[s]);
                  }
                }
              }
            } else if (str1.length > 2 || xFormat || !isColon) {
              str1 = <String>[];
              str1.add(str[str.length - 1]);
            }
            double previousWidth = 0.0;
            for (int j = 0; j < str1.length; j++) {
              bool isBold = false;
              for (int i = 0; i < boldString.length; i++) {
                if (str1[j] == boldString[i]) {
                  isBold = true;
                  break;
                }
              }
              final double width =
                  j > 0 ? _measureText(str1[j - 1], labelStyle).width : 0;
              previousWidth += width;
              final String colon =
                  boldString.isNotEmpty ? '' : j > 0 ? ': ' : '';
              labelStyle.fontWeight = (headerText || xFormat || isBold)
                  ? FontWeight.bold
                  : j > 0
                      ? boldString.isNotEmpty
                          ? FontWeight.normal
                          : FontWeight.bold
                      : FontWeight.normal;
              _drawText(
                  canvas,
                  colon + str1[j],
                  Offset(
                      (tooltipRect.left + 4) +
                          (previousWidth > width ? previousWidth : width),
                      eachTextHeight - labelSize.height),
                  labelStyle,
                  0);
              headerText = false;
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// calculate trackball points
  void _generateAllPoints(Offset position) {
    chartPointInfo = <_ChartPointInfo>[];
    final Rect seriesBounds = chart._chartAxis._axisClipRect;
    if (position.dx >= seriesBounds.left &&
        position.dx <= seriesBounds.right &&
        position.dy >= seriesBounds.top &&
        position.dy <= seriesBounds.bottom) {
      chart.trackballBehavior._position = position;
      double xPos = 0,
          yPos = 0,
          leastX = 0,
          openXPos,
          openYPos,
          closeXPos,
          closeYPos,
          lowYPos,
          highYPos;
      int seriesIndex = 0;
      final List<ChartAxis> seriesAxes = <ChartAxis>[];
      for (XyDataSeries<dynamic, dynamic> series
          in chart._chartSeries.visibleSeries) {
        if (series._visible) {
          final XyDataSeries<dynamic, dynamic> visibleSeries = series;
          final ChartAxis chartAxis = visibleSeries._xAxis;
          if (chartAxis == null) {
            continue;
          }
          if (!seriesAxes.contains(chartAxis)) {
            seriesAxes.add(chartAxis);
            for (XyDataSeries<dynamic, dynamic> axisSeries
                in chartAxis._series) {
              final XyDataSeries<dynamic, dynamic> cartesianSeries = axisSeries;
              if (axisSeries._visible == false ||
                  (axisSeries._dataPoints.isEmpty &&
                      !axisSeries._isRectSeries)) {
                continue;
              }
              if (cartesianSeries._dataPoints.isNotEmpty) {
                final List<dynamic> nearestDataPoints = _getNearestChartPoints(
                    position.dx,
                    position.dy,
                    chartAxis,
                    visibleSeries._yAxis,
                    cartesianSeries);
                if (nearestDataPoints == null) {
                  continue;
                }
                for (dynamic dataPoint in nearestDataPoints) {
                  final int index = axisSeries._dataPoints.indexOf(dataPoint);
                  final num xValue = cartesianSeries._dataPoints[index].xValue;
                  final num yValue = cartesianSeries._dataPoints[index].yValue;
                  final num highValue = cartesianSeries._dataPoints[index].high;
                  final num lowValue = cartesianSeries._dataPoints[index].low;
                  final num openValue = cartesianSeries._dataPoints[index].open;
                  final num closeValue =
                      cartesianSeries._dataPoints[index].close;
                  final String seriesName =
                      cartesianSeries.name ?? 'Series $seriesIndex';
                  final num bubbleSize =
                      cartesianSeries._dataPoints[index].bubbleSize;
                  final dynamic cumulativeValue =
                      cartesianSeries._dataPoints[index].cumulativeValue;
                  final Rect axisClipRect = _calculatePlotOffset(
                      cartesianSeries._chart._chartAxis._axisClipRect,
                      Offset(cartesianSeries._xAxis.plotOffset,
                          cartesianSeries._yAxis.plotOffset));
                  xPos = _calculatePoint(
                          xValue,
                          yValue,
                          cartesianSeries._xAxis,
                          cartesianSeries._yAxis,
                          chart._requireInvertedAxis,
                          cartesianSeries,
                          axisClipRect)
                      .x;
                  if (!xPos.toDouble().isNaN) {
                    if (seriesIndex == 0 ||
                        ((leastX - position.dx) > (leastX - xPos))) {
                      leastX = xPos;
                    }
                    final String labelValue = _getTrackballLabelText(
                        cartesianSeries,
                        xValue,
                        yValue,
                        lowValue,
                        highValue,
                        openValue,
                        closeValue,
                        seriesName,
                        bubbleSize,
                        cumulativeValue,
                        dataPoint);
                    yPos = _calculatePoint(
                            xValue,
                            yValue,
                            cartesianSeries._xAxis,
                            cartesianSeries._yAxis,
                            chart._requireInvertedAxis,
                            cartesianSeries,
                            axisClipRect)
                        .y;

                    if (cartesianSeries._seriesType.contains('range') ||
                        cartesianSeries._seriesType.contains('hilo') ||
                        cartesianSeries._seriesType == 'candle') {
                      lowYPos = _calculatePoint(
                              xValue,
                              lowValue,
                              cartesianSeries._xAxis,
                              cartesianSeries._yAxis,
                              chart._requireInvertedAxis,
                              cartesianSeries,
                              axisClipRect)
                          .y;

                      highYPos = _calculatePoint(
                              xValue,
                              highValue,
                              cartesianSeries._xAxis,
                              cartesianSeries._yAxis,
                              chart._requireInvertedAxis,
                              cartesianSeries,
                              axisClipRect)
                          .y;

                      if (cartesianSeries._seriesType == 'hiloopenclose' ||
                          cartesianSeries._seriesType == 'candle') {
                        openXPos = dataPoint.openPoint.x;
                        openYPos = dataPoint.openPoint.y;
                        closeXPos = dataPoint.closePoint.x;
                        closeYPos = dataPoint.closePoint.y;
                      }
                    }

                    final Rect rect = seriesBounds
                        .intersect(Rect.fromLTWH(xPos - 1, yPos - 1, 2, 2));
                    if (seriesBounds.contains(Offset(xPos, yPos)) ||
                        seriesBounds.overlaps(rect)) {
                      _addChartPointInfo(
                          cartesianSeries,
                          xPos,
                          yPos,
                          index,
                          labelValue,
                          lowYPos,
                          highYPos,
                          openXPos,
                          openYPos,
                          closeXPos,
                          closeYPos);
                      _triggerTrackballEvent();
                      if (chart.trackballBehavior.tooltipDisplayMode ==
                              TrackballDisplayMode.groupAllPoints &&
                          leastX >= seriesBounds.left) {
                        chart._requireInvertedAxis
                            ? yPos = leastX
                            : xPos = leastX;
                      }
                    }
                  }
                }
                seriesIndex++;
              }
              _validateNearestXValue(leastX, series, position.dx, position.dy);
            }
            if (chartPointInfo.isNotEmpty) {
              if (chart.trackballBehavior.tooltipDisplayMode !=
                  TrackballDisplayMode.groupAllPoints) {
                chart._requireInvertedAxis
                    ? chartPointInfo.sort(
                        (_ChartPointInfo a, _ChartPointInfo b) =>
                            a.xPosition.compareTo(b.xPosition))
                    : chartPointInfo.sort(
                        (_ChartPointInfo a, _ChartPointInfo b) =>
                            a.yPosition.compareTo(b.yPosition));
              }
              if (chart.trackballBehavior.tooltipDisplayMode ==
                      TrackballDisplayMode.nearestPoint ||
                  (series._isRectSeries &&
                      chart.trackballBehavior.tooltipDisplayMode !=
                          TrackballDisplayMode.groupAllPoints)) {
                _validateNearestPointForAllSeries(
                    leastX, chartPointInfo, position.dx, position.dy);
              }
            }
          }
        }
      }
    }
    chartPointInfo = _getValidPoints(chartPointInfo, position);
  }

  dynamic _getValidPoints(List<dynamic> points, Offset position) {
    final List<_ChartPointInfo> validPoints = <_ChartPointInfo>[];
    for (_ChartPointInfo point in points) {
      if (validPoints.isEmpty) {
        validPoints.add(point);
      } else if (validPoints[0].series._xAxis == point.series._xAxis) {
        if (!point.series._chart._requireInvertedAxis) {
          if ((validPoints[0].xPosition - position.dx).abs() ==
              (point.xPosition - position.dx).abs()) {
            validPoints.add(point);
          }
        } else if ((validPoints[0].yPosition - position.dy).abs() ==
            (point.yPosition - position.dy).abs()) {
          validPoints.add(point);
        }
      } else if ((validPoints[0].xPosition - position.dx).abs() >
          (point.xPosition - position.dx).abs()) {
        validPoints.clear();
        validPoints.add(point);
      } else if ((validPoints[0].xPosition - position.dx).abs() ==
          (point.xPosition - position.dx).abs()) {
        if ((validPoints[0].yPosition - position.dy).abs() >
            (point.yPosition - position.dy).abs()) {
          validPoints.clear();
          validPoints.add(point);
        }
      }
    }
    return validPoints;
  }

  String _getTrackballLabelText(
      XyDataSeries<dynamic, dynamic> cartesianSeries,
      num xValue,
      num yValue,
      num lowValue,
      num highValue,
      num openValue,
      num closeValue,
      String seriesName,
      num bubbleSize,
      dynamic cumulativeValue,
      dynamic dataPoint) {
    String labelValue;
    final int digits = chart.trackballBehavior.tooltipSettings.decimalPlaces;
    if (chart.trackballBehavior.tooltipSettings.format != null) {
      dynamic x;
      final dynamic axis = cartesianSeries._xAxis;
      if (axis is DateTimeAxis) {
        final DateFormat dateFormat =
            axis.dateFormat ?? axis._getLabelFormat(axis);
        x = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(xValue));
      } else if (axis is CategoryAxis) {
        x = dataPoint.x;
      }
      labelValue = chart.trackballBehavior.tooltipSettings.format
          .replaceAll('point.x', (x ?? xValue).toString())
          .replaceAll(
              'point.y', _getLabelValue(yValue, cartesianSeries._yAxis, digits))
          .replaceAll('point.high', highValue.toString())
          .replaceAll('point.low', lowValue.toString())
          .replaceAll('point.open', openValue.toString())
          .replaceAll('point.close', closeValue.toString())
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll('series.name', seriesName)
          .replaceAll('point.size', bubbleSize.toString())
          .replaceAll('point.cumulativeValue', cumulativeValue.toString());
    } else {
      labelValue = !cartesianSeries._seriesType.contains('range') &&
              !cartesianSeries._seriesType.contains('candle') &&
              !cartesianSeries._seriesType.contains('hilo')
          ? _getLabelValue(yValue, cartesianSeries._yAxis, digits)
          : cartesianSeries._seriesType == 'hiloopenclose' ||
                  cartesianSeries._seriesType.contains('candle')
              ? 'High: ' +
                  highValue.toString() +
                  '\n' +
                  'Low: ' +
                  lowValue.toString() +
                  '\n' +
                  'Open: ' +
                  openValue.toString() +
                  '\n' +
                  'Close: ' +
                  closeValue.toString()
              : 'High: ' +
                  highValue.toString() +
                  '\n' +
                  'Low: ' +
                  lowValue.toString();
    }
    return labelValue;
  }

  void _triggerTrackballEvent() {
    if (chart.onTrackballPositionChanging != null) {
      chart._chartPointInfo =
          chart.trackballBehavior._trackballPainter.chartPointInfo;
      for (int index = 0; index < chart._chartPointInfo.length; index++) {
        TrackballArgs chartPoint;
        chartPoint = TrackballArgs();
        chartPoint.chartPointInfo = chart._chartPointInfo[index];
        chart.onTrackballPositionChanging(chartPoint);
        chart._chartPointInfo[index].label = chartPoint.chartPointInfo.label;
        chart._chartPointInfo[index].header = chartPoint.chartPointInfo.header;
      }
    }
  }

  void _validateNearestPointForAllSeries(double leastX,
      List<_ChartPointInfo> trackballInfo, double touchXPos, double touchYPos) {
    double xPos = 0;
    final List<_ChartPointInfo> tempTrackballInfo =
        List<_ChartPointInfo>.from(trackballInfo);
    for (int i = 0; i < tempTrackballInfo.length; i++) {
      final _ChartPointInfo pointInfo = tempTrackballInfo[i];
      final List<num> xValues = <num>[];
      final List<num> yValues = <num>[];
      for (int i = 0; i < pointInfo.series._dataPoints.length; i++) {
        xValues.add(pointInfo.series._dataPoints[i].xValue);
        yValues.add(pointInfo.series._dataPoints[i].yValue);
      }
      final num xValue = xValues[pointInfo.dataPointIndex];
      final num yValue = yValues[pointInfo.dataPointIndex];
      final Rect axisClipRect = _calculatePlotOffset(
          pointInfo.series._chart._chartAxis._axisClipRect,
          Offset(pointInfo.series._xAxis.plotOffset,
              pointInfo.series._yAxis.plotOffset));

      xPos = _calculatePoint(
              xValue,
              yValue,
              pointInfo.series._xAxis,
              pointInfo.series._yAxis,
              chart._requireInvertedAxis,
              pointInfo.series,
              axisClipRect)
          .x;
      trackballInfo = _getRectSeriesPointInfo(trackballInfo, pointInfo, xValue,
          yValue, touchXPos, leastX, axisClipRect);
      if (chart.trackballBehavior.tooltipDisplayMode !=
              TrackballDisplayMode.floatAllPoints &&
          (!pointInfo.series._chart._requireInvertedAxis)) {
        if (leastX != xPos) {
          trackballInfo.remove(pointInfo);
        }
        final int pointInfoIndex = tempTrackballInfo.indexOf(pointInfo);
        final double yPos = touchYPos;
        if (pointInfoIndex < tempTrackballInfo.length - 1) {
          final _ChartPointInfo nextPointInfo =
              tempTrackballInfo[pointInfoIndex + 1];

          if (nextPointInfo.yPosition == pointInfo.yPosition ||
              (pointInfo.yPosition > yPos && pointInfoIndex == 0)) {
            continue;
          }
          if (!(yPos <
              (nextPointInfo.yPosition -
                  ((nextPointInfo.yPosition - pointInfo.yPosition) / 2)))) {
            trackballInfo.remove(pointInfo);
          } else if (pointInfoIndex != 0) {
            final _ChartPointInfo previousPointInfo =
                tempTrackballInfo[pointInfoIndex - 1];
            if (yPos <
                (pointInfo.yPosition -
                    ((pointInfo.yPosition - previousPointInfo.yPosition) /
                        2))) {
              trackballInfo.remove(pointInfo);
            }
          }
        } else {
          if (pointInfoIndex != 0 &&
              pointInfoIndex == tempTrackballInfo.length - 1) {
            final _ChartPointInfo previousPointInfo =
                tempTrackballInfo[pointInfoIndex - 1];
            if (yPos < previousPointInfo.yPosition) {
              trackballInfo.remove(pointInfo);
            }
            if (yPos <
                (pointInfo.yPosition -
                    ((pointInfo.yPosition - previousPointInfo.yPosition) /
                        2))) {
              trackballInfo.remove(pointInfo);
            }
          }
        }
      }
    }
  }

  List<_ChartPointInfo> _getRectSeriesPointInfo(
      List<_ChartPointInfo> trackballInfo,
      _ChartPointInfo pointInfo,
      num xValue,
      num yValue,
      double touchXPos,
      double leastX,
      Rect axisClipRect) {
    if (pointInfo.series._isRectSeries &&
        chart.enableSideBySideSeriesPlacement &&
        chart.trackballBehavior.tooltipDisplayMode !=
            TrackballDisplayMode.groupAllPoints) {
      final bool isXAxisInverse = chart._requireInvertedAxis;
      final _VisibleRange sideBySideInfo =
          _calculateSideBySideInfo(pointInfo.series, chart);
      final double xStartValue = xValue + sideBySideInfo.minimum;
      final double xEndValue = xValue + sideBySideInfo.maximum;
      double xStart = _calculatePoint(
              xStartValue,
              yValue,
              pointInfo.series._xAxis,
              pointInfo.series._yAxis,
              chart._requireInvertedAxis,
              pointInfo.series,
              axisClipRect)
          .x;
      double xEnd = _calculatePoint(
              xEndValue,
              yValue,
              pointInfo.series._xAxis,
              pointInfo.series._yAxis,
              chart._requireInvertedAxis,
              pointInfo.series,
              axisClipRect)
          .x;
      bool isStartIndex = pointInfo.series._sideBySideIndex == 0;
      bool isEndIndex = pointInfo.series._sideBySideIndex ==
          pointInfo.series._chart._chartSeries.visibleSeries.length - 1;
      final double xPos = touchXPos;
      if (isXAxisInverse) {
        final double temp = xStart;
        xStart = xEnd;
        xEnd = temp;
        final bool isTemp = isEndIndex;
        isEndIndex = isStartIndex;
        isStartIndex = isTemp;
      } else if (pointInfo.series._chart._chartState.zoomedState == true ||
          chart.trackballBehavior.tooltipDisplayMode !=
              TrackballDisplayMode.floatAllPoints) {
        if (xPos < leastX && isStartIndex) {
          if (!(xPos < xStart) && !(xPos < xEnd && xPos >= xStart)) {
            trackballInfo.remove(pointInfo);
          }
        } else if (xPos > leastX && isEndIndex) {
          if (!(xPos > xEnd && xPos > xStart) &&
              !(xPos < xEnd && xPos >= xStart)) {
            trackballInfo.remove(pointInfo);
          }
        } else if (!(xPos < xEnd && xPos >= xStart)) {
          trackballInfo.remove(pointInfo);
        }
      }
    }
    return trackballInfo;
  }

  void _validateNearestXValue(
      double leastX,
      XyDataSeries<dynamic, dynamic> series,
      double touchXPos,
      double touchYPos) {
    final List<_ChartPointInfo> leastPointInfo = <_ChartPointInfo>[];
    final Rect axisClipRect = _calculatePlotOffset(
        series._chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));

    double nearPointX = series._chart._requireInvertedAxis
        ? axisClipRect.top
        : axisClipRect.left;
    final double touchXValue =
        series._chart._requireInvertedAxis ? touchYPos : touchXPos;
    double delta = 0;
    for (_ChartPointInfo pointInfo in chartPointInfo) {
      final List<num> xValues = <num>[];
      final List<num> yValues = <num>[];
      for (int i = 0; i < series._dataPoints.length; i++) {
        xValues.add(series._dataPoints[i].xValue);
        yValues.add(series._dataPoints[i].yValue);
      }
      if (pointInfo.dataPointIndex < series._dataPoints.length) {
        final num xValue = xValues[pointInfo.dataPointIndex];
        final num yValue = yValues[pointInfo.dataPointIndex];
        final double currX = series._chart._requireInvertedAxis
            ? _calculatePoint(
                    xValue,
                    yValue,
                    pointInfo.series._xAxis,
                    pointInfo.series._yAxis,
                    chart._requireInvertedAxis,
                    pointInfo.series,
                    axisClipRect)
                .y
            : _calculatePoint(
                    xValue,
                    yValue,
                    pointInfo.series._xAxis,
                    pointInfo.series._yAxis,
                    chart._requireInvertedAxis,
                    pointInfo.series,
                    axisClipRect)
                .x;

        if (delta == touchXValue - currX) {
          leastPointInfo.add(pointInfo);
        } else if ((touchXValue - currX).toDouble().abs() <=
            (touchXValue - nearPointX).toDouble().abs()) {
          nearPointX = currX;
          delta = touchXValue - currX;
          leastPointInfo.clear();
          leastPointInfo.add(pointInfo);
        }
      }

      // final List<_ChartPointInfo> trackballInfoClone =
      //     List<_ChartPointInfo>.from(chartPointInfo);

      // for (_ChartPointInfo pointInfo in trackballInfoClone) {
      //   if (!leastPointInfo.contains(pointInfo)) {
      //     chartPointInfo.remove(pointInfo);
      //   }
      // }

      if (chartPointInfo.isNotEmpty) {
        final _ChartPointInfo pointInfo = chartPointInfo[0];
        leastX = _getLeastX(pointInfo, series, axisClipRect);
      }

      if (chart.isTransposed) {
        yPos = leastX;
      } else {
        xPos = leastX;
      }
    }
  }

  double _getLeastX(_ChartPointInfo pointInfo,
      XyDataSeries<dynamic, dynamic> series, Rect axisClipRect) {
    final List<num> xValues = <num>[];
    final List<num> yValues = <num>[];
    for (int i = 0; i < series._dataPoints.length; i++) {
      xValues.add(series._dataPoints[i].xValue);
      yValues.add(series._dataPoints[i].yValue);
    }
    final num xValue = xValues[pointInfo.dataPointIndex];
    final num yValue = yValues[pointInfo.dataPointIndex];
    return _calculatePoint(xValue, yValue, series._xAxis, series._yAxis,
            chart._requireInvertedAxis, series, axisClipRect)
        .x;
  }

  void _addChartPointInfo(CartesianSeries<dynamic, dynamic> series, double xPos,
      double yPos, int dataPointIndex, String label,
      [double lowYPos,
      double highYPos,
      double openXPos,
      double openYPos,
      double closeXPos,
      double closeYPos]) {
    final _ChartPointInfo pointInfo = _ChartPointInfo();
    pointInfo.series = series;
    pointInfo.markerXPos = xPos;
    pointInfo.markerYPos = yPos;
    pointInfo.xPosition = xPos;
    pointInfo.yPosition = yPos;

    if (series._seriesType.contains('hilo') ||
        series._seriesType.contains('range') ||
        series._seriesType == 'candle') {
      pointInfo.lowYPosition = lowYPos;
      pointInfo.highYPosition = highYPos;
      if (series._seriesType == 'hiloopenclose' ||
          series._seriesType == 'candle') {
        pointInfo.openXPosition = openXPos;
        pointInfo.openYPosition = openYPos;
        pointInfo.closeXPosition = closeXPos;
        pointInfo.closeYPosition = closeYPos;
      }
    }

    if (series.segments.length > dataPointIndex) {
      pointInfo.color = series.segments[dataPointIndex].color;
    } else {
      if (series.segments.length > 1) {
        pointInfo.color = series.segments[series.segments.length - 1].color;
      }
    }
    pointInfo.chartDataPoint = series._dataPoints[dataPointIndex];
    pointInfo.dataPointIndex = dataPointIndex;
    pointInfo.label = label;
    pointInfo.header = series._dataPoints[dataPointIndex].regionData != null
        ? series._dataPoints[dataPointIndex].regionData[0]
        : null;
    chartPointInfo.add(pointInfo);
  }

  void showTrackball(
      List<CartesianSeries<dynamic, dynamic>> visibleSeries, int pointIndex) {
    _ChartLocation position;
    final CartesianSeries<dynamic, dynamic> series = visibleSeries[0];
    final Rect rect = series._chart._chartAxis._axisClipRect;
    final List<CartesianChartPoint<dynamic>> _dataPoints =
        <CartesianChartPoint<dynamic>>[];
    for (int i = 0; i < series._dataPoints.length; i++) {
      if (series._dataPoints[i].isGap != true) {
        _dataPoints.add(series._dataPoints[i]);
      }
    }
    if (pointIndex != null && pointIndex.abs() < series._dataPoints.length) {
      final int index = pointIndex;
      final num xValue = _dataPoints[index].xValue;
      final num yValue = series is _FinancialSeriesBase<dynamic, dynamic> ||
              series._seriesType.contains('range')
          ? _dataPoints[index].high
          : _dataPoints[index].yValue;
      position = _calculatePoint(xValue, yValue, series._xAxis, series._yAxis,
          series._chart._requireInvertedAxis, series, rect);
      _generateAllPoints(Offset(position.x, position.y));
    }
  }

  String getFormattedValue(num value) => value.toString();
}
