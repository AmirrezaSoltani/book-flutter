import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AIBookPage extends StatefulWidget {
  const AIBookPage({super.key});

  @override
  State<AIBookPage> createState() => _AIBookPageState();
}

class _AIBookPageState extends State<AIBookPage> {
  final TextEditingController _promptController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isGenerating = false;
  bool _isSpeaking = false;
  String _selectedGenre = 'Fantasy';
  String _selectedVoice = 'en-US';
  double _speechRate = 0.5;
  double _pitch = 1.0;
  
  final List<String> _genres = [
    'Fantasy',
    'Science Fiction',
    'Mystery',
    'Adventure',
    'Educational',
    'Bedtime Stories',
  ];

  final List<Map<String, String>> _voices = [
    {'name': 'US English', 'locale': 'en-US'},
    {'name': 'UK English', 'locale': 'en-GB'},
    {'name': 'Australian English', 'locale': 'en-AU'},
    {'name': 'Indian English', 'locale': 'en-IN'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_selectedVoice);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(_pitch);
    
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _speak(String text) async {
    if (text.isEmpty) return;
    
    setState(() {
      _isSpeaking = true;
    });
    
    await _flutterTts.speak(text);
  }

  Future<void> _stopSpeaking() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _generateBook() {
    if (_promptController.text.isEmpty) return;
    
    setState(() {
      _isGenerating = true;
    });

    // TODO: Implement AI book generation logic
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGenerating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('AI Book Creator'),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  // TODO: Show generation history
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Genre Selection
                  const Text(
                    'Select Genre',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _genres.length,
                      itemBuilder: (context, index) {
                        final genre = _genres[index];
                        final isSelected = genre == _selectedGenre;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(genre),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedGenre = genre;
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Voice Selection
                  const Text(
                    'Select Voice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _voices.length,
                      itemBuilder: (context, index) {
                        final voice = _voices[index];
                        final isSelected = voice['locale'] == _selectedVoice;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(voice['name']!),
                            selected: isSelected,
                            onSelected: (selected) async {
                              if (selected) {
                                setState(() {
                                  _selectedVoice = voice['locale']!;
                                });
                                await _flutterTts.setLanguage(_selectedVoice);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Speech Rate Slider
                  const Text(
                    'Speech Rate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: _speechRate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: '${(_speechRate * 100).round()}%',
                    onChanged: (value) async {
                      setState(() {
                        _speechRate = value;
                      });
                      await _flutterTts.setSpeechRate(value);
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Prompt Input with Voice Button
                  const Text(
                    'Describe Your Book',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      TextField(
                        controller: _promptController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Describe the story, characters, or theme you want...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: IconButton(
                          icon: Icon(
                            _isSpeaking ? Icons.stop : Icons.record_voice_over,
                            color: _isSpeaking ? Colors.red : Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            if (_isSpeaking) {
                              _stopSpeaking();
                            } else {
                              _speak(_promptController.text);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isGenerating ? null : _generateBook,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isGenerating
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Generate Book',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Recent Generations
                  const Text(
                    'Recent Generations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Placeholder for recent generations
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.auto_stories),
                          title: Text('Generated Book ${index + 1}'),
                          subtitle: Text('Genre: $_selectedGenre'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // TODO: Navigate to book details
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 