import 'dart:async';
import 'package:flutter/material.dart';

class AppLifecycleDetector {
  static final AppLifecycleDetector _instance =
      AppLifecycleDetector._internal();
  factory AppLifecycleDetector() => _instance;
  AppLifecycleDetector._internal();

  final StreamController<AppLifecycleState> _stateController =
      StreamController<AppLifecycleState>.broadcast();

  AppLifecycleState? _currentState;
  bool _isInitialized = false;

  Stream<AppLifecycleState> get stateStream => _stateController.stream;
  AppLifecycleState? get currentState => _currentState;

  void initialize() {
    if (_isInitialized) return;

    _isInitialized = true;
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
  }

  void _updateState(AppLifecycleState state) {
    if (_currentState != state) {
      _currentState = state;
      _stateController.add(state);
    }
  }

  void dispose() {
    _stateController.close();
  }
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final AppLifecycleDetector detector;

  _AppLifecycleObserver(this.detector);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    detector._updateState(state);
  }
}
