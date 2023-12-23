import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/data.dart';
import 'package:quiz/quiz_database.dart';
import 'package:quiz/quiz_shared_prefs.dart';

import 'mock_generation.dart';



Future<List<Question>> fetchQuiz() async {

  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.initDatabase();

  var lastAPICall = await getLastAPICall();

  if(lastAPICall ==0 && DateTime.now().millisecondsSinceEpoch - lastAPICall > 300000){

    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/worldline/learning-kotlin-multiplatform/main/quiz.json'));

    if (response.statusCode == 200) {
      // If the server returned a 200 OK response, parse the JSON
      var questionsList = Quiz.fromJson(jsonDecode(response.body) as Map<String, dynamic>).questions;
      dbHelper.insertQuestionsWithAnswers(questionsList);
      storeLastAPICall(DateTime.now().millisecondsSinceEpoch);

      return questionsList;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      return await generateDummyQuestionsList();
    }
  }else {
    return dbHelper.getQuestionsWithAnswers();
  }
}