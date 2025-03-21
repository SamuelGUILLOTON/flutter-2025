import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:quiz/models/quiz_question.dart';

class QuizService {
  Future<List<QuizQuestion>> loadQuestionsFromCSV() async {
    final rawData = await rootBundle.loadString('assets/quiz_questions.csv');
    final List<List<dynamic>> csvTable = CsvToListConverter().convert(rawData);
    
    // Ignorer l'en-tête si présent
    final dataRows = csvTable.length > 1 ? csvTable.sublist(1) : csvTable;
    
    return dataRows.map((row) => QuizQuestion.fromList(row)).toList();
  }
}