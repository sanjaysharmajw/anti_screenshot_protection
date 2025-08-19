# Pure Dart Anti-Screenshot Protection

A Flutter package that provides anti-screenshot protection without requiring native platform code. This package uses pure Dart/Flutter implementations to protect sensitive content.

## 🌟 Features

- ✅ **Pure Dart Implementation** - No native code required
- 🛡️ **App Lifecycle Protection** - Hides content when app goes to background
- 👆 **Gesture Detection** - Detects suspicious tap patterns
- 🔒 **Secure Text Widget** - Auto-hiding sensitive text
- 🌫️ **Blur Protection** - Animated blur effects for protection
- 📱 **Cross-Platform** - Works on iOS and Android
- 🎯 **Widget-Level** - Apply protection to specific widgets
- ⚡ **Lightweight** - Minimal performance impact

## 🚀 Installation

```yaml
dependencies:
anti_screenshot_protection: ^1.0.1
```

## 📖 Usage

### Basic Protection

```dart
AntiScreenshotWidget(
child: YourSensitiveContent(),
)
```

### Advanced Usage

```dart
AntiScreenshotWidget(
enabled: true,
warningMessage: 'Protected Content',
blurBackground: true,
blurIntensity: 10.0,
onProtectionTriggered: () {
print('Protection activated!');
},
child: YourSensitiveContent(),
)
```

### Secure Text

```dart
SecureText(
'Credit Card: 1234 5678 9012 3456',
hideDelay: Duration(seconds: 10),
preventSelection: true,
)
```

### Gesture Blocking

```dart
ScreenshotBlocker(
blockOnLongPress: true,
showFeedback: true,
onBlockedAttempt: () {
print('Suspicious gesture detected!');
},
child: YourContent(),
)
```

### Blur Protection

```dart
BlurProtection(
blurSigma: 15.0,
animationDuration: Duration(milliseconds: 500),
child: YourContent(),
)
```

## 🔧 How It Works

### App Lifecycle Protection
- Monitors app lifecycle states
- Automatically hides content when app goes to background
- Shows protection overlay during inactive states

### Gesture Detection
- Detects rapid tapping patterns
- Blocks long press gestures
- Provides haptic feedback for blocked actions

### Secure Text
- Automatically hides after specified duration
- Prevents text selection
- Tap to reveal hidden text

### Blur Effects
- Animated blur transitions
- Customizable blur intensity
- Overlay color options

## ⚠️ Limitations

Since this is a pure Dart implementation, it has some limitations compared to native implementations:

1. **Cannot prevent system screenshots** - Only hides content from view
2. **App switching protection only** - Protects during app lifecycle changes
3. **No screen recording detection** - Cannot detect active screen recording
4. **Gesture-based protection** - Relies on detecting suspicious patterns

## 💡 Best Practices

1. **Combine Multiple Layers**: Use multiple protection widgets together
2. **User Education**: Inform users about protection measures
3. **Reasonable Timeouts**: Don't hide content too aggressively
4. **Accessibility**: Ensure protection doesn't break accessibility features
5. **Testing**: Test on both platforms and different screen sizes

## 🔒 Security Considerations

This package provides **UI-level protection** and should be combined with other security measures:

- Server-side validation
- Data encryption
- Certificate pinning
- Biometric authentication
- Secure storage solutions

## 🤝 When to Use Native Code

Consider native implementations for:
- System-level screenshot prevention
- Screen recording detection
- Hardware-based security features
- Enterprise security requirements

## 📝 License

MIT License - feel free to use in your projects!