import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:music_player/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart'; // Import for CupertinoSwitch

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dark mode text
            const Text(
              "Dark Mode",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            // Switch for toggling theme

            CupertinoSwitch(
              value:
                Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme(),
            )
          ],
        ),
      ),
    );
  }
}
