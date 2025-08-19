import 'dart:ui';

import 'package:flutter/material.dart';

class BlurProtection extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final double blurSigma;
  final Color overlayColor;
  final Duration animationDuration;

  const BlurProtection({
    super.key,
    required this.child,
    this.enabled = true,
    this.blurSigma = 10.0,
    this.overlayColor = Colors.transparent,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<BlurProtection> createState() => _BlurProtectionState();
}

class _BlurProtectionState extends State<BlurProtection>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  bool _shouldBlur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: widget.blurSigma).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!widget.enabled) return;

    final shouldBlur = state != AppLifecycleState.resumed;

    if (shouldBlur != _shouldBlur) {
      setState(() {
        _shouldBlur = shouldBlur;
      });

      if (_shouldBlur) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blurAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            widget.child,
            if (_blurAnimation.value > 0)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: Container(
                    color: widget.overlayColor.withValues(
                      alpha: (_blurAnimation.value / widget.blurSigma * 0.3),
                    ),

                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
