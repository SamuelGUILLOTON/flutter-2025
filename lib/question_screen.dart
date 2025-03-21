import 'package:flutter/material.dart';
import 'package:quiz/models/quiz_question.dart';
import 'package:quiz/services/quiz_service.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final QuizService _quizService = QuizService();
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _quizService.loadQuestionsFromCSV();
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _answerQuestion(int selectedIndex) {
    final isCorrect = selectedIndex == _questions[_currentQuestionIndex].correctAnswerIndex;
    
    if (isCorrect) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Passer le score à l'écran de résultat
      Navigator.pushReplacementNamed(
        context, 
        '/Score',
        arguments: {'score': _score, 'total': _questions.length},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? const Center(child: Text('Aucune question trouvée'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _questions[_currentQuestionIndex].question,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ..._questions[_currentQuestionIndex].options
                          .asMap()
                          .entries
                          .map((entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ElevatedButton(
                                  onPressed: () => _answerQuestion(entry.key),
                                  child: Text(entry.value),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
    );
  }
}