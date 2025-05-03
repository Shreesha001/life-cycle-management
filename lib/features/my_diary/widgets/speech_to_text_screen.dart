import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextScreen extends StatefulWidget {
  final String targetField;

  const SpeechToTextScreen({required this.targetField});

  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  String _status = 'Tap the mic to start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _stopListening();
        }
      },
      onError: (error) {
        setState(() {
          _status = 'Error: ${error.errorMsg}';
        });
      },
    );

    if (!available) {
      setState(() {
        _status = 'Speech recognition unavailable';
      });
    }
  }

  void _startListening() {
    setState(() {
      _status = 'Listening...';
      _isListening = true;
    });

    _speech.listen(
      onResult: (val) {
        setState(() {
          _text = val.recognizedWords;
        });
      },
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
      _status = 'Stopped';
    });

    Navigator.pop(context, {'target': widget.targetField, 'text': _text});
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Speak Now', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 100,
                color: _isListening ? Colors.red : Colors.white54,
              ),
              SizedBox(height: 20),
              Text(
                _status,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      _text.isEmpty ? 'Say something...' : _text,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(_isListening ? Icons.stop : Icons.mic),
                label: Text(
                  _isListening ? 'Stop' : 'Start Speaking',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: _isListening ? _stopListening : _startListening,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
