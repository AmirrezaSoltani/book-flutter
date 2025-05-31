import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      _isInitialized = true;
    }
  }

  Future<void> speak(String text) async {
    await initialize();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> setVoice(String voice) async {
    await _flutterTts.setVoice({'name': voice, 'locale': 'en-US'});
  }

  Future<void> setRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  Future<List<Map<String, String>>> getVoices() async {
    final voices = await _flutterTts.getVoices;
    return List<Map<String, String>>.from(voices);
  }
} 