import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenshotBlocker extends StatefulWidget {
  final Widget child;
  final bool blockOnLongPress;
  final bool blockOnDoubleTap;
  final bool showFeedback;
  final VoidCallback? onBlockedAttempt;

  const ScreenshotBlocker({
    Key? key,
    required this.child,
    this.blockOnLongPress = true,
    this.blockOnDoubleTap = false,
    this.showFeedback = true,
    this.onBlockedAttempt,
  }) : super(key: key);

  @override
  State<ScreenshotBlocker> createState() => _ScreenshotBlockerState();
}

class _ScreenshotBlockerState extends State<ScreenshotBlocker> {
  DateTime? _lastTap;
  int _tapCount = 0;

  void _handleTap() {
    final now = DateTime.now();

    if (_lastTap == null ||
        now.difference(_lastTap!) > const Duration(milliseconds: 500)) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTap = now;

    // Block on rapid tapping (potential screenshot shortcut)
    if (_tapCount >= 3) {
      _blockAction('Rapid tapping detected');
    }
  }

  void _handleLongPress() {
    if (widget.blockOnLongPress) {
      _blockAction('Long press blocked');
    }
  }

  void _handleDoubleTap() {
    if (widget.blockOnDoubleTap) {
      _blockAction('Double tap blocked');
    }
  }

  void _blockAction(String reason) {
    if (widget.showFeedback) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action blocked for security: $reason'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    widget.onBlockedAttempt?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      onDoubleTap: _handleDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}
