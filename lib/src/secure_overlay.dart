import 'dart:ui';

import 'package:flutter/material.dart';

class SecureOverlay extends StatelessWidget {
  final Color? overlayColor;
  final String? warningMessage;
  final Widget? customWarningWidget;
  final bool blurBackground;
  final double blurIntensity;

  const SecureOverlay({
    super.key,
    this.overlayColor,
    this.warningMessage,
    this.customWarningWidget,
    this.blurBackground = true,
    this.blurIntensity = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(color: overlayColor ?? Colors.black87),
        child: blurBackground
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurIntensity,
                  sigmaY: blurIntensity,
                ),
                child: _buildContent(context),
              )
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (customWarningWidget != null) {
      return customWarningWidget!;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security, size: 80, color: Colors.white),
          const SizedBox(height: 24),
          Text(
            warningMessage ?? 'Protected Content',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Content is temporarily hidden for security',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
