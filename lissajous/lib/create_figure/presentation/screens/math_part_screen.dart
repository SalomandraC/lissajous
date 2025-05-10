import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lissajous/core/global_widgets/gradient_appbar.dart';

class CreateFigurePage extends StatefulWidget {
  const CreateFigurePage({super.key});

  @override
  State<CreateFigurePage> createState() => _CreateFigurePageState();
}

class _CreateFigurePageState extends State<CreateFigurePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<List<Offset>> _pointsList = [];
  final TransformationController _transformController =
      TransformationController();
  final GlobalKey _canvasKey = GlobalKey();
  bool _showCustomFormula = false;
  String _customFormulaX = 'A*cos(f*t + p)';
  String _customFormulaY = 'A*sin(f*t + p)';
  bool _showControls = true;
  double _controlPanelHeight = 300;
  bool _customFormulaStarted = false;
  final TextEditingController _formulaXController = TextEditingController();
  final TextEditingController _formulaYController = TextEditingController();
  final FocusNode _formulaXFocus = FocusNode();
  final FocusNode _formulaYFocus = FocusNode();

  // Параметры фигуры
  double frequencyX = 1.0;
  double frequencyY = 2.0;
  double amplitudeX = 100.0;
  double amplitudeY = 100.0;
  double phaseX = 0.0;
  double phaseY = 0.5;
  double speed = 1.0;
  Color figureColor = Colors.blue;
  List<Color> _usedColors = [Colors.blue];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _formulaXController.text = _customFormulaX;
    _formulaYController.text = _customFormulaY;
    _pointsList.add([]);
  }

  @override
  void dispose() {
    _controller.dispose();
    _transformController.dispose();
    _formulaXController.dispose();
    _formulaYController.dispose();
    _formulaXFocus.dispose();
    _formulaYFocus.dispose();
    super.dispose();
  }

  void _resetView() {
    _transformController.value = Matrix4.identity();
  }

  void _clearDrawing() {
    setState(() {
      _pointsList.clear();
      _pointsList.add([]);
      _usedColors = [figureColor];
      _customFormulaStarted = false;
    });
  }

  void _startCustomFormula() {
    setState(() {
      _customFormulaX = _formulaXController.text;
      _customFormulaY = _formulaYController.text;
      _pointsList.add([]);
      _usedColors.add(figureColor);
      _customFormulaStarted = true;
    });
  }

  void _changeColor(Color newColor) {
    setState(() {
      if (figureColor != newColor) {
        figureColor = newColor;
        _pointsList.add([]);
        _usedColors.add(newColor);
      }
    });
  }

  Map<String, String> _getLocalizedStrings(String languageCode) {
    return {
      'title': languageCode == 'ru' ? 'Создать фигуру' : 'Create Figure',
      'frequency_x': languageCode == 'ru' ? 'Частота X' : 'Frequency X',
      'frequency_y': languageCode == 'ru' ? 'Частота Y' : 'Frequency Y',
      'amplitude_x': languageCode == 'ru' ? 'Амплитуда X' : 'Amplitude X',
      'amplitude_y': languageCode == 'ru' ? 'Амплитуда Y' : 'Amplitude Y',
      'phase_x': languageCode == 'ru' ? 'Фаза X' : 'Phase X',
      'phase_y': languageCode == 'ru' ? 'Фаза Y' : 'Phase Y',
      'speed': languageCode == 'ru' ? 'Скорость' : 'Speed',
      'color': languageCode == 'ru' ? 'Цвет' : 'Color',
      'custom_formula':
          languageCode == 'ru' ? 'Своя формула' : 'Custom formula',
      'formula_x': languageCode == 'ru' ? 'Формула X(t):' : 'Formula X(t):',
      'formula_y': languageCode == 'ru' ? 'Формула Y(t):' : 'Formula Y(t):',
      'reset_view': languageCode == 'ru' ? 'Сброс вида' : 'Reset view',
      'clear': languageCode == 'ru' ? 'Очистить' : 'Clear',
      'show_controls': languageCode == 'ru' ? 'Настройки' : 'Controls',
      'start': languageCode == 'ru' ? 'Запустить' : 'Start',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 100;
    final locale = Localizations.localeOf(context);
    final strings = _getLocalizedStrings(locale.languageCode);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: GradientAppBar(
        title: strings['title']!,
        isDarkTheme: theme.brightness == Brightness.dark,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onDoubleTap: _resetView,
              child: InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.1,
                maxScale: 10.0,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      if (!_showCustomFormula || _customFormulaStarted) {
                        final time = _controller.value * 2 * pi * speed;
                        final currentPoints = _pointsList.last;

                        double x, y;
                        if (_showCustomFormula) {
                          // Добавляем центр экрана к кастомным формулам
                          x = centerX + _evaluateFormula(_customFormulaX, time);
                          y = centerY + _evaluateFormula(_customFormulaY, time);
                        } else {
                          x = centerX +
                              amplitudeX * cos(frequencyX * time + phaseX);
                          y = centerY +
                              amplitudeY * sin(frequencyY * time + phaseY);
                        }
                        currentPoints.add(Offset(x, y));

                        if (currentPoints.length > 5000) {
                          currentPoints.removeRange(
                              0, currentPoints.length - 4000);
                        }
                      }

                      return CustomPaint(
                        key: _canvasKey,
                        painter: _LissajousPainter(
                          pointsList: _pointsList,
                          colors: _usedColors,
                          center: Offset(centerX, centerY),
                        ),
                        child: Container(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          if (_showControls) ...[
            GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _controlPanelHeight -= details.delta.dy;
                  _controlPanelHeight = _controlPanelHeight.clamp(200.0, 500.0);
                });
              },
              child: Container(
                height: _controlPanelHeight,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: _buildControlPanel(theme, strings),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _clearDrawing,
              child: Text(strings['clear']!),
            ),
          ),
        ],
      ),
    );
  }

  double _evaluateFormula(String formula, double time) {
    try {
      // Заменяем переменные на значения
      formula = formula
          .replaceAll('A', amplitudeX.toString())
          .replaceAll('f', frequencyX.toString())
          .replaceAll('p', phaseX.toString())
          .replaceAll('t', time.toString())
          .replaceAll('pi', pi.toString())
          .replaceAll(' ', '');

      return _evaluateExpression(formula);
    } catch (e) {
      print('Error evaluating formula: $formula');
      return 0;
    }
  }

  double _evaluateExpression(String expression) {
    try {
      // Обработка умножения перед функциями (23*cos, 10*sin)
      if (expression.contains('*cos(')) {
        List<String> parts = expression.split('*cos(');
        double coeff = double.tryParse(parts[0]) ?? 1.0;
        String arg = parts[1].substring(0, parts[1].length - 1);
        return coeff * cos(_evaluateExpression(arg));
      } else if (expression.contains('*sin(')) {
        List<String> parts = expression.split('*sin(');
        double coeff = double.tryParse(parts[0]) ?? 1.0;
        String arg = parts[1].substring(0, parts[1].length - 1);
        return coeff * sin(_evaluateExpression(arg));
      }
      // Обработка простых операций
      else if (expression.contains('+')) {
        List<String> parts = expression.split('+');
        return _evaluateExpression(parts[0]) + _evaluateExpression(parts[1]);
      } else if (expression.contains('-')) {
        List<String> parts = expression.split('-');
        return _evaluateExpression(parts[0]) - _evaluateExpression(parts[1]);
      } else if (expression.contains('*')) {
        List<String> parts = expression.split('*');
        return _evaluateExpression(parts[0]) * _evaluateExpression(parts[1]);
      } else if (expression.contains('/')) {
        List<String> parts = expression.split('/');
        return _evaluateExpression(parts[0]) / _evaluateExpression(parts[1]);
      }
      // Числовые значения
      return double.tryParse(expression) ?? 0;
    } catch (e) {
      print('Error evaluating expression: $expression');
      return 0;
    }
  }

  Widget _buildControlPanel(ThemeData theme, Map<String, String> strings) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SwitchListTile(
            title: Text(strings['custom_formula']!),
            value: _showCustomFormula,
            onChanged: (value) => setState(() {
              _showCustomFormula = value;
              _pointsList.add([]);
              _usedColors.add(figureColor);
              _customFormulaStarted = false;
            }),
          ),
          if (_showCustomFormula) ...[
            _buildFormulaField(
              label: strings['formula_x']!,
              controller: _formulaXController,
              focusNode: _formulaXFocus,
            ),
            _buildFormulaField(
              label: strings['formula_y']!,
              controller: _formulaYController,
              focusNode: _formulaYFocus,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _startCustomFormula,
              child: Text(strings['start']!),
            ),
            const SizedBox(height: 20),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildSlider(
                    label: strings['frequency_x']!,
                    value: frequencyX,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) => setState(() => frequencyX = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSlider(
                    label: strings['frequency_y']!,
                    value: frequencyY,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) => setState(() => frequencyY = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSlider(
                    label: strings['amplitude_x']!,
                    value: amplitudeX,
                    min: 50,
                    max: 200,
                    onChanged: (value) => setState(() => amplitudeX = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSlider(
                    label: strings['amplitude_y']!,
                    value: amplitudeY,
                    min: 50,
                    max: 200,
                    onChanged: (value) => setState(() => amplitudeY = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSlider(
                    label: strings['phase_x']!,
                    value: phaseX,
                    min: 0,
                    max: 2 * pi,
                    onChanged: (value) => setState(() => phaseX = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSlider(
                    label: strings['phase_y']!,
                    value: phaseY,
                    min: 0,
                    max: 2 * pi,
                    onChanged: (value) => setState(() => phaseY = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: _buildSlider(
                  label: strings['speed']!,
                  value: speed,
                  min: 0.1,
                  max: 3.0,
                  onChanged: (value) => setState(() => speed = value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings['color']!),
                    const SizedBox(height: 8),
                    DropdownButton<Color>(
                      value: figureColor,
                      isExpanded: true,
                      items: [
                        _buildColorItem(Colors.red),
                        _buildColorItem(Colors.blue),
                        _buildColorItem(Colors.green),
                        _buildColorItem(Colors.purple),
                        _buildColorItem(Colors.orange),
                      ],
                      onChanged: (color) {
                        if (color != null) {
                          _changeColor(color);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }

  String _getColorName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.green) return 'Green';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.orange) return 'Orange';
    return 'Custom';
  }

  DropdownMenuItem<Color> _buildColorItem(Color color) {
    final colorName = _getColorName(color);

    return DropdownMenuItem(
      value: color,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            colorName,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
            Text(value.toStringAsFixed(2)),
          ],
        ),
      ],
    );
  }
}

class _LissajousPainter extends CustomPainter {
  final List<List<Offset>> pointsList;
  final List<Color> colors;
  final Offset center;

  _LissajousPainter({
    required this.pointsList,
    required this.colors,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(center.dx - 150, center.dy),
      Offset(center.dx + 150, center.dy),
      axisPaint,
    );

    canvas.drawLine(
      Offset(center.dx, center.dy - 150),
      Offset(center.dx, center.dy + 150),
      axisPaint,
    );

    for (int i = 0; i < pointsList.length; i++) {
      final points = pointsList[i];
      final color = colors[i];

      if (points.length > 1) {
        final paint = Paint()
          ..color = color
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

        final path = Path()..moveTo(points[0].dx, points[0].dy);
        for (var j = 1; j < points.length; j++) {
          path.lineTo(points[j].dx, points[j].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
