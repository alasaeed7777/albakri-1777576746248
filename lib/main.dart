```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _operator;
  bool _isNewNumber = true;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isNewNumber) {
        _display = digit;
        _isNewNumber = false;
      } else {
        if (_display == '0' && digit != '.') {
          _display = digit;
        } else {
          _display += digit;
        }
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_operator != null && !_isNewNumber) {
        _calculateResult();
      }
      _firstOperand = double.tryParse(_display);
      _operator = op;
      _expression = '$_display $op';
      _isNewNumber = true;
    });
  }

  void _onEqualsPressed() {
    setState(() {
      if (_operator != null && !_isNewNumber) {
        _calculateResult();
        _operator = null;
        _expression = '';
        _isNewNumber = true;
      }
    });
  }

  void _calculateResult() {
    final double secondOperand = double.tryParse(_display) ?? 0;
    double result = 0;
    switch (_operator) {
      case '+':
        result = (_firstOperand ?? 0) + secondOperand;
        break;
      case '-':
        result = (_firstOperand ?? 0) - secondOperand;
        break;
      case 'Ã':
        result = (_firstOperand ?? 0) * secondOperand;
        break;
      case 'Ã·':
        if (secondOperand != 0) {
          result = (_firstOperand ?? 0) / secondOperand;
        } else {
          _display = 'Ø®Ø·Ø£';
          _expression = '';
          _operator = null;
          _firstOperand = null;
          _isNewNumber = true;
          return;
        }
        break;
      case '%':
        result = (_firstOperand ?? 0) % secondOperand;
        break;
      default:
        return;
    }
    _display = result == result.truncateToDouble() && !result.isInfinite
        ? result.toInt().toString()
        : result.toStringAsFixed(4);
    _firstOperand = result;
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _isNewNumber = true;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.isNotEmpty && _display != '0') {
        _display = _display.substring(0, _display.length - 1);
        if (_display.isEmpty) {
          _display = '0';
          _isNewNumber = true;
        }
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_display.contains('.')) {
        _display += '.';
        _isNewNumber = false;
      }
    });
  }

  void _onPercentagePressed() {
    setState(() {
      final value = double.tryParse(_display) ?? 0;
      _display = (value / 100).toString();
      _isNewNumber = true;
    });
  }

  void _onToggleSignPressed() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-$_display';
      }
    });
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color foregroundColor,
    double? width,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: width ?? 70,
      height: 70,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(
                      fontSize: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _display,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      text: 'AC',
                      backgroundColor: colorScheme.errorContainer,
                      foregroundColor: colorScheme.onErrorContainer,
                      onPressed: _onClearPressed,
                    ),
                    _buildButton(
                      text: 'â«',
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      onPressed: _onDeletePressed,
                    ),
                    _buildButton(
                      text: '%',
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      onPressed: _onPercentagePressed,
                    ),
                    _buildButton(
                      text: 'Ã·',
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      onPressed: () => _onOperatorPressed('Ã·'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      text: '7',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('7'),
                    ),
                    _buildButton(
                      text: '8',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('8'),
                    ),
                    _buildButton(
                      text: '9',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('9'),
                    ),
                    _buildButton(
                      text: 'Ã',
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      onPressed: () => _onOperatorPressed('Ã'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      text: '4',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('4'),
                    ),
                    _buildButton(
                      text: '5',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('5'),
                    ),
                    _buildButton(
                      text: '6',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('6'),
                    ),
                    _buildButton(
                      text: '-',
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      onPressed: () => _onOperatorPressed('-'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      text: '1',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('1'),
                    ),
                    _buildButton(
                      text: '2',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('2'),
                    ),
                    _buildButton(
                      text: '3',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => _onDigitPressed('3'),
                    ),
                    _buildButton(
                      text: '+',
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      onPressed: () => _onOperatorPressed('+'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      text: 'Â±',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: _onToggleSignPressed,
                    ),
                    _buildButton(
                      text: '0',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      width: 152,
                      onPressed: () => _onDigitPressed('0'),
                    ),
                    _buildButton(
                      text: '.',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: _onDecimalPressed,
                    ),
                    _buildButton(
                      text: '=',
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      onPressed: _onEqualsPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```