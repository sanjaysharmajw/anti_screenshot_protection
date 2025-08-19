import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../anti_screenshot_protection.dart';

class AntiScreenshotWidget extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final Color? overlayColor;
  final String? warningMessage;
  final Widget? customWarningWidget;
  final VoidCallback? onProtectionTriggered;
  final Duration hideDelay;
  final bool blurBackground;
  final double blurIntensity;

  const AntiScreenshotWidget({
    Key? key,
    required this.child,
    this.enabled = true,
    this.overlayColor,
    this.warningMessage,
    this.customWarningWidget,
    this.onProtectionTriggered,
    this.hideDelay = const Duration(milliseconds: 300),
    this.blurBackground = true,
    this.blurIntensity = 5.0,
  }) : super(key: key);

  @override
  State<AntiScreenshotWidget> createState() => _AntiScreenshotWidgetState();
}

class _AntiScreenshotWidgetState extends State<AntiScreenshotWidget>
    with WidgetsBindingObserver {
  bool _isProtected = false;
  bool _isAppInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!widget.enabled) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _setProtectionState(false);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _setProtectionState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _setProtectionState(true);
        break;
    }
  }

  void _setProtectionState(bool protected) {
    if (protected != _isProtected) {
      setState(() {
        _isProtected = protected;
        _isAppInBackground = protected;
      });

      if (protected) {
        widget.onProtectionTriggered?.call();
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        // Original content
        widget.child,

        // Protection overlay
        if (_isProtected)
          SecureOverlay(
            overlayColor: widget.overlayColor,
            warningMessage: widget.warningMessage,
            customWarningWidget: widget.customWarningWidget,
            blurBackground: widget.blurBackground,
            blurIntensity: widget.blurIntensity,
          ),
      ],
    );
  }
}
