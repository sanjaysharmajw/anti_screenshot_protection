import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecureText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool hideWhenInactive;
  final String hiddenText;
  final Duration hideDelay;
  final bool preventSelection;

  const SecureText(
    this.text, {
    Key? key,
    this.style,
    this.hideWhenInactive = true,
    this.hiddenText = '••••••••',
    this.hideDelay = const Duration(seconds: 10),
    this.preventSelection = true,
  }) : super(key: key);

  @override
  State<SecureText> createState() => _SecureTextState();
}

class _SecureTextState extends State<SecureText> with WidgetsBindingObserver {
  bool _isVisible = true;
  bool _isAppActive = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startHideTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.hideDelay, () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    setState(() {
      _isAppActive = state == AppLifecycleState.resumed;
      if (!_isAppActive) {
        _isVisible = false;
      }
    });
  }

  void _onTap() {
    if (!_isVisible && _isAppActive) {
      setState(() {
        _isVisible = true;
      });
      _startHideTimer();
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = (_isVisible && _isAppActive)
        ? widget.text
        : widget.hiddenText;

    Widget textWidget = Text(displayText, style: widget.style);

    if (widget.preventSelection) {
      textWidget = SelectionContainer.disabled(child: textWidget);
    }

    return GestureDetector(onTap: _onTap, child: textWidget);
  }
}
