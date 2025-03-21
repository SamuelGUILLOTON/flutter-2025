import 'package:quiz/services/quiz_service.dart';
import 'package:quiz/data.dart';
import 'package:quiz/models/quiz_question.dart';

Future<List<Question>> fetchQuiz() async {
  // Utiliser le service existant pour charger les questions du CSV
  final quizService = QuizService();
  final csvQuestions = await quizService.loadQuestionsFromCSV();
  
  // Convertir QuizQuestion en Question
  final questions = csvQuestions.map((csvQuestion) {
    final answers = csvQuestion.options.asMap().entries.map((entry) {
      return Answer(
        id: entry.key + 1, 
        label: entry.value
      );
    }).toList();
    
    return Question(
      id: 0, // Vous pouvez générer un ID si nécessaire
      label: csvQuestion.question,
      correctAnswerId: csvQuestion.correctAnswerIndex + 1, // +1 car vos index commencent à 1
      answers: answers,
    );
  }).toList();
  
  return questions;
}