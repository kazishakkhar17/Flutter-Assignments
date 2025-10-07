import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/theme_provider.dart'; // fontSizeProvider & themeProvider should be defined here
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // Navigate to Home page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Theme switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: isDark,
                  onChanged: (val) {
                    ref.read(themeProvider.notifier).setTheme(
                        val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Font size slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Font Size'),
                Expanded(
                  child: Slider(
                    value: fontSize,
                    min: 12,
                    max: 30,
                    divisions: 18,
                    label: fontSize.toStringAsFixed(0),
                    onChanged: (val) {
                      ref.read(fontSizeProvider.notifier).setFontSize(val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Back button for redundancy
            ElevatedButton(
              onPressed: () {
                context.go('/'); // Go back to Home page
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
