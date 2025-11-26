import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedAnswer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Apa itu algoritma?',
      'options': [
        'Bahasa pemrograman',
        'Langkah-langkah untuk menyelesaikan masalah',
        'Tipe data',
        'Fungsi matematika'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'Manakah yang merupakan struktur data linear?',
      'options': ['Tree', 'Graph', 'Array', 'Hash Table'],
      'correctAnswer': 2,
    },
    {
      'question': 'Apa fungsi dari keyword "if" dalam pemrograman?',
      'options': [
        'Mengulang kode',
        'Membuat fungsi',
        'Kondisi percabangan',
        'Mendefinisikan variabel'
      ],
      'correctAnswer': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${_currentQuestionIndex + 1}/${_questions.length}'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
            ),
            const SizedBox(height: 24),
            Text(
              currentQuestion['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              currentQuestion['options'].length,
              (index) => RadioListTile<int>(
                title: Text(currentQuestion['options'][index]),
                value: index,
                groupValue: _selectedAnswer,
                onChanged: _isAnswered
                    ? null
                    : (value) {
                        setState(() {
                          _selectedAnswer = value;
                        });
                      },
              ),
            ),
            const Spacer(),
            if (_isAnswered)
              Column(
                children: [
                  Text(
                    _selectedAnswer == currentQuestion['correctAnswer']
                        ? 'Jawaban Benar! 🎉'
                        : 'Jawaban Salah. Jawaban yang benar: ${currentQuestion['options'][currentQuestion['correctAnswer']]}',
                    style: TextStyle(
                      color: _selectedAnswer == currentQuestion['correctAnswer']
                          ? Colors.green
                          : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAnswered ? _nextQuestion : _submitAnswer,
                child: Text(_isAnswered
                    ? (_currentQuestionIndex < _questions.length - 1 ? 'Pertanyaan Selanjutnya' : 'Selesai')
                    : 'Jawab'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) return;

    setState(() {
      _isAnswered = true;
      if (_selectedAnswer == _questions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Kuis Selesai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Skor Anda: $_score/${_questions.length}'),
            const SizedBox(height: 16),
            Text(
              _score >= _questions.length * 0.7
                  ? 'Selamat! Anda lulus kuis ini.'
                  : 'Coba lagi untuk mendapatkan skor yang lebih baik.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}