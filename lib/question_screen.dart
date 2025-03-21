import 'package:flutter/material.dart';
import 'package:quiz/models/quiz_question.dart';
import 'package:quiz/services/quiz_service.dart';
import 'dart:async';

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
  
  // Variables pour le mode "Pression du temps"
  int _timeRemaining = 20; // Temps en secondes pour chaque question
  Timer? _timer;
  int _bonusPoints = 0;
  bool _showTimerWarning = false;
  
  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final questions = await _quizService.loadQuestionsFromCSV();
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
    _startTimer();
  }
  
  void _startTimer() {
    // Réinitialiser le timer pour la nouvelle question
    _timeRemaining = 20;
    _showTimerWarning = false;
    
    // Annuler l'ancien timer s'il existe
    _timer?.cancel();
    
    // Créer un nouveau timer qui s'exécute chaque seconde
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
          
          // Afficher un avertissement quand il reste peu de temps
          if (_timeRemaining <= 5 && !_showTimerWarning) {
            _showTimerWarning = true;
          }
        } else {
          // Temps écoulé, passer à la question suivante
          timer.cancel();
          _moveToNextQuestion(null); // Aucune réponse sélectionnée
        }
      });
    });
  }
  
  // Calculer les points bonus en fonction du temps restant
  int _calculateBonusPoints() {
    // Plus il reste de temps, plus le bonus est élevé
    return (_timeRemaining / 20 * 10).round(); // Max 10 points bonus
  }

  void _answerQuestion(int selectedIndex) {
    // Arrêter le timer
    _timer?.cancel();
    
    final isCorrect = selectedIndex == _questions[_currentQuestionIndex].correctAnswerIndex;
    
    if (isCorrect) {
      final bonus = _calculateBonusPoints();
      setState(() {
        _score++;
        _bonusPoints += bonus;
      });
      
      // Afficher un message de bonus
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correct! +1 point et +$bonus points bonus de rapidité!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect! La bonne réponse était: ${_questions[_currentQuestionIndex].options[_questions[_currentQuestionIndex].correctAnswerIndex]}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }
    
    _moveToNextQuestion(selectedIndex);
  }
  
  void _moveToNextQuestion(int? selectedIndex) {
    if (_currentQuestionIndex < _questions.length - 1) {
      // Attendre que le message Snackbar soit affiché avant de passer à la question suivante
      Future.delayed(const Duration(milliseconds: 1200), () {
        setState(() {
          _currentQuestionIndex++;
        });
        _startTimer(); // Démarrer le timer pour la nouvelle question
      });
    } else {
      // Quiz terminé, naviguer vers l'écran de score
      int totalScore = _score + _bonusPoints;
      Navigator.pushReplacementNamed(
        context, 
        '/Score',
        arguments: {
          'score': totalScore, 
          'total': _questions.length,
          'correctAnswers': _score,
          'bonusPoints': _bonusPoints
        },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: _showTimerWarning ? Colors.red : null,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_timeRemaining s',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _showTimerWarning ? Colors.red : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Barre de progression du temps
                      LinearProgressIndicator(
                        value: _timeRemaining / 20,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _timeRemaining > 5 ? Colors.blue : Colors.red,
                        ),
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
                      const SizedBox(height: 20),
                      Text(
                        'Score: $_score + $_bonusPoints points bonus',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}