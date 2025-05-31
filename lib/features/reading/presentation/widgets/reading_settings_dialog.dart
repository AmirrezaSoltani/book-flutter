import 'package:flutter/material.dart';
import '../models/reading_settings.dart';

class ReadingSettingsDialog extends StatefulWidget {
  final ReadingSettings initialSettings;
  final Function(ReadingSettings) onSettingsChanged;

  const ReadingSettingsDialog({
    super.key,
    required this.initialSettings,
    required this.onSettingsChanged,
  });

  @override
  State<ReadingSettingsDialog> createState() => _ReadingSettingsDialogState();
}

class _ReadingSettingsDialogState extends State<ReadingSettingsDialog> {
  late ReadingSettings _settings;
  final List<String> _fontFamilies = ['Roboto', 'Merriweather', 'Lora', 'Open Sans'];

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Reading Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Font Family
            DropdownButtonFormField<String>(
              value: _settings.fontFamily,
              decoration: const InputDecoration(
                labelText: 'Font Family',
                border: OutlineInputBorder(),
              ),
              items: _fontFamilies.map((font) {
                return DropdownMenuItem(
                  value: font,
                  child: Text(font),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _settings = _settings.copyWith(fontFamily: value);
                  });
                  widget.onSettingsChanged(_settings);
                }
              },
            ),
            const SizedBox(height: 16),
            // Font Size
            Row(
              children: [
                const Text('Font Size'),
                Expanded(
                  child: Slider(
                    value: _settings.fontSize,
                    min: 14,
                    max: 24,
                    divisions: 10,
                    label: _settings.fontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(fontSize: value);
                      });
                      widget.onSettingsChanged(_settings);
                    },
                  ),
                ),
                Text(_settings.fontSize.round().toString()),
              ],
            ),
            const SizedBox(height: 16),
            // Line Spacing
            Row(
              children: [
                const Text('Line Spacing'),
                Expanded(
                  child: Slider(
                    value: _settings.lineSpacing,
                    min: 1.0,
                    max: 2.0,
                    divisions: 10,
                    label: _settings.lineSpacing.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(lineSpacing: value);
                      });
                      widget.onSettingsChanged(_settings);
                    },
                  ),
                ),
                Text(_settings.lineSpacing.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 16),
            // Dark Mode
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _settings.isDarkMode,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(
                    isDarkMode: value,
                    backgroundColor: value ? Colors.black87 : Colors.white,
                    textColor: value ? Colors.white : Colors.black87,
                  );
                });
                widget.onSettingsChanged(_settings);
              },
            ),
            const SizedBox(height: 16),
            // Close Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
} 