import 'package:flutter/material.dart';
import 'package:anti_screenshot_protection/anti_screenshot_protection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Dart Anti-Screenshot Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _protectionEnabled = true;
  int _blockedAttempts = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pure Dart Anti-Screenshot Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Control Panel
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Protection Controls',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Enable Protection'),
                      subtitle: Text(
                        _protectionEnabled
                            ? 'Content will be hidden when app goes to background'
                            : 'No protection active',
                      ),
                      value: _protectionEnabled,
                      onChanged: (value) {
                        setState(() {
                          _protectionEnabled = value;
                        });
                      },
                    ),
                    if (_blockedAttempts > 0) ...[
                      const Divider(),
                      Text(
                        'Blocked Attempts: $_blockedAttempts',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Protected Content Area
            Expanded(
              child: AntiScreenshotWidget(
                enabled: _protectionEnabled,
                warningMessage: 'Sensitive Information Protected',
                onProtectionTriggered: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Protection activated!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: ScreenshotBlocker(
                  onBlockedAttempt: () {
                    setState(() {
                      _blockedAttempts++;
                    });
                  },
                  child: BlurProtection(
                    enabled: _protectionEnabled,
                    child: Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: Colors.red.shade700,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Sensitive Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            const Text(
                              'Banking Details:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),

                            const SecureText(
                              'Account: 1234 5678 9012 3456',
                              style: TextStyle(fontFamily: 'monospace'),
                            ),
                            const SizedBox(height: 4),

                            const SecureText(
                              'PIN: 9876',
                              style: TextStyle(fontFamily: 'monospace'),
                              hideDelay: Duration(seconds: 5),
                            ),
                            const SizedBox(height: 4),

                            const SecureText(
                              'Balance: \$50,000.00',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.shade300,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'This content is protected:\n'
                                      '• Hidden when app goes to background\n'
                                      '• Gesture detection for suspicious activity\n'
                                      '• Text automatically hides after timeout',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Protection:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Press home button - content will be hidden\n'
                      '2. Try rapid tapping on protected area\n'
                      '3. Wait for secure text to auto-hide\n'
                      '4. Tap hidden text to reveal it again',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
